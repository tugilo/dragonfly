# SPEC-014 — チャプター定例会議事録の DB 化

**Status:** active（Phase 180 実装）  
**Related:** [MEETING_DOMAIN_IA.md](MEETING_DOMAIN_IA.md), [DATA_MODEL.md](DATA_MODEL.md) §4.6a, [CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md](CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md)（SPEC-016・議事録からのリファーラル提案・実装未着手）

---

## 1. 目的

完了済み定例会について、`docs/meetings/chapter/` の Markdown 議事録を Religo DB に取り込み、Meetings 画面から閲覧できるようにする。

---

## 2. 非目標

- 管理画面からの議事録編集
- DB → Markdown の書き出し
- `contact_memos`（例会メモ）との統合

---

## 3. データモデル

テーブル **`meeting_minutes`**（`meetings` と 1:1）。

| カラム | 型 | 説明 |
|--------|-----|------|
| `id` | bigint PK | |
| `meeting_id` | FK unique | `meetings.id`, cascadeOnDelete |
| `body_markdown` | longText | front matter 除く本文 |
| `source_path` | string | 取り込み元ファイルパス（リポジトリ相対） |
| `doc_type` | string nullable | front matter |
| `session_date` | date nullable | front matter |
| `session_time_jst` | string nullable | |
| `session_time_note` | text nullable | |
| `format` | string nullable | |
| `source` | string nullable | 取得元説明 |
| `front_matter` | json nullable | 解析結果全体 |
| `imported_at` | timestamp | 最終取り込み日時 |
| timestamps | | |

---

## 4. 取り込みコマンド

```bash
# 単一ファイル
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-chapter-minutes docs/meetings/chapter/chapter_weekly_20260512.md

# ディレクトリ一括
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-chapter-minutes docs/meetings/chapter/

# オプション上書き
php artisan dragonfly:import-chapter-minutes path/to/file.md --meeting_number=207 --held_on=2026-05-12
```

### 処理

1. YAML front matter を `Symfony\Component\Yaml\Yaml` で解析
2. `meeting_number` / `session_date` で `Meeting::updateOrCreate(['number' => N], ['held_on' => ...])`
3. `MeetingMinute::updateOrCreate(['meeting_id' => ...], [...])`
4. 再取り込み時は同一 `meeting_id` の行を上書き（重複行は作らない）

---

## 5. API

| Method | Path | 説明 |
|--------|------|------|
| GET | `/api/meetings/{id}/minutes` | `{ minutes: { body_markdown, source_path, ... } \| null }` |

`GET /api/meetings` / `show` にも `has_minutes` / `minutes` を含める。

---

## 6. UI

- Meetings 一覧: `has_minutes` で Chip / フィルタ（「あり」Chip クリックで Drawer + 議事録モーダル）
- Meetings Drawer: 議事録は **Dialog モーダル**（共有 `MarkdownView`）。Drawer タブは 概要 / 参加者 / BO / メモ。Fit/Gap: [FIT_AND_GAP_MARKDOWN_VIEWER.md](FIT_AND_GAP_MARKDOWN_VIEWER.md)
- 参加者PDF: 概要・参加者タブ・一覧 Actions から登録（Phase 183）
- Connections: 選択中 meeting の Meetings へ導線（`?tab=minutes` → 議事録モーダル）

---

## 7. DoD

- [x] migration + Model + Meeting リレーション
- [x] import コマンド + Feature テスト
- [x] API + Meetings UI（議事録モーダル・Phase 183）
- [x] 既存 4 件の chapter_weekly を取り込み可能
- [x] SSOT / Registry / INDEX / progress 更新
