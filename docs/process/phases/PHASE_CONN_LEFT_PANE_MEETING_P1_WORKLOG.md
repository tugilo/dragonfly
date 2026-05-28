# PHASE CONN-LEFT-PANE-MEETING-P1 — WORKLOG

## 判断

- **API 側で絞り込み** — `Member::whereHas('participants')` + 同 meeting の `participants` を eager load。他画面の `GET /api/dragonfly/members`（`meeting_id` なし）は従来どおり全件。影響を局所化。
- **欠席** — `type != absent` で一覧から除外（左ペイン・BO 双方で不要）。
- **代理** — 一覧には出すが `bo_assignable: false` と Chip。クリックは関係ログ中心（`+` メニューは出さない）。Autocomplete からも除外。
- **例会未選択** — `setMembers([])`、ヘッダに案内文。

## 実施日

- 2026-03-31 JST
