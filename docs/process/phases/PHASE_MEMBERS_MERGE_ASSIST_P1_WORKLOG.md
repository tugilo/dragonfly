# PHASE MEMBERS-MERGE-ASSIST-P1 — WORKLOG

## 判断

- **認可:** 既存のロール基盤が薄いため、**共有秘密トークン**（`RELIGO_MEMBER_MERGE_TOKEN` + `X-Religo-Member-Merge-Token`）でエンドポイントを隠し、未設定時は **404**。
- **ブロック条件:** `participants` の `(meeting_id, member_id)` 一意により、**同一例会に canonical と merge が両方いる**と UPDATE で衝突するため **プレビューで hard block**。
- **contact_flags:** 一意 `(owner_member_id, target_member_id)`。衝突時は **重複行を削除**（プレビューでは警告のみ、実行で削除）— データ損失リスクは REPORT に記載。
- **introductions:** Eloquent モデルなしのため **DB::table** で更新。
- **監査:** `bo_assignment_audit_logs.actor_owner_member_id` を付け替え。履歴の意味は変わる可能性あり。

## 実装

- `MemberMergeService::preview` / `execute`
- 管理 UI は JSON 表示 + 確認フレーズ（ユーザーがコピペ検証可能）
