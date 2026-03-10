# Phase M4L Members から Connections への導線強化 — REPORT

**Phase:** M4L  
**完了日:** 2026-03-10  
**参照:** [PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_PLAN.md](PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_PLAN.md)、[PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_WORKLOG.md](PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_WORKLOG.md)

---

## Summary

Members から Connections への導線を強化した。(1) Card の mc-act に「🗺 Connections で見る」ボタンを追加し、Link で `/connections?member_id=${record.id}` に遷移。(2) List の MemberRowActions に「🗺 Connections」ボタンを追加し、同様に member_id 付きで遷移。(3) DragonFlyBoard で useSearchParams から member_id を読み、members 取得後に該当メンバーを setTargetMember して右ペインに表示。初回のみ適用するため useRef で二重適用を防止。ヘッダーの「Connectionsへ」と既存のメモ・1to1・詳細導線は維持。

---

## Changed Files

- www/resources/js/admin/pages/MembersList.jsx（Card に「Connections で見る」、List に「Connections」Link 追加）
- www/resources/js/admin/pages/DragonFlyBoard.jsx（useSearchParams で member_id 読み取り・初期選択）
- docs/process/phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_PLAN.md（新規）
- docs/process/phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_WORKLOG.md（新規）
- docs/process/phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_REPORT.md（本ファイル）

---

## DoD Check

| 項目 | 結果 |
|------|------|
| Card に「Connections で見る」導線・member_id 付き遷移 | OK |
| List の Actions に「Connections」導線・member_id 付き遷移 | OK |
| Connections で member_id 受け取り・該当メンバー選択表示 | OK |
| ヘッダー「Connectionsへ」維持 | OK |
| 既存メモ・1to1・詳細等の導線維持 | OK |
| API / dataProvider / backend 変更なし | OK |
| test / build 成功 | OK（79 passed / build 成功） |

---

## Scope Check

OK — 変更は MembersList.jsx と DragonFlyBoard.jsx の必要最小限（導線追加と URL member_id 読み取り）のみ。API・dataProvider・バックエンドは未変更。

---

## SSOT Check

OK — FIT_AND_GAP §4.1, §4.2 に沿った導線追加。SSOT の更新は不要。

---

## Merge Evidence

（develop へ merge 後に記入）

- merge commit id:
- source branch: feature/m4l-members-to-connections-nav
- target branch: develop
- phase id: M4L
- phase type: implement
- related ssot: FIT_AND_GAP §4.1, §4.2
- test command: `php artisan test` / `npm run build`
- test result: 79 tests passed; npm run build 成功
- changed files: www/resources/js/admin/pages/MembersList.jsx, www/resources/js/admin/pages/DragonFlyBoard.jsx, docs/process/phases/PHASE_M4L_*
- scope check: OK
- ssot check: OK
- dod check: OK

---

## 実装判断（採用した遷移方式 / Card と List の導線の違い）

- **遷移方式:** URL query parameter **member_id** を採用。Members からは `Link to={/connections?member_id=${record.id}}` で遷移。Connections（DragonFlyBoard）で `useSearchParams()` から member_id を取得し、members 取得後に該当メンバーを setTargetMember。初回のみ適用するため `appliedMemberIdFromUrlRef` で二重適用を防止。react-router の既存仕組みのみ使用し、API は変更していない。
- **Card と List の導線の違い:** Card では mc-act 内に「🗺 Connections で見る」を 1 本追加（メモ・1to1・1to1メモの次、詳細の前）。List では MemberRowActions に「🗺 Connections」を 1 本追加（1to1メモの次、フラグ・詳細の前）。いずれも同じ Link 先（/connections?member_id=X）で、Connections 側の受け取りは共通。Card は「この人を Connections で見る」が分かるラベル、List は短めの「Connections」で Actions 列の長さを抑えた。
