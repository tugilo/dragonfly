# PHASE CONN-BO-UX-GUARDS-P1 — REPORT

## 1. Phase 番号

**CONN-BO-UX-GUARDS-P1**

## 2. 実装内容

- **`www/resources/js/admin/utils/boAssignmentGuards.js`（新規）**  
  `getBoAssignBlockReason` / `collectBoSaveValidationErrors` / `filterBoAssignableMemberIds` / `isBoAssignableMember`。
- **`DragonFlyBoard.jsx`**  
  - `membersById`（`Map`）で割当ガード。  
  - `toggleRoundMember` / `assignMemberToRoom`：追加時のみブロック＋Snackbar。  
  - `saveRounds`：`collectBoSaveValidationErrors` で **保存前ガード**（失敗時は PUT しない）。  
  - `putMeetingBreakouts`：422/その他で **接頭辞付き** の `Error` を投げる。  
  - BO ルームチップ：割当不可・一覧外は **警告背景・Warning アイコン・理由テキスト**。  
  - BO1→BO2 コピー：`filterBoAssignableMemberIds`、除外時 Snackbar。  
  - 左ペイン BO メニュー：追加が不可な行は **disabled + title**。  
  - `roundsError`：`Alert` + `whiteSpace: pre-wrap`。

## 3. UI 変更点

- 割当不可の **追加** を拒否したとき **Snackbar** に理由（下記「クライアント文言」）。  
- 保存前検証失敗時：**Alert** に複数行、`Snackbar` に「割当に問題があるため保存できません。内容を確認してください。」  
- API 422：**Alert** に「BO割当を保存できませんでした。」＋サーバメッセージ（下記「サーバ文言」）。  
- BO ルーム内の **問題行** は黄色系ハイライト＋警告アイコン。  
- BO1→BO2：割当不可メンバーを落としたとき **Snackbar** で除外人数。

## 4. API との整合

| 層 | 役割 |
|----|------|
| クライアント | `bo_assignable` / 一覧に存在するかで **保存前** に防ぐ。 |
| `PUT /api/meetings/{id}/breakouts` | **変更なし**。未参加者・欠席・proxy は従来どおり **422**（`MeetingBreakoutService`）。 |

## 5. 保存前ガード（クライアント）

- **`toggleRoundMember` / `assignMemberToRoom`:** 追加時に `getBoAssignBlockReason` が非 null なら **state を更新しない** + Snackbar。  
- **`saveRounds`:** `collectBoSaveValidationErrors(payloadRooms, membersById)` が非空なら **PUT しない** + Alert + Snackbar。  
- **BO1→BO2 コピー:** `filterBoAssignableMemberIds` で **割当可能 ID のみ** BO2 に入れる。

## 6. 保存時ガード（API・最終防衛線）

- 既存どおり **`MeetingBreakoutService::updateBreakouts`**：  
  - participant なし → 422 `errors.rooms`  
  - absent / proxy → 422 `errors.rooms`

## 7. メッセージ文言

### クライアント（`boAssignmentGuards.js` / `DragonFlyBoard.jsx`）

- 一覧にいない ID:  
  `メンバーID {id} はこの例会の参加者として一覧にいません。CSV等で参加者登録後に割り当ててください。`
- proxy:  
  `{名前}は代理出席のためBOに入れません。`
- その他 `bo_assignable === false`:  
  `{名前}はこの出席区分ではBOに入れません。`
- 保存前検証（まとめ）失敗時 Snackbar:  
  `割当に問題があるため保存できません。内容を確認してください。`
- BO1→BO2（除外あり）:  
  `BO2 には割当可能なメンバーのみコピーしました（{n}名を除外）。`
- 無効メニュー項目の title:  
  `代理出席・欠席相当など、BO に入れない区分です。`

### API（サーバ・変更なし・`putMeetingBreakouts` 表示用）

- 接頭辞（422）: `BO割当を保存できませんでした。` の後に Laravel の本文を連結。  
- サーバ本文（参考）:  
  - `当該例会の参加者に存在しない member_id です: {ids}。CSVまたは参加者登録で登録してからBOに割り当ててください。`  
  - `欠席または代理出席のためBOに含められない member_id です: {ids}。`

## 8. 将来 proxy を BO 対象にしたい場合の影響

- **SSOT:** [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) の **4.3 / 5.4** を「proxy を BO に含めるか」で再定義する必要がある。  
- **API:** `MeetingBreakoutService` の `ineligible` 判定（`absent` / `proxy`）と、`DragonFlyMemberController` の `bo_assignable` 付与ロジックを変更。  
- **UI:** `boAssignmentGuards.js` の proxy 専用文言・`filterBoAssignableMemberIds`・左ペインの「代理」チップ／メニュー disabled を **仕様に合わせて緩和または再設計**する。  
- **データ:** proxy を「同室の正式メンバー」として扱うか、監査・Dashboard 活動ログの意味づけも要確認。

## 9. テスト結果

- `docker compose ... exec node npm run build` — 成功  
- `docker compose ... exec app php artisan test` — **352 passed**

## 10. Merge Evidence

- ローカル実施。merge / push はリポジトリ運用（feature → develop・PR なし）に従うこと。
