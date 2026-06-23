# チームMTG議事録 DB 化 — SSOT

**Spec ID:** SPEC-018（[SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md) 参照）  
**Status:** completed（Phase 234–239 で SPEC-018 実装・docs 同期完了）  
**作成:** 2026-06-23 19:25 JST  
**Related:** [CHAPTER_MINUTES_REQUIREMENTS.md](CHAPTER_MINUTES_REQUIREMENTS.md)（SPEC-014）、[MEETING_DOMAIN_IA.md](MEETING_DOMAIN_IA.md)、[DATA_MODEL.md](DATA_MODEL.md) §4.6 / §4.6a / §4.6b、[meetings/team/README.md](../meetings/team/README.md)

---

## 1. 目的

BNI パワーチーム等の **チーム MTG** 議事録（`docs/meetings/team/`）を、チャプター定例会（SPEC-014）と同様に Religo DB へ取り込み、**Meetings 履歴から種別ごとに閲覧**できるようにする。

**source of truth = Markdown。** DB は file→DB の一方向コピー（再取り込みで上書き）。

---

## 2. 非目標（初期スコープ）

| 項目 | 理由 |
|------|------|
| 管理画面からの議事録編集 | SPEC-014 と同じ方針 |
| DB → Markdown 書き出し | 一方向のみ |
| チーム MTG の **参加者** 構造化（`participants` 取込） | チャプター定例会専用機能。チーム MTG は議事録閲覧のみ |
| チーム MTG の **BO** / Connections 連携 | 同室割当は定例会ドメイン |
| Zoom 自動同期 | 1to1 専用（SPEC-012）。チーム MTG は Zoom 要約 Markdown 手動/半自動取込 |
| **リファーラル提案**（SPEC-016） | チャプター定例会向け抽出。チーム MTG は Phase F 以降で別 Spec 検討 |
| `contact_memos`（個人例会メモ）との統合 | 別ファセットのまま |

---

## 3. 背景と設計判断

### 3.1 なぜ `meeting_types` マスタか

現行 `meetings.session_type` は PHP 定数（`MeetingDisplay::SESSION_TYPES`）で 3 種のみ:

| code | 用途 |
|------|------|
| `chapter_weekly` | 番号付き定例会 |
| `momentum_training` | モメンタム（回数外） |
| `business_open_day` | BOD（回数外） |

チーム MTG（`team_meeting`）や将来の Webマスター MTG（`webmaster_meeting`）を追加するには、種別ごとに **採番要否・参加者/BO/リファーラル対応可否** を持つマスタが必要。

**方針:** `meeting_types` テーブルを正とし、`meetings.meeting_type_id` で参照。`session_type` 文字列は **移行期の互換列**として当面維持（`meeting_types.code` と同期）。

### 3.2 なぜ `team_id` 列か

非番号イベントの upsert キー `(session_type, held_on)` では、**同一日に複数チーム**（例: 火曜 8:00 スリーバイス + 別チーム）が衝突する。

**チーム MTG の自然キー:**

```
(meeting_type.code = team_meeting, team_id, held_on)
```

`team_id` は front matter の slug（例: `threebiz`）。`team_name_ja` は表示名として `meetings.name` または `front_matter` に保持。

### 3.3 `meeting_minutes` は再利用

SPEC-014 で定義済みの `meeting_minutes` 形状（`body_markdown`, `source_path`, `front_matter` JSON 等）は **種別非依存**でそのまま使う。1 meeting : 1 minute 行（UNIQUE on `meeting_id`）を維持。

---

## 4. データモデル

### 4.1 `meeting_types`（新規）

| カラム | 型 | 説明 |
|--------|-----|------|
| `id` | bigint PK | |
| `code` | string UK | 安定識別子（例: `chapter_weekly`, `team_meeting`） |
| `name_ja` | string | 管理画面・一覧表示名 |
| `is_numbered` | boolean | `meetings.number` 必須か |
| `requires_team_id` | boolean | `meetings.team_id` 必須か（`team_meeting` のみ true） |
| `supports_participants` | boolean | 参加者 PDF/CSV 取込 UI を出すか |
| `supports_breakouts` | boolean | BO / Connections 導線を出すか |
| `supports_referral_suggestions` | boolean | SPEC-016 リファーラル提案を出すか |
| `sort_order` | int | 一覧フィルタ・選択肢の並び |
| `is_active` | boolean | 新規作成・取り込み対象 |
| timestamps | | |

**初期 seed（案）:**

| code | name_ja | is_numbered | requires_team_id | participants | breakouts | referral |
|------|---------|-------------|------------------|--------------|-----------|----------|
| `chapter_weekly` | 定例会 | true | false | true | true | true |
| `momentum_training` | モメンタム | false | false | true | true | true |
| `business_open_day` | BOD | false | false | true | true | true |
| `team_meeting` | チームMTG | false | true | false | false | false |
| `webmaster_meeting` | WebマスターMTG | false | false | false | false | false |

`webmaster_meeting` は seed のみ先行定義。取り込み・UI は **後続 Phase**。

### 4.2 `meetings`（拡張）

既存列に加え:

| カラム | 型 | 説明 |
|--------|-----|------|
| `meeting_type_id` | FK → meeting_types.id | **正**の種別参照 |
| `team_id` | string nullable | チーム slug（`team_meeting` 時必須） |
| `session_type` | string | **legacy 互換**（`meeting_types.code` と同期） |

**ユニーク制約（実装時）:**

| 種別 | upsert キー |
|------|-------------|
| 番号付き（`is_numbered=true`） | `number` UNIQUE（既存） |
| チーム MTG | `(meeting_type_id, team_id, held_on)` UNIQUE |
| その他非番号 | `(meeting_type_id, held_on)` UNIQUE — 現行 `(session_type, held_on)` を置換 |

**backfill:** 既存行は `session_type` から `meeting_type_id` を埋める migration。

### 4.3 `meeting_minutes`（変更なし）

SPEC-014 / DATA_MODEL §4.6a と同一。`doc_type` に `team_meeting` を追加。

---

## 5. Markdown ソース（チーム MTG）

### 5.1 パス・命名

```
docs/meetings/team/team_<slug>_YYYYMMDD.md
```

例: `team_threebiz_20260623.md`

詳細: [meetings/team/README.md](../meetings/team/README.md)

### 5.2 front matter（必須・推奨）

| キー | 必須 | 用途 |
|------|------|------|
| `doc_type` | 推奨 | `team_meeting` |
| `team_id` | **必須** | `meetings.team_id` |
| `team_name_ja` | 推奨 | 表示名（`meetings.name` 既定値） |
| `session_date` | **必須** | `meetings.held_on`（YYYY-MM-DD） |
| `session_time_jst` | 任意 | `meeting_minutes.session_time_jst` |
| `session_time_note` | 任意 | |
| `format` | 任意 | 例: `zoom` |
| `source` | 任意 | 取得元 |
| `related_chapter_weekly` | 任意 | 同日定例会への参照（DB FK なし・リンクのみ） |
| `presenter_ja` | 任意 | 主な登壇者（メタ保存） |
| `chapter` | 推奨 | `bni_dragonfly` |

**付けないキー:** `meeting_number`（定例会回数に含めない）

---

## 6. 取り込みコマンド

### 6.1 新規コマンド（実装 Phase）

```bash
# 単一ファイル
php artisan dragonfly:import-team-minutes docs/meetings/team/team_threebiz_20260623.md

# ディレクトリ一括（team_*.md）
php artisan dragonfly:import-team-minutes docs/meetings/team/
```

**処理（idempotent）:**

1. YAML front matter 解析（`Symfony Yaml` — SPEC-014 と同型）
2. `doc_type: team_meeting` を検証
3. `team_id` / `session_date` 必須検証
4. `Meeting::updateOrCreate` キー: `(meeting_type_id=team_meeting, team_id, held_on)`
5. `meetings.name` 既定: `{team_name_ja} チームMTG`（未指定時は `{team_id} チームMTG`）
6. `MeetingMinute::updateOrCreate` on `meeting_id`（本文・メタ・`front_matter` 全文）
7. `session_type = team_meeting` を legacy 列にも書く

**再取り込み:** 同一自然キーで上書き。`meeting_minutes` 行は増殖しない。

### 6.2 既存コマンドとの関係

| コマンド | 対象 |
|----------|------|
| `dragonfly:import-chapter-minutes` | `docs/meetings/chapter/chapter_weekly_*`, `chapter_bod_*` |
| `dragonfly:import-team-minutes` | `docs/meetings/team/team_*.md` |
| `dragonfly:import-1to1-notes` | `docs/meetings/1to1/` |

---

## 7. API（実装 Phase）

### 7.1 一覧拡張 `GET /api/meetings`

**新規クエリパラメータ:**

|  param | 説明 |
|--------|------|
| `meeting_type` | `meeting_types.code` でフィルタ（例: `team_meeting`） |
| `team_id` | チーム slug でフィルタ（`team_meeting` と併用） |

**各行に追加するフィールド（案）:**

| フィールド | 説明 |
|------------|------|
| `meeting_type_code` | 例: `team_meeting` |
| `meeting_type_name_ja` | 例: `チームMTG` |
| `team_id` | nullable |
| `supports_participants` | 種別メタ（UI 出し分け） |
| `supports_breakouts` | |
| `supports_referral_suggestions` | |

既存: `has_minutes`, `display_label`, `session_type`（互換）

### 7.2 種別マスタ `GET /api/meeting-types`（案）

フィルタ UI 用。`is_active=true` のみ。sort_order 昇順。

### 7.3 議事録 API

`GET /api/meetings/{id}/minutes` — **変更なし**（読み取り専用）。チーム MTG も同一エンドポイント。

---

## 8. UI（Meetings ハブ）

### 8.1 一覧

| 項目 | 要件 |
|------|------|
| **種別フィルタ** | Select: すべて / 定例会 / モメンタム / BOD / チームMTG / … |
| **チームフィルタ** | 種別=チームMTG 選択時のみ `team_id` Select を表示 |
| **議事録 Chip** | 既存 `has_minutes` 動作を種別問わず維持 |
| **サブタイトル** | 「例会管理 / 議事録 / BO / メモ」→ 種別混在を明示（例: 「集会・議事録履歴」） |

### 8.2 Drawer / モーダル（種別別）

| ファセット | chapter_* | team_meeting |
|------------|-----------|--------------|
| 概要 + 議事録モーダル | 表示 | 表示 |
| 参加者 PDF/CSV | 表示 | **非表示** |
| BO タブ + Connections 導線 | 表示 | **非表示** |
| 個人メモ（contact_memos） | 表示 | 任意（初期は表示可・BO 導線なし） |
| リファーラル提案 | 表示（SPEC-016） | **非表示** |

### 8.3 議事録モーダル

既存 `MarkdownView` + `source_path` 表示を再利用。未取込時のヘルプ文言を種別に応じて出し分け:

- 定例会: `dragonfly:import-chapter-minutes`
- チーム MTG: `dragonfly:import-team-minutes`

**モック比較:** 実装 Phase では [MOCK_UI_VERIFICATION.md](MOCK_UI_VERIFICATION.md) に従い、Meetings 一覧フィルタ・Drawer 出し分けを [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) に記録。

---

## 9. 関連 SSOT の更新範囲

| ファイル | 更新内容 |
|----------|----------|
| [CHAPTER_MINUTES_REQUIREMENTS.md](CHAPTER_MINUTES_REQUIREMENTS.md) | モメンタム/BOD 取込可能の記述整合。チーム MTG は SPEC-018 参照 |
| [MEETING_DOMAIN_IA.md](MEETING_DOMAIN_IA.md) | Meeting ハブを種別横断 IA に拡張 |
| [DATA_MODEL.md](DATA_MODEL.md) | §4.6b `meeting_types`、`meetings` 拡張 |
| [SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md) | SPEC-018 登録 |

**更新しない（初期）:** SPEC-016（定例会リファーラル）、SPEC-012（Zoom 1to1）

---

## 10. 実装 Phase 順序（DoD チェックリスト）

### Phase A — DB（implement） — Phase 235 完了

- [x] migration: `meeting_types` + seed
- [x] migration: `meetings.meeting_type_id`, `meetings.team_id` + backfill + UNIQUE 制約
- [x] Model: `MeetingType`, `Meeting` リレーション
- [x] `MeetingDisplay` team_meeting 定数・doc_type マップ
- [x] Feature test: backfill・UNIQUE 衝突

### Phase B — 取り込み（implement） — Phase 236 完了

- [x] `ImportTeamMinutesCommand` + Feature test（単一・一括・再取込・team_id 必須）
- [x] 既存 `team_threebiz_*.md` 5 件の取込 smoke

### Phase C — API（implement） — Phase 237 完了

- [x] `GET /api/meeting-types`
- [x] `GET /api/meetings` フィルタ + 種別メタ列
- [x] `MeetingController` show に種別メタ
- [x] Feature test

### Phase D — UI（implement） — Phase 238 完了

- [x] MeetingsList: 種別・チームフィルタ
- [x] Drawer タブ / アクション出し分け
- [x] 議事録モーダルヘルプ文言
- [x] `npm run build`
- [x] FIT_AND_GAP 記録

### Phase E — docs 同期 — Phase 239 完了

- [x] `meetings/team/README.md` DB 連携節
- [x] INDEX / progress / import-religo skill 更新

---

## 11. テスト方針

| レイヤ | 内容 |
|--------|------|
| Feature | import コマンド、API フィルタ、UNIQUE upsert |
| Unit | `MeetingDisplay` / 種別メタ解決 |
| 手動 | Meetings 一覧で種別フィルタ → チーム MTG 行 → 議事録モーダル |

---

## 12. 用語

| 用語 | 定義 |
|------|------|
| **チーム MTG** | BNI パワーチーム等の定例会前後枠ミーティング |
| **team_id** | チーム slug（ファイル名 `team_<slug>_` と一致） |
| **種別（meeting type）** | `meeting_types.code`。集会の性質（定例会 / チーム / …） |
| **議事録** | `meeting_minutes.body_markdown`。会全体の記録 |

---

## 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-06-23 19:25 | Phase 234 初版。meeting_types・team_id・取込/API/UI/実装順序を要件確定 |
| 2026-06-23 22:21 | Phase 239。Phase A–E 完了を反映（Status: completed） |
