# Phase 180 WORKLOG — 定例会議事録の DB 管理

## 判断

1. **source of truth = Markdown（file→DB 一方向）**  
   `contact_memos` は owner→target の個人メモのため、チャプター全体議事録は **`meeting_minutes` 新テーブル**（meetings 1:1）とした。

2. **取り込みコマンド**  
   `ImportParticipantsCsvCommand` と同型で `Meeting::updateOrCreate(['number'])` → `MeetingMinute::updateOrCreate(['meeting_id'])`。YAML は `Symfony\Component\Yaml\Yaml`。コンテナ内 import のため `docs` を `/var/docs` に read-only マウント。

3. **Meetings UI**  
   Drawer をタブ化し、完了回（`held_on < 今日`）は議事録タブを初期表示。Markdown 表示は `OneToOneMarkdownView` から **`MarkdownView` 共有コンポーネント**へ切り出し。

4. **API**  
   一覧 `has_minutes`、show に `minutes` / `participants_summary` / `breakout_summary`。読み取り専用 `GET /api/meetings/{id}/minutes`。

5. **初期データ**  
   第207–210回（20260512/0519/0526/0602）を一括取り込み後 `make db-export`。
