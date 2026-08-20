---
name: participants-pdf-csv
description: Convert DragonFly chapter meeting participant PDF to religo_NNN_full.csv using Cursor Grok/Composer, then import via existing CLI. Use when user drops 定例会参加者リスト PDF or asks for PDF→CSV→local DB.
---

# 定例会 参加者PDF → CSV → ローカル取込

## 位置づけ

- **PDF → CSV:** Cursor 上の **Grok または Composer**（会話で動いているエージェント）が行う。**Religo に LLM は載せない。**
- **CSV → DB:** 既存 CLI `dragonfly:import-participants-csv` のみ（Meetings UI の CSV 反映と同系）。
- **PDF 解析 UI（M7-P）** は「候補生成」。本スキルの CSV は **確定に近い入力**（[MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](../../docs/SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md)）。

```bash
COMPOSE="docker compose -f infra/compose/docker-compose.yml --env-file project.env"
```

## いつ使うか

- `docs/pdf/YYMMDD/定例会参加者リスト*.pdf` が届いたとき
- ユーザーが「参加者PDFからCSV」「ローカルへ反映」と言ったとき

## 手順（毎回この順）

### 1. PDF からメタデータを読む

- ページ1付近: `第NNN回` と `YYYY/MM/DD`（開催日）
- ファイル名例: `定例会参加者リスト2026_08_18.pdf` → held_on=`2026-08-18`

### 2. PDF を layout 付きで抽出する

コンテナ内 `pypdf` またはホスト Python で **layout モード**を使う（通常 extract より表が崩れにくい）。

```python
from pypdf import PdfReader
reader = PdfReader("docs/pdf/260817/定例会参加者リスト2026_08_18.pdf")
for i, page in enumerate(reader.pages):
    print(reader.pages[i].extract_text(extraction_mode="layout"))
```

- **ページ1–3:** メンバー表（大カテゴリー見出し・No・名前・よみがな・カテゴリー・役職）
- **最終ページ:** ビジター様 / ゲスト様 / 代理出席（No・名前・カテゴリー・紹介者・アテンド）

### 3. 直前回 CSV を差分の基準にする

- 例: 第218回なら [religo_217_20260804_full.csv](../../docs/pdf/260804/religo_217_20260804_full.csv)
- **メンバー行:** 前回 CSV と PDF を突合し、入会・退会・カテゴリー/役職変更を反映
- **ビジター/ゲスト/代理:** **当日 PDF に載っている行だけ**書く。前週ビジター行を混在させない（第217回 CSV の失敗例）

### 4. CSV 形式（固定）

**ヘッダー（UTF-8 BOM 付き）:**

```text
種別,No,名前,よみがな,大カテゴリー,カテゴリー,役職,紹介者,アテンド,オリエン
```

| 種別 | No | 大カテゴリー | 紹介者・アテンド |
|------|-----|-------------|-----------------|
| メンバー | 1–57 等 | PDF の大カテゴリー | 空 |
| ビジター | 01, 02… | 空 | PDF どおり。アテンドは `、` 区切り |
| ゲスト | 01, 02… | 空 | 紹介者のみ or アテンドあり |
| 代理出席 | 01… | 空 | 紹介者（代理元） |

**表記ルール**

- 氏名・紹介者: **全角スペース**（`　`）で姓と名
- カンマを含む役職: CSV 引用 `"BODサポート,ビジホスサポート"`
- 改行: LF（`\n`）。BOM 必須（Excel 互換）
- 英語行（所在地・英語カテゴリー）は CSV に入れない

**出力先（両方）**

1. `docs/pdf/YYMMDD/religo_{回}_{YYYYMMDD}_full.csv`
2. `www/database/csv/religo_{回}_{YYYYMMDD}_full.csv`（取込パス）

### 5. 人による確認

- 件数: メンバー / ビジター / ゲスト / 代理 の内訳
- 前週ビジターが残っていないか
- 入会メンバー（guest→member）が PDF と一致するか

### 6. ローカル DB 取込（ユーザーが明示したときのみ）

```bash
$COMPOSE exec app php artisan dragonfly:import-participants-csv {回番号} \
  database/csv/religo_{回}_{YYYYMMDD}_full.csv --held_on=YYYY-MM-DD
```

- 例（第218回）:

```bash
$COMPOSE exec app php artisan dragonfly:import-participants-csv 218 \
  database/csv/religo_218_20260818_full.csv --held_on=2026-08-18
```

### 7. 取込後チェック（必須）

1. コマンド出力の **meeting id** と **participant 件数**
2. **SPEC-007:** ゲスト→メンバー入会者は `type+name` 不一致で **別 member 行**になりやすい

```bash
$COMPOSE exec app php artisan tinker --execute="
foreach (['横山　大樹','福島　和也','佐藤　久'] as \$n) {
  echo \$n.': '.\App\Models\Member::where('name',\$n)->count().\" rows\n\";
}
"
```

- 二重があれば **報告のみ**（マージは SPEC-008 / 別 Phase）
3. artisan の **warning**（紹介者未解決等）を WORKLOG または進捗に記録

## やらないこと

- OpenAI / xAI / Cursor SDK を Religo（`www/`）に組み込む
- 確認なしの自動取込
- `make db-push TARGET=prod`（人間確認必須）
- 本 plan ファイル（`.cursor/plans/`）の編集

## 関連

- 取込詳細: `/import-religo`
- SSOT: [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](../../docs/SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md)
- 入会・二重: SPEC-007 [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../docs/SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md)
- Phase 301: [PHASE_301_participants_pdf_csv_cursor_skill_REPORT.md](../../docs/process/phases/PHASE_301_participants_pdf_csv_cursor_skill_REPORT.md)

## WORKLOG 記録

- PDF パス・回数・held_on
- 作成 CSV パス・内訳件数
- import コマンド・meeting id・participant 数
- guest→member 二重の有無
