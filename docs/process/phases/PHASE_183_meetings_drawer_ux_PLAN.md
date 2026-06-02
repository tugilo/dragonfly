# Phase 183 PLAN — Meetings Drawer UX（議事録モーダル・参加者PDF導線）

## 基本情報

| 項目 | 内容 |
|------|------|
| Phase ID | 183 |
| Name | meetings_drawer_ux |
| Type | implement |
| 作成日時 | 2026-06-02 17:05 JST |
| Branch | feature/phase183-meetings-drawer-ux |

## Related SSOT

- [MEETING_DOMAIN_IA.md](../../SSOT/MEETING_DOMAIN_IA.md) — Drawer タブ・議事録閲覧
- [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md) — §4 Meeting ハブ IA
- [CHAPTER_MINUTES_REQUIREMENTS.md](../../SSOT/CHAPTER_MINUTES_REQUIREMENTS.md) — SPEC-014 UI
- SPEC-014

## Scope

- `www/resources/js/admin/pages/MeetingsList.jsx`
- `docs/SSOT/MEETING_DOMAIN_IA.md`
- `docs/SSOT/FIT_AND_GAP_MEETINGS.md`
- `docs/SSOT/CHAPTER_MINUTES_REQUIREMENTS.md`
- `docs/process/PHASE_REGISTRY.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`
- Phase 183 PLAN / WORKLOG / REPORT

## 背景

Phase 180 の Drawer タブ化後、議事録が「議事録」タブ内のみにありデフォルトタブ（議事録あり→議事録タブ、なし→概要/BO）から見つけにくかった。参加者PDF登録も「参加者」タブ内に埋もれていた。

## DoD

- [x] 議事録は Drawer タブではなく **モーダル**（`MarkdownView`）で閲覧
- [x] 「議事録あり」Chip / 概要ボタン / 一覧 Chip / `?tab=minutes` でモーダル起動
- [x] 参加者PDF登録を概要・一覧 Actions・参加者タブから操作可能
- [x] SSOT 3 件 + progress / registry 更新
- [x] `npm run build` 成功、`php artisan test` 429 passed

## モック比較

対象外（Meetings Drawer UX 改善）。
