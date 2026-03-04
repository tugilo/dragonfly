# PHASE05 Religo メモ追加API / 1 to 1 登録API — PLAN

**Phase:** 関係ログ作成の入口（contact-memos, one-to-ones）  
**作成日:** 2026-03-04  
**SSOT:** [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.8 contact_memos, §4.9 one_to_ones, §5.1 Workspace Scope

---

## 1. 追加する API

| メソッド | エンドポイント | 概要 |
|----------|----------------|------|
| POST | /api/contact-memos | メモ追加（owner, target, memo_type, body, meeting_id/one_to_one_id 条件付き） |
| POST | /api/one-to-ones | 1 to 1 登録（workspace_id 必須、status: planned/completed/canceled） |

## 2. Validation 概要

**contact-memos**
- owner_member_id, target_member_id: required, integer, exists:members,id
- workspace_id: nullable, integer, exists:workspaces,id
- memo_type: meeting | one_to_one | introduction | other（default other）
- body: required, string, 1..2000
- meeting_id: nullable, integer, exists:meetings,id。memo_type=meeting のとき必須（422）
- one_to_one_id: nullable, integer, exists:one_to_ones,id。memo_type=one_to_one のとき必須（422）

**one-to-ones**
- workspace_id: required, integer, exists:workspaces,id（API 上は必須とする）
- owner_member_id, target_member_id: required, integer, exists:members,id
- meeting_id: nullable, integer, exists:meetings,id
- status: planned | completed | canceled（default planned）
- scheduled_at, started_at, ended_at: nullable, datetime
- notes: nullable, string

## 3. SSOT 遵守

- memo_type 値域: meeting / one_to_one / introduction / other（DATA_MODEL §4.8）
- status=canceled は last_one_to_one / last_contact_at から除外（派生値側のルール。登録は許可）
- workspace_id: single-workspace では contact_memos は NULL 許容。one_to_ones は API で必須とする。
- 返却: 作成した 1 件を返す（id, created_at 含む）。

## 4. テスト観点（最低 8 ケース）

**contact-memos**
1. other: body 必須で作成できる
2. one_to_one で one_to_one_id 無し → 422
3. meeting で meeting_id 無し → 422
4. workspace_id NULL 許容（single-workspace）
5. owner/target 不正 → 422（exists で弾く）

**one-to-ones**
6. workspace_id 無し → 422
7. status の値域不正 → 422
8. 作成成功 → 201、返却に id / timestamps 含む

## 5. DoD

- [ ] Request（Validation）/ Controller / Service 分離
- [ ] POST /api/contact-memos, POST /api/one-to-ones 実装
- [ ] テスト 8 件以上 green
- [ ] PLAN / WORKLOG / REPORT 作成済み
- [ ] 1 コミットで push
