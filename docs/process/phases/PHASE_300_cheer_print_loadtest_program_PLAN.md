# PHASE_300_cheer_print_loadtest_program PLAN

| 項目 | 内容 |
|------|------|
| **Phase ID** | 300 |
| **Name** | Cheer Print 負荷試験プログラム作成 |
| **Phase Type** | **implement** |
| **Status** | planned |
| **Branch** | `feature/phase300-cheer-print-loadtest-program` |
| **作成** | 2026-08-07 23:26 JST |

## Purpose

Cheer Print イベント時アクセス対策のため、**負荷試験プログラム（k6）**を作成する。  
**実行の第一候補はローカル Docker（`grafana/k6`）**。コンソールでモニタリングしながら実施し、終了後に日本語報告書を自動生成する。  
`tugilo.com`（さくらのVPS）からの実行は **予備**（回線不足時のみ）。Cheer Print 本番 EC2 上では動かさない。  
2026-08-08 22:00〜24:00 JST 枠で Stage A→B→C を実施し、静的入口と WP 本サイトを分けて測定する。

## Background

- 案件実行 SSOT: [`docs/proposals/takemura_cheer_print_event_access_plan.md`](../../proposals/takemura_cheer_print_event_access_plan.md)
- プログラム要件: [`docs/proposals/takemura_cheer_print_loadtest_program_requirements.md`](../../proposals/takemura_cheer_print_loadtest_program_requirements.md) ← **本 Phase の実装根拠**
- 技術別紙: [`docs/proposals/takemura_asobisystem_wp_load_test_proposal.md`](../../proposals/takemura_asobisystem_wp_load_test_proposal.md)
- 実施枠・告知導線は確定（08-08 22–24／静的 `cheer--print.com` + WP）
- **発生元方針（2026-08-07 23:41）:** ローカル Docker 推奨。tugilo.com 常用は避ける

## Related SSOT

| ID / 文書 | 内容 |
|-----------|------|
| （Religo SPEC） | **該当なし**（Religo プロダクト機能ではない） |
| 案件 SSOT | `takemura_cheer_print_event_access_plan.md` |
| ツール要件 | `takemura_cheer_print_loadtest_program_requirements.md` |
| 技術別紙 | `takemura_asobisystem_wp_load_test_proposal.md` |

## Scope

### 変更してよい範囲

| パス | 内容 |
|------|------|
| `tools/cheer-print-loadtest/**` | k6・実行シェル・README・結果／**自動報告書生成**・テンプレート |
| `docs/proposals/takemura_cheer_print_loadtest_program_requirements.md` | 要件（本 Phase で確定） |
| `docs/proposals/takemura_cheer_print_event_access_plan.md` | ツールへのリンク追記 |
| `docs/process/phases/PHASE_300_*` | PLAN／WORKLOG／REPORT |
| `docs/process/PHASE_REGISTRY.md` | Phase 300 登録 |
| `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/proposals/README.md` | 索引・進捗 |

### 変更しない範囲

- `www/**`（Religo Laravel／React）
- Cheer Print 本番サーバー設定
- AWS／WordPress／CDN の実装変更
- 本番枠での実測そのもの（実行は枠内作業。本 Phase の DoD は **プログラム完成**）

## Target Files

- `tools/cheer-print-loadtest/README.md`
- `tools/cheer-print-loadtest/*.js`（k6）
- `tools/cheer-print-loadtest/run.sh`（試験＋報告）
- `tools/cheer-print-loadtest/report/`（報告生成スクリプト・テンプレ）
- `tools/cheer-print-loadtest/results/`（gitignore・出力先）
- 上記 docs

## Implementation Strategy

1. 要件書を正とし、k6 で HTTP GET 主試験を実装する  
2. `static_landing` と `wp_origin` をシナリオ分離  
3. Stage A/B/C は k6 `options.stages` ＋ env で VU／duration を変更可能にする  
4. UA・閾値・abort を安全寄りデフォルトにする  
5. k6 の JSON 出力を入力に、**Markdown／HTML 報告書を自動生成**する  
6. 報告書は「結論→要約→詳細→次アクション」の順。判定は自動ルール  
7. README に **Docker ローカル**と **VPS（tugilo.com）** の両手順を書く（Mac への k6 直入れは必須にしない）  
8. **PLAN 完成後**に実装。本番枠前にドライラン＋サンプル報告まで完了させる  

### 要件サマリ（実装チェック用）

| ID | 要件 |
|----|------|
| FR-1 | Stage A/B/C 相当の段階負荷 |
| FR-2 | 静的入口／WP 本サイトのシナリオ分離 |
| FR-3 | GET のみ・識別 UA・sleep／timeout 設定可 |
| FR-4 | 成功率・p95・エラー率等の出力 |
| FR-5 | 最大 VU・即停止・禁止 URL をデフォルト除外 |
| FR-6 | README による実行手順 |
| **FR-7** | **誰が見ても分かる自動報告書（Markdown必須）** |
| NFR-1 | 主ツール k6 |
| NFR-5 | ブラウザ大量 VU は初期スコープ外 |

## Tasks

- [ ] Task1: 要件書の確定（FR-7 含む）
- [ ] Task2: `tools/cheer-print-loadtest/` 骨格（README・gitignore）
- [ ] Task3: k6 `wp_origin` シナリオ実装
- [ ] Task4: k6 `static_landing` シナリオ実装
- [ ] Task5: Stage A/B/C・env パラメータ・thresholds・UA
- [ ] Task6: 実行ラッパと結果 JSON 出力
- [ ] Task7: **自動報告書生成（Markdown／判定ロジック／次アクション文）**
- [ ] Task8: HTML 報告（推奨）または Markdown→簡易HTML
- [ ] Task9: ドライラン＋サンプル報告書の確認
- [ ] Task10: INDEX／進捗／案件計画リンク、REPORT 下書き

## DoD

- [ ] 要件書（FR/NFR/非スコープ・**FR-7**）が文書化されている  
- [ ] k6 スクリプトで静的／WP を分けて実行できる  
- [ ] Stage 相当の段階負荷が env 等で調整できる  
- [ ] p95・エラー率・成功率が取得できる  
- [ ] 禁止対象 URL がデフォルトに含まれない  
- [ ] README で **Docker ローカル**と **VPS** の実行手順が分かる  
- [ ] **試験後に日本語 Markdown 報告書が自動生成される**  
- [ ] 報告書先頭に **問題なし／要改善／危険** が一目で分かる  
- [ ] ドライラン成功とサンプル報告の記録が WORKLOG にある  
- [ ] PHASE_REGISTRY／INDEX／進捗が更新されている  
- [ ] Religo `www/` を変更していない  

## Out of Scope（本 Phase）

- 制作会社によるインフラ対策の実装そのもの  
- Religo 機能開発  
- 手書きの長文提案書（自動報告の「次アクション」テンプレ以上の個別コンサル文書）  

## Risks / Notes

- 本番枠が **翌日**のため、実装→VPS 配備→ドライラン＋**サンプル報告**を優先する  
- さくらのVPSのスペックが低い場合、VU 上限は発生側都合でも制限される（報告書に注記）  
- 自動判定は目安であり、ビジネス最終判断は人が行う旨を報告書に明記する  

## モック比較

対象外（Religo 管理画面 UI なし）
