# 1to1 ドキュメント（docs/meetings/1to1/）

**目的:** 1対1の関係性・案件化・履歴を **チャプターに依存しない** 場所で管理する。将来、Religo／別システムの **DB に `1to1_series` 相当として取り込む** ことを想定したファイル名・メタデータの約束を定義する。

---

## ファイル命名規約

### 原則

- **1相手（1関係）あたり1ファイル**（複数回のセッションはファイル内の「第N回」で管理）。  
- ファイル名に **日付を含めない**（リネーム地獄を防ぐ）。初回日付は文書内・メタデータに書く。
- スラッグは **英小文字・数字・アンダースコア**（DBの `slug` / `external_id` にそのまま使いやすい）。

### パターン

| 種類 | パターン | 例 |
|------|----------|-----|
| 標準（相手＋組織略） | `1to1_<lastname>_<firstname>_<org_slug>.md` | `1to1_sato_takuto_brightlink.md` |
| カテゴリー識別子 | `1to1_<lastname>_<firstname>_<category_slug>.md` | `1to1_okamoto_kachiteru_present.md` |
| 業種略 | `1to1_<lastname>_<firstname>_<industry_slug>.md` | `1to1_kimura_kengo_mfg_retail.md` |
| テーマ略 | `1to1_<lastname>_<theme_slug>.md` | `1to1_gunji_lstep_webhook.md` |

### 避けるもの

- ファイル名に **「tsugihiro」等、別人名の混入**（過去の誤ファイル名はリネーム済み）
- **意味のない日付プレフィックス**（旧 `2026-04-15_1to1_...`）— 履歴は Git と文書内で追う

---

## 推奨ドキュメント構造（本文）

既存の tugilo 式に合わせ、次のブロックを想定（詳細は各ファイル先頭）。

1. 基本プロフィール（固定）
2. サマリー（最新状況）
3. 1to1履歴（第N回ごとに **日時（開始・終了の時刻まで）・実施方法・話した内容**）
4. 累積インサイト / 戦略 / リファーラル（BNI時） / メモ

---

## DB 取り込み用メタデータ（任意・YAML）

ファイル先頭に **任意** で次のような front matter を付けられる（将来のインポート用）。

```yaml
---
doc_type: 1to1_series
1to1_id: sato_takuto_brightlink          # ファイル名のスラッグと一致推奨
counterparty_name_ja: "佐藤拓斗"
organization_ja: "株式会社BrightLink"
chapter_primary: bni_dragonfly           # 主接点。無ければ null または省略
owner_side: tugilo
first_session_date: "2026-04-03"
first_session_time_jst: "07:15-08:15"   # 必須に近い：日付だけにしない（.cursorrules 参照）
---
```

アプリ側では例えば次の対応が取りやすい。

| 概念 | マッピング例 |
|------|----------------|
| 1to1 関係の主キー | `1to1_id` または `1to1_series.id` |
| セッション | 文書内 `### 【第N回】` をパース、または将来は子テーブル `1to1_session` |
| チャプター | `chapter_primary` + 本文の自由記述 |

テンプレートは [`_TEMPLATE.md`](_TEMPLATE.md) を参照。

---

## 既存ファイル一覧（運用メモ）

INDEX の **「1to1（docs/meetings/1to1/）」** 節と同期すること。
