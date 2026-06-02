# 定例会ドメイン IA（Meeting 中心）

**Spec ID:** SPEC-014（議事録 DB 化と連携）／Meeting ドメイン全体の IA  
**Status:** active  
**作成日:** 2026-06-02 JST  
**記録:** Phase 180（初版）、Phase 183（議事録モーダル・参加者PDF導線）

---

## 1. 目的

Religo における **定例会（Meeting）** を集約ルートとし、参加者・BO・議事録・メモを 1 回の定例会の下に束ねる。UI の役割分担（Meetings / Connections）をデータモデルと一致させる。

---

## 2. Meeting = 集約ルート

| ファセット | テーブル / データ | 意味 | 編集 UI |
|------------|-------------------|------|---------|
| **参加者** | `participants` | その回に誰が参加したか | Meetings（CSV/PDF 取込） |
| **BO** | `breakout_rooms`, `participant_breakout` | 同室割当 | **Connections**（編集面）／Meetings（読み取り＋導線） |
| **議事録** | `meeting_minutes` | チャプター定例会の全体記録（Markdown） | ファイルが正 → artisan 取り込み／Meetings（閲覧） |
| **例会メモ** | `contact_memos`（`memo_type=meeting`） | owner の個人メモ（1 meeting あたり 1 現在メモ） | Meetings（編集） |

**議事録と例会メモの区別:**

- **議事録（`meeting_minutes`）:** 会全体の記録。チャプター定例会の Zoom 要約等。owner→target ではない。
- **例会メモ（`contact_memos`）:** 利用者（owner）個人のメモ。Dashboard KPI の `meetings_with_memo` はこちらを指す（既存仕様維持）。

---

## 3. Connections の役割

**Connections（`/connections` = DragonFlyBoard）は「定例会の BO を編集する作業面」。**

- 定例会をプルダウンで選択し、**BO1/BO2 割当を編集・保存**する。
- BO データの所有者は **Meeting**（`breakout_rooms` 等）。Connections は編集 UI の 1 つ。
- 関係マップ（サマリ / interested / want_1on1 / 1to1 ログ）は現状同居しているが、**将来 Members 側へ集約**を検討（本 Phase ではスコープ外）。

---

## 4. Meetings の役割（管理ハブ）

**Meetings（`/meetings` = MeetingsList）は定例会の管理ハブ。**

Drawer タブ構成:

| タブ | 内容 |
|------|------|
| **概要** | 番号・日付・BO数・メモ有無・参加者 PDF 状態・議事録有無。議事録あり時は **「議事録を表示」→ モーダル** |
| **参加者** | 参加者 PDF / CSV 取込・解析・反映。PDF 未登録時は登録ボタン |
| **BO** | 割当の読み取り ＋ **「Connections で編集」** 導線 |
| **メモ** | 既存の `contact_memos` 例会メモ（`MarkdownView` 閲覧・Dialog 編集） |

**議事録（モーダル）:** Drawer タブには含めない。`meeting_minutes.body_markdown` を共有 `MarkdownView` で **Dialog モーダル**表示。起動: ヘッダー「議事録あり」Chip、概要ボタン、一覧「あり」Chip、`/meetings?meetingId=&tab=minutes`（Connections 導線）。

### 完了回 vs 今後の回

| 条件 | 前面に出す要素 |
|------|----------------|
| **完了済み**（`held_on` < 今日） | 概要の議事録ボタン／ヘッダー Chip → **モーダル** |
| **今後・当日** | BO 編集導線（Connections へ） |

---

## 5. 議事録の source of truth

- **正:** `docs/meetings/chapter/chapter_weekly_YYYYMMDD.md`
- **DB:** `meeting_minutes`（file → DB の一方向取り込みのみ）
- **コマンド:** `php artisan dragonfly:import-chapter-minutes {path}`

### front matter 推奨キー

| キー | 必須 | 用途 |
|------|------|------|
| `doc_type` | 推奨 | `chapter_weekly` |
| `meeting_number` | 推奨 | `meetings.number` 照合 |
| `session_date` | 推奨 | `meetings.held_on` |
| `session_time_jst` | 任意 | メタ保存 |
| `format` | 任意 | 例: `zoom` |
| `source` | 任意 | 取得元 |

---

## 6. API 拡張（本 Phase）

- `GET /api/meetings` — 各行に `has_minutes`（boolean）
- `GET /api/meetings/{id}` — `minutes` オブジェクト、`participant_count`、BO 要約
- `GET /api/meetings/{id}/minutes` — 議事録本文（読み取り専用）

---

## 7. 関連 SSOT

- [DATA_MODEL.md](DATA_MODEL.md) §4.6 meetings、§4.6a meeting_minutes
- [CHAPTER_MINUTES_REQUIREMENTS.md](CHAPTER_MINUTES_REQUIREMENTS.md)
- [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) — Connections と participants
- [FIT_AND_GAP_MEETINGS.md](FIT_AND_GAP_MEETINGS.md)
