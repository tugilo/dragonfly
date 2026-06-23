# SPEC-019 — 1to1 議事録マルチセッション取り込み（file→DB・複数回）

**Status:** draft（要件確定・**実装未着手**）  
**Related:** [DATA_MODEL.md](DATA_MODEL.md) §1.2 / §4.12, [meetings/1to1/README.md](../meetings/1to1/README.md), [ZOOM_IMPORT_DEDUP_REQUIREMENTS.md](ZOOM_IMPORT_DEDUP_REQUIREMENTS.md), [ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md)（SPEC-006）, [ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md](ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md)（SPEC-015）

---

## 1. 目的

`docs/meetings/1to1/` の **1相手1ファイル** 議事録（`### 【第N回】` で複数セッションを管理）をソースに、**各回に対応する `one_to_ones` 行**を作成または更新する。

- **Markdown:** 相手ごとに1ファイルにまとめる運用は **変更しない**（[meetings/1to1/README.md](../meetings/1to1/README.md)）。
- **DB:** `one_to_ones` は **1行 = 1回**（[DATA_MODEL.md](DATA_MODEL.md) §4.12）。

現行 `dragonfly:import-1to1-notes` は **1ファイル → 1レコード**・`notes` に **ファイル全文**を格納するため、複数回ある相手（例: 西浦雅 #66/#78、木村秀継 #22/#38、倉持 #10/#14）で **手動の行作成 + id 追記 + 再 import** が必要だった。本 Spec はそのギャップを埋める。

---

## 2. 非目標（初版）

- 定例会議事録（`docs/meetings/chapter/`）から 121 を自動抽出する（→ [CHAPTER_MINUTES_REQUIREMENTS.md](CHAPTER_MINUTES_REQUIREMENTS.md) SPEC-014 は別ドメイン）
- DB → Markdown の書き出し
- 管理画面からの **一括取り込み** UI（CLI 拡張を先に）
- 一覧メモモーダル以外の **Edit 専用 UI**（当該回メモ vs 共有メモの分割編集は将来）
- プロフィール・累積インサイト・サマリーを **各回の `notes` に重複コピー**する（→ §4.5: 共有 `contact_memos` または Markdown 上のみ）
- `*_requirements_*.md` 等、**セッション記録ではない派生文書**の取り込み（例: `1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md`）
- `one_to_ones` 行の **削除・マージ**（履歴保持ポリシーに反する）
- 議事録 Markdown への **`one_to_ones.id` 自動追記**（初版はログ出力のみ。自動追記は後続 Phase で検討）

---

## 3. 現状（As-Is）

### 3.1 コマンド `dragonfly:import-1to1-notes`

| 項目 | 現状 |
|------|------|
| 入力 | `docs/meetings/1to1/1to1_*.md` 単一またはディレクトリ一括 |
| 突合 | `notes` 内 source path / basename / 本文の **最初の** `one_to_ones.id` |
| `notes` | front matter 除く **ファイル全文** + `【ソース: path】` |
| 新規行 | **作成しない**（レコード未存在は skip） |
| オプション | `--dry-run`, `--only-ids=` |

### 3.2 運用ギャップ

- 第2回以降は tinker 等で `one_to_ones` を手動作成し、議事録に id を追記してから import
- 1行に全文が入ると、一覧プレビュー・リファーラル AI（SPEC-015）の「その回の記録」とずれる

---

## 4. 目標（To-Be）

1. **1ファイル内の `### 【第N回】` ブロックを検出**し、回ごとに DB 操作する。
2. 各 `one_to_ones.notes` には **当該回のセクション本文のみ**を格納する（ファイル全文は入れない）。
3. 既存 id があれば **更新**、条件を満たす未登録回は **`--create-missing` 時のみ新規行作成**。
4. `--dry-run` で **回ごと**の create / update / skip を表示する。

### 4.5 履歴とメモの住み分け（製品方針・合意）

| レイヤ | 粒度 | 内容 |
|--------|------|------|
| **`one_to_ones`（121 履歴）** | **1回 = 1レコード** | 予定・実施・キャンセル、日時、`status`。履歴一覧・Activity・リファーラル AI の「どの回か」は **行 id** で識別する。 |
| **`one_to_ones.notes`** | **当該回のみ** | その回で話した内容・決定・次アクション。**回をまたぐ文脈はここに重複コピーしない。** |
| **`contact_memos`（メモ）** | **owner × target で共有可** | `one_to_one_id` は **任意**（null = ペア共通メモ）。基本プロフィール・最新サマリー・累積インサイト・戦略メモなど、**複数回に共通する文脈**はこちらに置いてよい。 |

**Markdown との対応:**

- `### 【第N回】` → `one_to_ones` 行（+ 当該セクションのみ `notes`）
- `## ■ 基本プロフィール` / `## ■ サマリー` / `## ■ 累積インサイト` 等 → **各回の `notes` には入れない**。DB 化する場合は **共有 `contact_memos`**（`memo_type = one_to_one`, `one_to_one_id = null`）を第一候補（import の **P2 以降・任意**）。Markdown 上だけに残す運用も可。

**UI との整合（一覧・メモモーダル — 合意）:**

- **121 履歴は行ごと**（日時・status・相手）。**メモ列の「メモあり」**をタップすると、**例会議事録と同型の Markdown モーダル**で **相手との共通ドキュメント**（1相手1ファイル相当の全文）を開く。
- 同一相手の **別の回の行**からタップしても、**同じ共通ファイル**が表示される（当該行の `one_to_ones.notes` だけを見せない）。
- 表示内容の第一候補: Markdown ソース（`【ソース: docs/meetings/1to1/…】`）に対応する **シリーズ全文**。DB のみの場合は共有 `contact_memos` ＋ 各回 `notes` を **ファイル構造に近い形で再構成**した本文。
- **Edit 画面**の `GET/POST /api/one-to-ones/{id}/memos` は **当該回の追記メモ**のまま（一覧モーダルとは別導線）。詳細は §4.6。

---

## 4.6 一覧「メモあり」モーダル（UI 要件・合意）

### 4.6.1 導線

| 要素 | 要件 |
|------|------|
| トリガー | 一覧 **メモ列**の **「メモあり」** Chip（`OneToOnesList`・現行と同位置） |
| 表示 | **Dialog / モーダル** + `MarkdownView`（[Meetings 議事録モーダル](FIT_AND_GAP_MEETINGS.md) と同系） |
| タイトル例 | `1to1 メモ — {相手名}`（相手所属チャプター名は副表示可・現行維持） |
| フッター | **詳細へ** → `/one-to-ones/{id}`（**タップした行**の Edit。モーダル本文は共通ファイル） |

### 4.6.2 表示本文（共通ファイル）

**「共通ファイル」= owner_member_id × target_member_id の 1to1 シリーズドキュメント**（`docs/meetings/1to1/1to1_*.md` と同内容を想定）。

| ブロック | モーダルに含める |
|----------|------------------|
| 基本プロフィール・サマリー・累積インサイト | **含める**（共有文脈） |
| 各 `### 【第N回】` | **含める**（全回を時系列） |
| 当該行だけの `one_to_ones.notes` 切片のみ | **一覧モーダルの主本文にしない** |

### 4.6.3 「メモあり」Chip の表示条件（案）

| 条件 | Chip |
|------|------|
| 当該行 `notes` が非空 | 表示 |
| 当該行は空でも、同一 owner×target に **共有メモ** または **他回の `notes`** がある | 表示（共通ファイルが開ける） |
| 上記いずれもなし | `—` |

実装 Phase で API が `has_series_memo`（または `series_markdown`）を返す形を推奨。

### 4.6.4 データ取得（実装時・優先順）

1. **ソース path 解決:** いずれかの行 `notes` / 共有メモから `docs/meetings/1to1/…` を抽出 → **DB 上でシリーズ全文を組み立て**（import 済みセクション + 共有メモ。リポジトリの実ファイル直読みは本番デプロイでは不可のため **API 組み立てが正**）。
2. **フォールバック:** 移行期は **全文が1行の `notes`** が残っている行があればその本文を共通ファイルとして表示（現行 import 互換）。
3. **将来:** Markdown ファイルと DB の双方向同期は本 Spec 非目標。

### 4.6.5 現状との Gap

| 項目 | 現状（As-Is） | 目標（To-Be） |
|------|---------------|---------------|
| モーダル本文 | **タップした行の `record.notes`** | **相手共通のシリーズ全文** |
| 同一相手の別行 | 行ごとに異なる本文 | **同一モーダル内容** |

実装は SPEC-019 **P3（UI）** — **Phase 240**（import P1 と同梱）／P2 は Phase 241 予定。

---

## 5. 入力・パース要件

### 5.1 対象ファイル

- パス: `docs/meetings/1to1/1to1_*.md`
- front matter: [meetings/1to1/README.md](../meetings/1to1/README.md) 準拠（`doc_type: 1to1_series`, `counterparty_name_ja`, `1to1_id` 等）

### 5.2 セッション境界

- **主境界:** 見出し `### 【第N回】`（N は数字。`予定` `実施済み` 等のサフィックス可）
- **種別の例:** 第1回が BNI 121、第2回が **総合鑑定** など、回の中身が異なる場合も **同じ `### 【第N回】` 形式で記録**する（`### 【鑑定】` 単独見出しはパース対象外。第2回として `### 【第2回】…総合鑑定` と書く）
- **パース対象外（各回 `notes` には含めない）:** `## ■ 基本プロフィール`, `## ■ サマリー`, `## ■ 累積インサイト` 等（§4.5: 共有メモ候補・import P2 任意）

**初版外（将来）:** `#### 【第N回】`、日付のみ見出し、英語表記セッション見出し。

### 5.3 各セクションから抽出する項目

| 項目 | ソース例 | DB |
|------|----------|-----|
| 回番号 N | `【第2回】` | メタ（`notes` ソース行のアンカー等） |
| 実施日 | `2026-05-29`, 第1回のみ YAML `first_session_date` | `scheduled_at` / `started_at` |
| 時刻 | `14:00–15:00 JST`, `14:00〜` | `started_at` / `ended_at` |
| 状態 | `実施済み` / `予定` / TODO のみ | `status` |
| 既存 id | `one_to_ones.id = **38**` | 更新対象行 |
| 本文 | 当該見出し〜次の `### 【第` または `## ■` まで | `notes` |

### 5.4 `status` 推定（案）

| 条件 | `status` |
|------|----------|
| 見出し・本文に `実施済み`、または Zoom 要約・実施後サマリーが当該セクション内にある | `completed` |
| `予定` 明示、または実施後追記が TODO のみ | `planned` |
| 判定不能 | **skip**（dry-run で警告） |

### 5.5 時刻不明

- 日付のみ・時刻 TODO: `scheduled_at = null` を許容（Phase 120/131 と同系）
- **日付のみで `00:00` を入れることはしない**（誤集計防止）

---

## 6. 相手（target）・owner の特定

### 6.1 `target_member_id`

| 優先 | 方法 |
|------|------|
| 1 | 既存 `one_to_ones.id` がある場合 → その行の `target_member_id` |
| 2 | front matter `counterparty_name_ja` で `members` 照合（全角スペース正規化） |
| 3 | `1to1_id` スラッグと過去 import の source path から推定 |

複数ヒット・未ヒット → **作成しない**。dry-run で報告。

### 6.2 `owner_member_id`

- 既存行更新時: 行の `owner_member_id` を維持
- 新規作成時: CLI **`--owner-member-id=`**（初版は明示必須。既定値は運用で DragonFly 次廣 = `37` を推奨）

### 6.3 `workspace_id`（記録コンテキスト）

- 新規行: オーナー側チャプター（通常 DragonFly `workspaces.id = 1`）
- SPEC-006: `target_member` の所属チャプターとは別でもよい

---

## 7. DB 操作要件

### 7.1 更新（既存 `one_to_ones.id` あり）

- `notes` を **当該セクションのみ**で置換（上書き）
- `notes` 先頭例: `【ソース: docs/meetings/1to1/1to1_xxx.md#第2回】`（パスだけでは複数回を区別できないため **セクション識別子必須**）
- パースできた項目のみ `status`, `scheduled_at`, `started_at`, `ended_at` を更新
- `status = canceled` の行は **上書きしない**

### 7.2 新規作成（`--create-missing` かつ条件充足）

- **1セッション = 1新規行**
- **重複防止:** 同一 `owner_member_id` + `target_member_id` + **同日**（`COALESCE(started_at, scheduled_at)` の日付）の行が既にあれば新規作成せず **既存へバックフィル**（[ZOOM_IMPORT_DEDUP_REQUIREMENTS.md](ZOOM_IMPORT_DEDUP_REQUIREMENTS.md) と同系）
- `external_source = manual` 既定

### 7.3 `notes` の内容（現行からの変更点）

| 現行 | 本 Spec |
|------|---------|
| ファイル全文 | **当該 `【第N回】` セクションのみ** + ソース行 |
| 複数回が1行に蓄積 | 各行がその回だけの議事録 |

リファーラル提案（SPEC-015）・1 to 1 一覧の「メモあり」プレビューと整合する **必須要件**。

---

## 8. CLI 要件

既存 **`dragonfly:import-1to1-notes` の拡張**を第一候補とする。

| オプション | 説明 | 初版デフォルト |
|------------|------|----------------|
| `--dry-run` | 回ごとに create / update / skip を表示 | — |
| `--only-ids=` | 指定 id のセクションのみ（現行維持） | — |
| `--create-missing` | id なしでも条件充足時に新規行作成 | **`false`（安全）** |
| `--owner-member-id=` | 新規作成時の owner | 未指定時はエラーまたは設定値 |

### 8.1 dry-run 出力例

```text
1to1_nishiura_miyabi_draci.md
  [update] #66 第1回 completed 2026-06-04 notes 10288→10288
  [update] #78 第2回 completed 2026-06-14 notes 0→8450
  [skip]   第3回 日時不明
```

### 8.2 実行例（実装後）

```bash
# 突合のみ（回ごと）
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-1to1-notes docs/meetings/1to1/1to1_nishiura_miyabi_draci.md --dry-run

# 既存 id の notes 更新のみ
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-1to1-notes docs/meetings/1to1/

# 未登録回も新規行作成
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-1to1-notes docs/meetings/1to1/ \
  --create-missing --owner-member-id=37
```

---

## 9. 後方互換

`### 【第N回】` 見出しが **1件もない** 旧形式ファイルについて、初版の推奨:

| 案 | 内容 |
|----|------|
| **A（推奨）** | 現行と同様 **ファイル全体を1行**に取り込む（突合ロジックは現行維持） |
| B | エラーとし、`【第1回】` 見出しの追加を促す |

**決定:** 実装 Phase 開始時に A/B を確定する（Open Questions §11）。

---

## 10. エッジケース

| ケース | 扱い |
|--------|------|
| 同一ファイルに同じ `one_to_ones.id` が2回出現 | エラー、または2回目 skip |
| Zoom 取り込み済み（`external_source=zoom`） | `notes` 上書き時に既存 notes 保護オプションを検討（Open Questions） |
| `status=canceled` | 更新対象外 |
| 要件メモのみのファイル（セッション0件） | skip |
| 原文 id 追記後の再 import | id ベースで当該回のみ更新 |

---

## 11. Open Questions（実装前に決定）

| # | 論点 | 推奨（たたき台） |
|---|------|------------------|
| OQ-1 | 後方互換: `【第N回】` なし旧ファイル | **案 A**（全文1行・現行互換） |
| OQ-2 | `--create-missing` のデフォルト | **`false`** |
| OQ-3 | `notes` に冒頭サマリー1段落を含めるか | **決定:** 各回 `notes` には含めない。共有文脈は **`contact_memos`（`one_to_one_id` null 可）** |
| OQ-4 | 日付のみ・時刻 TODO の completed | `scheduled_at=null` のまま `completed` 可（Phase 131 同系） |
| OQ-5 | 議事録への id 自動追記 | 初版は **ログのみ** |
| OQ-6 | 管理画面「議事録から同期」ボタン | 初版は **CLI のみ**（一覧メモモーダルは §4.6・P3） |
| OQ-7 | owner の自動解決 | 初版は **`--owner-member-id` 明示**（将来 SPEC-010 連動） |
| OQ-8 | Zoom 既存行の `notes` 上書き | 手動 notes がある場合はマージまたは skip を検討 |

---

## 12. 受け入れ条件（DoD）

1. `1to1_nishiura_miyabi_draci.md` を `--dry-run` すると **第1回・第2回が別操作**として表示される。
2. `--create-missing` なしでは、既存 id の **`notes` がセクション単位**で更新され、**ファイル全文が入らない**。
3. `1to1_kimura_hidetsugu_kokuhosha.md` で #22（第1回）と #38（第2回）が **それぞれ異なる本文長**で更新される。
4. id 未記載・実施済み・日時ありの第2回で、`--create-missing` 実行時 **重複なく1行作成**される。
5. 同日重複は新規作成されず既存へ紐付け（ZOOM dedup と矛盾しない）。
6. テスト: パーサ単体 + Feature（artisan コマンド）最低 6 ケース。
7. 本 Spec・`SSOT_REGISTRY`・`docs/INDEX.md`・[meetings/1to1/README.md](../meetings/1to1/README.md) を同期。

---

## 13. 実装フェーズ案

| Phase | 内容 |
|-------|------|
| **P1（MVP）** | セクション分割パース + 既存 id のセクション単位 `notes` 更新 + dry-run 複数行表示 |
| **P2** | `--create-missing` + dedup + `--owner-member-id` + **共有ブロック → `contact_memos`（任意）** |
| **P3** | **一覧「メモあり」→ 共通ファイルモーダル**（§4.6）/ 議事録への id 自動追記（任意） |

---

## 14. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-06-23 22:41 JST | Phase 240 PLAN 作成（P1 import + P3 一覧モーダル）。P2 は Phase 241 予定。 |
| 2026-06-23 22:39 JST | §4.6 追加。一覧「メモあり」タップで **相手共通ファイル**を Markdown モーダル表示する UI 合意。P3 に反映。 |
| 2026-06-23 22:36 JST | §4.5 追加。**121 履歴は 1回1レコード**、**メモは owner×target で共有可**（`contact_memos`・`one_to_one_id` 任意）を製品方針として明記。OQ-3 決定。 |
| 2026-06-23 22:33 JST | 初版。複数回 1to1 議事録からの `one_to_ones` マルチセッション取り込み要件を整理（実装未着手）。 |
