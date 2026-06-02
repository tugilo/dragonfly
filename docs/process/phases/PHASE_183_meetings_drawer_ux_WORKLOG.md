# Phase 183 WORKLOG — Meetings Drawer UX

## 判断

1. **議事録モーダル** — 閲覧は一時的な読み取り操作。Drawer タブよりモーダルの方が速く、Drawer は概要/参加者/BO/メモの管理に集中させる。`?tab=minutes`（Connections 導線）はモーダル起動にマップ。
2. **参加者PDF** — タブ内のみだと Phase 180 後に発見性が落ちた。概要ブロック・ヘッダー Chip・一覧 Actions（📄 PDF）・参加者タブフッターで多経路化。CSV/PDF 関連 UI は参加者タブに集約。
3. **ドキュメント** — MEETING_DOMAIN_IA / FIT_AND_GAP_MEETINGS / CHAPTER_MINUTES_REQUIREMENTS の「議事録タブ」記述をモーダル方式に更新。
