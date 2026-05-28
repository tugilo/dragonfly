# PHASE E-3 Dashboard UI API 前提 — WORKLOG

**Phase:** E-3（Dashboard UI を API 前提に調整）  
**目的:** API 運用前提で安定化。owner/loading/error を既存流儀に寄せる。

---

## 0) 事前棚卸し（既存の正）

### A) フロントの API 呼び出しの正
- **場所:** `www/resources/js/admin/dataProvider.js` — `request()` は fetch、`API_BASE = ''`、ヘッダー `Accept: application/json`。axios は bootstrap にのみ（admin は fetch）。
- **他ページ:** `DragonFlyBoard.jsx` / `MembersList.jsx` / `MeetingDetailDrawer.jsx` は自前の `const API = ''` と fetch。Dashboard も fetch 継続で統一。
- **結論:** 新規 apiClient は作らない。fetch + Accept のまま。

### B) エラー通知の正
- **場所:** `useNotify`（react-admin）を `CategoriesEdit.jsx` / `MeetingsList.jsx` / `MembersList.jsx` 等で使用。`normalizeApiError` は未使用。
- **結論:** エラー時は useNotify 可だが、Dashboard は「フォールバックに落ちる」を優先。prompt 通り silent で可。

### C) ローディング UI の正
- **場所:** `ReligoLayout.jsx` は `<Loading />`（react-admin）を Suspense fallback に使用。`DragonFlyBoard.jsx` / `MeetingDetailDrawer.jsx` / `MembersList.jsx` は `Typography`「Loading...」や「読込中…」。
- **結論:** 新規 Skeleton は作らない。テキスト「読込中…」で既存に合わせる。

### D) owner_member_id の正
- **dataProvider:** `getOwnerMemberId(params)` => `params?.filter?.owner_member_id ?? 1`（list コンテキスト用）。
- **MembersList / MeetingDetailDrawer:** `const OWNER_MEMBER_ID = 1` で固定。
- **DragonFlyBoard:** `useState(1)` でユーザーが number 入力で変更可能。
- **現状:** 「current user に紐づく owner_member_id」を返す API は無い。Auth ユーザー→member_id の仕組みも無い。
- **結論 (E-3):** 既存と同じく **暫定 1**。UI には「暫定」を出さない。WORKLOG と E-2 SSOT に「owner_member_id の正が未定で暫定」と明記し、E-4 候補の TODO を残す。Dashboard は `OWNER_MEMBER_ID = 1` に統一（MembersList/MeetingDetailDrawer と同じ定数名で揃える）。

---

## E-3 Step2–4 実施内容

- **owner_member_id:** DEFAULT_OWNER_ID を OWNER_MEMBER_ID に改名し、他ページ（MembersList/MeetingDetailDrawer）と同一の定数名に統一。値は 1 のまま（暫定）。E-2 で SSOT に「暫定」を明記。
- **API 呼び出し:** fetch + Accept のまま。URL/ヘッダは既存 dataProvider の request と同等で統一済み。
- **ローディング:** 初回取得中に `loading` state を true にし、stats/tasks/activity ブロック上で「読込中…」を表示。既存の Typography による簡易表示に合わせた。
- **エラー:** try/catch で握りつぶし、setState しないためフォールバック（STATS_DEFAULT / TASKS_FALLBACK / ACTIVITY_FALLBACK）のまま表示。silent で対応。
