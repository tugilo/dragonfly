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
| チャプター | `chapter_primary` + 本文の自由記述。BNI メンバー以外の協力者・紹介のみの場合は `other_organization` 等、`null` と併せて README／INDEX を参照 |

**`chapter_primary` の一例（運用）**

- **`bni_dragonfly`** 等 … チャプター会員との主接点
- **`null` / 省略** … 文脈のみ本文で補う
- **`other_organization`** … BNI メンバーではない相手との 1to1 を「その他団体・紹介ネットワーク」として束ねたいときに使用してよい（例: [`1to1_maeda_referral_imaishi.md`](1to1_maeda_referral_imaishi.md)）

---

テンプレートは [`_TEMPLATE.md`](_TEMPLATE.md) を参照。

---

## DB 取り込み（`one_to_ones`）

| レイヤ | ルール |
|--------|--------|
| **Markdown** | **1相手 = 1ファイル**。複数回は `### 【第N回】` で追記（本 README）。 |
| **DB 履歴** | **`one_to_ones` = 1回 = 1行**（[`DATA_MODEL.md`](../../SSOT/DATA_MODEL.md) §4.12）。 |
| **DB メモ** | **`contact_memos` = owner×target で共有可**（`one_to_one_id` 任意。null ならペア共通）。プロフィール・サマリー・累積インサイトは各回 `notes` に重複しない。 |

### 現行コマンド

```bash
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-1to1-notes docs/meetings/1to1/
```

- **1ファイル → 1レコード**、`notes` にファイル全文を格納。
- レコード未存在は **skip**（新規行は手動作成 + 本文に `one_to_ones.id` 追記が必要）。

### 重複防止（必須・2026-07-08 西原海成事例）

**事象:** Zoom 取込で `planned`（例: id=94）ができたあと、別途手動で `completed`（例: id=105）を作り、**同一面談が2行**になった。

| 順序 | やること | やってはいけないこと |
|------|----------|----------------------|
| 1 | Zoom 調整 → できた **`one_to_ones.id` を正**とする | 同じ日・同相手でもう1行作る |
| 2 | 実施後、**同 id** を `completed` + 開始/終了時刻 | 議事録用に新規 id を発行 |
| 3 | Markdown 【第N回】に **その id** を書く | id 未確認のまま import |
| 4 | `import-1to1-notes` で **既存 id の notes のみ更新** | import で新規行を期待する |

**重複発見時:** `notes` / `completed` / Markdown 参照側を残し、Zoom 側の `zoom_meeting_id` を移して **`planned` 空行を削除**。`zoom_meeting_imports.one_to_one_id` も残す行へ付け替え。議事録に統合メモを1行残す。

**確認コマンド（相手 `members.id` 既知）:** `one_to_ones` を `target_member_id` で一覧し、同一 `scheduled_at` 日が2件以上ないか見る（Cursor ルール: `.cursor/rules/1to1-dedup.mdc`）。

### 複数回ある相手（SPEC-019・未実装）

第2回以降は現状 **手動**で `one_to_ones` を追加し、各 `### 【第N回】` ブロックに id を書いてから import する。

将来は [`ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md`](../../SSOT/ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md)（**SPEC-019**）に沿って、`import-1to1-notes` を **セクション単位**に拡張する。

- 各回の `notes` は **当該セクションのみ**（全文ではない）
- `--create-missing` で未登録回の新規行作成（初版デフォルトは off）
- 同日 dedup は [`ZOOM_IMPORT_DEDUP_REQUIREMENTS.md`](../../SSOT/ZOOM_IMPORT_DEDUP_REQUIREMENTS.md) と同系

**一覧 UI（合意）:** メモ列の「メモあり」をタップすると、例会議事録と同型のモーダルで **相手との共通ファイル**（1to1 シリーズ全文）を表示する（当該行の `notes` だけではない）。詳細は SPEC-019 §4.6。

---

## 既存ファイル一覧（運用メモ）

INDEX の **「1to1（docs/meetings/1to1/）」** 節と同期すること。
