# BNI チーム MTG 議事録（docs/meetings/team/）

## 役割

BNI **パワーチーム**（例: スリーバイス）の定例会前後枠 MTG 議事録を Markdown で残す。

| 種別 | ディレクトリ | front matter `doc_type` | `meeting_number` | Religo DB |
|------|--------------|-------------------------|------------------|-----------|
| **チーム MTG** | 本ディレクトリ | `team_meeting` | **付けない** | **実装済み**（SPEC-018 Phase A–D） |

- **チャプター定例会** → [`../chapter/`](../chapter/)
- **1to1** → [`../1to1/`](../1to1/)
- **Webマスター** → [`../webmaster/`](../webmaster/)

---

## ファイル命名

```
team_<slug>_YYYYMMDD.md
```

例:

- `team_threebiz_20260623.md` — スリーバイス（`team_id: threebiz`）2026-06-23 回

`<slug>` は front matter の `team_id` と **一致させる**。

---

## YAML front matter（推奨）

| キー | 必須 | 例 | 備考 |
|------|------|-----|------|
| `doc_type` | 推奨 | `team_meeting` | 取込時に検証 |
| `team_id` | **必須** | `threebiz` | DB `meetings.team_id` |
| `team_name_ja` | 推奨 | `スリーバイス` | 表示名 |
| `chapter` | 推奨 | `bni_dragonfly` | |
| `session_date` | **必須** | `2026-06-23` | `meetings.held_on` |
| `session_time_jst` | 任意 | `08:00-08:45` | |
| `session_time_note` | 任意 | 定例会前枠など | |
| `format` | 任意 | `zoom` | |
| `source` | 任意 | Zoom 文字起こし要約 | |
| `presenter_ja` | 任意 | パーソナル軸共有者 | |
| `related_chapter_weekly` | 任意 | `meetings/chapter/chapter_weekly_20260623.md` | 同日定例会への参照（リンクのみ） |

**付けないキー:** `meeting_number`（定例会回数に含めない）

---

## 本文構成（運用）

前回ファイルをテンプレに、以下を含めると Religo 閲覧・検索に有用:

- サマリー
- 決定事項・共有事項
- アクションアイテム
- 次回予定
- 未確認・保留事項
- 変更履歴（JST 時刻付き）

---

## Religo / DB 連携（SPEC-018）

**source of truth = 本ディレクトリの Markdown。** DB は取り込みコピー（一方向）。

### DB スキーマ（概要）

| テーブル | 役割 |
|----------|------|
| `meeting_types` | 種別マスタ（`team_meeting` 等） |
| `meetings` | `meeting_type_id` + `team_id` + `held_on` |
| `meeting_minutes` | 議事録本文（`meetings` と 1:1） |

**自然キー:** `(meeting_types.code=team_meeting, meetings.team_id, meetings.held_on)`

| 項目 | DB 列 |
|------|--------|
| 種別 | `meeting_types.code = team_meeting` |
| チーム | `meetings.team_id` |
| 開催日 | `meetings.held_on` ← `session_date` |
| 議事録 | `meeting_minutes.body_markdown` 等 |

### 取り込み（`dragonfly:import-team-minutes`）

```bash
# 1ファイル
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-team-minutes docs/meetings/team/team_threebiz_20260623.md

# ディレクトリ一括（team_*.md）
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-team-minutes docs/meetings/team/
```

- idempotent: 同一自然キーで上書き（`meeting_minutes` 行は増殖しない）
- 再取込: ファイル編集後に同コマンドを再実行

### API（Meetings ハブ）

| エンドポイント | 用途 |
|----------------|------|
| `GET /api/meeting-types` | 種別マスタ（フィルタ UI） |
| `GET /api/meetings?meeting_type=team_meeting&team_id=threebiz` | チーム MTG 一覧 |
| `GET /api/meetings/{id}/minutes` | 議事録閲覧（定例会と同一） |

### 管理 UI（Meetings 一覧）

- **種別フィルタ:** チームMTG を選択
- **チームフィルタ:** 種別=チームMTG 時のみ表示（`team_id`）
- **Drawer:** 参加者 PDF / BO / リファーラルは非表示（議事録・メモは表示）
- **議事録モーダル:** 未取込時ヘルプに `import-team-minutes` を表示

詳細 SSOT: [TEAM_MEETING_MINUTES_REQUIREMENTS.md](../../SSOT/TEAM_MEETING_MINUTES_REQUIREMENTS.md)（**SPEC-018**）

---

## 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-06-23 22:21 | Phase 239: DB/API/UI 実装済みを反映。import 手順・自然キー・Meetings 操作を追記 |
| 2026-06-23 19:25 | 初版。命名・front matter・SPEC-018 DB 連携方針を整理 |
