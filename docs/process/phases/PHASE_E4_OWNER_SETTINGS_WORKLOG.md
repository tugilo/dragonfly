# PHASE E-4 Owner 設定 — WORKLOG

**Phase:** E-4（Owner 設定の永続化）  
**参照:** PHASE_E4_OWNER_SETTINGS_PLAN.md

---

## 0. 事前棚卸し（必須）

### A) users テーブルに owner_member_id が既にあるか？

**パス:** `www/database/migrations/0001_01_01_000000_create_users_table.php`  
**判断:** **無い。** users は id, name, email, email_verified_at, password, remember_token, timestamps のみ。  
**対応:** E-4b で migration を追加し、nullable の owner_member_id（unsignedBigInteger）を追加する。既存 migrations で FK を張っていない流儀なので、本カラムも FK は張らない（SSOT と既存流儀に合わせる）。

---

### B) users 更新 API（PATCH /api/users/:id or /api/me）が既にあるか？

**パス:** `www/routes/api.php`  
**判断:** **無い。** /api/users や /api/me のルートは存在しない。  
**対応:** E-4b で最小追加。PATCH /api/users/me を追加し、body の owner_member_id で更新。認証が無いため「現在ユーザー」は **user id 1** に固定する（既存運用に合わせ、仕組み増殖を避ける）。将来認証を入れたら auth()->id() に差し替え可能。

---

### C) members 一覧を取る既存 API があるか？

**パス:** `www/routes/api.php` → `GET /dragonfly/members`（DragonFlyMemberController::index）  
**判断:** **ある。** GET /api/dragonfly/members。owner_member_id, workspace_id, with_summary をクエリで受け付ける。レスポンスに id, name（および summary_lite 等）が含まれる。  
**対応:** 追加不要。Dashboard の Owner セレクタではこの API をそのまま利用する（with_summary なしで id/name のみ使うか、既存のまま呼ぶ）。

---

### D) 認証の実態（E-4 では仕組み増殖を避ける）

**パス:** `www/routes/api.php`、`www/app/Http/Controllers/Religo/DashboardController.php`  
**判断:** Dashboard を含め、現状 **認証 middleware は付いていない**。getJson でそのまま API を叩くテストが多数。  
**対応:** E-4 では「現在ユーザー」を **user id 1** に固定し、PATCH /api/users/me は「id=1 の user の owner_member_id を更新する」とみなす。新規に認可基盤・middleware は作らない。WORKLOG に「認証なしのため /me は user id 1 固定」と明記し、PLAN/REPORT でも一貫して記載する。

---

## 1. 重要判断（422 vs フォールバック）

- **方針:** owner_member_id が query にも user 設定にも無い場合は **422** を返し、`message` で「オーナーを設定してください」等の文言を返す。
- **理由:** 初回設定に誘導しやすく、暫定値（1）に依存しない「正」を確定できる。既存の「省略時は 1」は E-4 で廃止し、user.owner_member_id が無い場合は 422 に統一する。
- **WORKLOG 根拠:** DASHBOARD_DATA_SSOT の「暫定で固定値 1」を解消するため、未設定時はエラーにして UI で設定を促す形が要件と一致する。

---

## 2. E-4a 実施メモ（Docs Phase）

- PLAN / WORKLOG / REPORT の 3 点セットを作成。
- docs/INDEX.md に Phase E-4 の 3 ファイルへのリンクを追加。
- 棚卸し A–D の結果は上記の通り。E-4b ではこれに基づき「既存に寄せる」最小実装を行う。

---

## 3. E-4b 実施メモ（Impl Phase・事前）

- Step1: users に owner_member_id 追加 migration（nullable、FK なし）。
- Step2: User モデルに owner_member_id を fillable に追加、casts は integer で十分なら追加。
- Step3: PATCH /api/users/me を新設。Request は FormRequest が既存で多用されていれば作成、そうでなければ Controller 内 validate。レスポンスは `{ "owner_member_id": <int> }` の直返し。
- Step4: DashboardController の owner 決定を「request > user.owner_member_id > 422」に変更。user 取得は Auth が無いため User::find(1) 等で固定（PLAN に合わせる）。
- Step5: members は既存 GET /api/dragonfly/members を使用（Step5 は追加なし）。
- Step6: Dashboard.jsx で owner 未設定時は設定ブロック、設定済み時は右上セレクタ＋変更時自動保存。
- Step7: テストは DashboardApiTest を拡張し、User に owner_member_id を設定した場合の query なし 200、未設定時の 422、owner 更新 API の 200/422 を追加。
