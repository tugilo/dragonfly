# PHASE15B Religo 役職履歴照会 API + ReactAdmin — WORKLOG

**Phase:** PHASE15B 役職履歴照会  
**作成日:** 2026-03-05

---

## 実施内容

1. **MemberRoleIndexService**  
   - role_id, member_id, from, to でフィルタ。term_start DESC, id DESC でソート。member_name / role_name を join して返却。

2. **MemberRoleController**  
   - GET /api/member-roles。Request の role_id, member_id, from, to を MemberRoleIndexService に渡して JSON 返却。

3. **routes/api.php**  
   - Route::get('/member-roles', [MemberRoleController::class, 'index']) を追加。

4. **MemberRoleIndexTest**  
   - index の形、role_id / member_id / from&to フィルタ、term_end NULL 含むこと、sort を検証。5 本追加。

5. **dataProvider getList('member-roles')**  
   - /api/member-roles を呼び、filter を query に乗せて返却。

6. **MemberRolesList.jsx**  
   - List + Datagrid。フィルタ: 役職（Select）、メンバー（ReferenceInput）、期間 from/to（DateInput）。列: member_name, role_name, term_start, term_end, 状態（現役/過去）。

7. **app.jsx / ReligoMenu**  
   - Resource member-roles、Menu に「役職履歴」を追加。

8. **docs**  
   - PHASE15B_PLAN / WORKLOG / REPORT、INDEX、dragonfly_progress に追記。
