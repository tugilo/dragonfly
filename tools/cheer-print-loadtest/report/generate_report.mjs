#!/usr/bin/env node
/**
 * Generate Japanese Markdown + HTML report from k6 summary JSON files.
 * Usage:
 *   node report/generate_report.mjs --dir results --stamp 20260807_2345
 *   node report/generate_report.mjs results/summary_static_landing_X.json results/summary_wp_origin_X.json
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, '..');

function parseArgs(argv) {
  const out = { files: [], dir: path.join(root, 'results'), stamp: null };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--dir') out.dir = path.resolve(argv[++i]);
    else if (a === '--stamp') out.stamp = argv[++i];
    else if (a.endsWith('.json')) out.files.push(path.resolve(a));
  }
  return out;
}

function pct(rate) {
  if (rate === null || rate === undefined || Number.isNaN(rate)) return '—';
  return `${(rate * 100).toFixed(2)}%`;
}

function ms(v) {
  if (v === null || v === undefined || Number.isNaN(v)) return '—';
  return `${Math.round(v)} ms`;
}

function judge(successRate, p95ms) {
  const okRate = successRate ?? 0;
  const p95 = p95ms ?? 999999;
  if (okRate >= 0.99 && p95 <= 2000) {
    return { key: 'ok', label: '問題なし', reason: `成功率 ${pct(okRate)}・p95 ${ms(p95)} が目安内` };
  }
  if (okRate < 0.95 || p95 > 5000) {
    return { key: 'danger', label: '危険', reason: `成功率 ${pct(okRate)}・p95 ${ms(p95)} が厳しい水準` };
  }
  return { key: 'warn', label: '要改善', reason: `成功率 ${pct(okRate)}・p95 ${ms(p95)} で遅れや不安定さあり` };
}

function rank(key) {
  return { ok: 1, warn: 2, danger: 3 }[key] || 0;
}

function nextActions(overallKey, scenarios) {
  const lines = [];
  if (overallKey === 'ok') {
    lines.push('1. 本番当日は制作会社さんに監視（CPU／ネットワーク／エラー）を依頼する');
    lines.push('2. 告知は静的入口（cheer--print.com）を主にし、WPへの一斉誘導を避ける');
    lines.push('3. 本番直前の強い再試験はしない');
    return lines;
  }

  const staticS = scenarios.find((s) => s.scenario_id === 'static_landing');
  const wpS = scenarios.find((s) => s.scenario_id === 'wp_origin');
  const staticJ = staticS ? judge(staticS.metrics.success_rate, staticS.metrics.http_req_duration_p95_ms) : null;
  const wpJ = wpS ? judge(wpS.metrics.success_rate, wpS.metrics.http_req_duration_p95_ms) : null;

  let n = 1;
  if (wpJ && wpJ.key !== 'ok') {
    lines.push(`${n++}. WordPress側: ページキャッシュ導入／調整を制作会社へ依頼（優先度高）`);
    lines.push(`${n++}. WordPress側: CDN（画像・CSS・JS）と、必要なら一時的なEC2スペックアップを検討`);
  }
  if (staticJ && staticJ.key !== 'ok') {
    lines.push(`${n++}. 静的入口: 画像最適化・CDN・配信サーバ余裕を確認（告知URL側）`);
  }
  lines.push(`${n++}. 会場／SNSの案内は静的入口を先に見せ、WPへ同時に殺到しない導線にする`);
  lines.push(`${n++}. 制作会社と監視項目（CPU・Network・エラーログ）を共有する`);
  return lines;
}

function loadSummaries(args) {
  let files = args.files;
  if (!files.length) {
    const stamp = args.stamp;
    const all = fs.readdirSync(args.dir).filter((f) => f.startsWith('summary_') && f.endsWith('.json'));
    files = all
      .filter((f) => !stamp || f.includes(`_${stamp}.json`))
      .map((f) => path.join(args.dir, f));
  }
  if (!files.length) {
    throw new Error('summary JSON が見つかりません。先に run.sh で試験を実行してください。');
  }
  return files.map((f) => {
    const raw = JSON.parse(fs.readFileSync(f, 'utf8'));
    raw._file = f;
    return raw;
  });
}

function renderMarkdown(scenarios, stamp, overall) {
  const when = new Date().toLocaleString('ja-JP', { timeZone: 'Asia/Tokyo' });
  const rows = scenarios
    .map((s) => {
      const j = judge(s.metrics.success_rate, s.metrics.http_req_duration_p95_ms);
      return `| ${s.scenario_label || s.scenario_id} | ${j.label} | ${pct(s.metrics.success_rate)} | ${ms(s.metrics.http_req_duration_p95_ms)} | ${s.metrics.http_reqs ?? '—'} |`;
    })
    .join('\n');

  const detail = scenarios
    .map((s) => {
      const j = judge(s.metrics.success_rate, s.metrics.http_req_duration_p95_ms);
      const urls = (s.urls || []).map((u) => `- ${u}`).join('\n');
      return `### ${s.scenario_label || s.scenario_id}

- 判定: **${j.label}**（${j.reason}）
- プロファイル: ${s.profile}
- 設定上の最大VU: ${s.max_vu_configured}
- 到達VU目安（vus_max）: ${s.metrics.vus_max ?? '—'}
- リクエスト数: ${s.metrics.http_reqs ?? '—'}
- RPS概算: ${s.metrics.http_reqs_rate != null ? s.metrics.http_reqs_rate.toFixed(2) : '—'}
- 成功率: ${pct(s.metrics.success_rate)}
- 応答 p50: ${ms(s.metrics.http_req_duration_p50_ms)}
- 応答 p95: ${ms(s.metrics.http_req_duration_p95_ms)}
- 応答 p99: ${ms(s.metrics.http_req_duration_p99_ms)}
- 平均応答: ${ms(s.metrics.http_req_duration_avg_ms)}
- sleep: ${s.sleep_sec}s
- 発生元メモ: ${s.source || 'local-docker'}

対象URL:
${urls || '- （未記載）'}
`;
    })
    .join('\n');

  const actions = nextActions(overall.key, scenarios).map((l) => `- ${l}`).join('\n');

  return `# Cheer Print 負荷試験レポート

## 1. 結論

**総合判定: ${overall.label}**

${overall.reason}

> この判定は今回の試験条件（VU・sleep・対象URL）での目安です。無停止の保証ではありません。

## 2. いつ・何をしたか

| 項目 | 内容 |
|------|------|
| レポート生成時刻 | ${when} JST |
| 試験スタンプ | ${stamp || '—'} |
| 発生元 | ローカル Docker（grafana/k6）想定 |
| シナリオ数 | ${scenarios.length} |

## 3. シナリオ別の結果

| シナリオ | 判定 | 成功率 | 遅さの目安（p95） | リクエスト数 |
|----------|------|--------|-------------------|--------------|
${rows}

※ p95＝遅い側の目安（全体の上位遅い側）。成功率＝ほぼ表示できた割合。

## 4. どこから厳しくなったか

段階負荷（弱い→強い）の結果として、上表の **要改善／危険** が出たシナリオがボトルネック候補です。  
静的入口が良くて WordPress が厳しい場合は、告知後の本サイト側対策が中心になります。

## 5. 数字の詳細

${detail}

## 6. 次にやるとよいこと

${actions}

## 7. 注意書き

- 仮想ユーザー（VU）は実来場者数と1対1ではありません
- 画像を全部含むブラウザ体感とは別測定です（今回は主にHTML取得）
- 本番当日の監視・設定変更は制作会社さんの担当範囲です
- 強い再試験は本番直前に行わないでください

---
自動生成: tugilo cheer-print-loadtest / Phase 300
`;
}

function renderHtml(md, overall) {
  const color =
    overall.key === 'ok' ? '#0a7a2f' : overall.key === 'warn' ? '#9a6b00' : '#a10000';
  const escaped = md
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
  // very simple: keep as preformatted markdown for reliability without deps
  return `<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Cheer Print 負荷試験レポート — ${overall.label}</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 2rem; line-height: 1.55; color: #222; }
    .badge { display:inline-block; padding:0.4rem 0.8rem; border-radius:6px; color:#fff; background:${color}; font-weight:700; }
    pre { white-space: pre-wrap; background:#f6f7f8; padding:1rem; border-radius:8px; }
  </style>
</head>
<body>
  <p class="badge">総合判定: ${overall.label}</p>
  <pre>${escaped}</pre>
</body>
</html>
`;
}

function main() {
  const args = parseArgs(process.argv);
  const scenarios = loadSummaries(args);
  const stamp =
    args.stamp ||
    scenarios.map((s) => s.stamp).find(Boolean) ||
    new Date().toISOString().replace(/[-:TZ.]/g, '').slice(0, 12);

  let overall = { key: 'ok', label: '問題なし', reason: '全シナリオが目安内' };
  for (const s of scenarios) {
    const j = judge(s.metrics.success_rate, s.metrics.http_req_duration_p95_ms);
    if (rank(j.key) > rank(overall.key)) {
      overall = {
        key: j.key,
        label: j.label,
        reason: `${s.scenario_label || s.scenario_id}: ${j.reason}`,
      };
    }
  }

  const md = renderMarkdown(scenarios, stamp, overall);
  const html = renderHtml(md, overall);
  const outDir = args.dir;
  fs.mkdirSync(outDir, { recursive: true });
  const mdPath = path.join(outDir, `report_${stamp}.md`);
  const htmlPath = path.join(outDir, `report_${stamp}.html`);
  fs.writeFileSync(mdPath, md, 'utf8');
  fs.writeFileSync(htmlPath, html, 'utf8');

  console.log(`Wrote ${mdPath}`);
  console.log(`Wrote ${htmlPath}`);
  console.log(`総合判定: ${overall.label}`);
}

main();
