# PHASE15C Religo Members カテゴリ表示最適化 — WORKLOG

**Phase:** PHASE15C カテゴリ表示  
**作成日:** 2026-03-05

---

## 実施内容

1. **MembersList.jsx CategoryField**  
   - 表示を「name があるときは group_name / name、無いときは group_name のみ」に統一。

2. **MemberEdit.jsx categoryChoices**  
   - optionText を「name があるときは group_name / name、無いときは group_name」に統一。編集画面の Select で迷わないようにした。

3. **Board**  
   - メンバー選択は display_no + name のまま（カテゴリ表示の変更は不要と判断）。必要なら右ペイン等で category を同形式で表示可能。

4. **docs**  
   - PHASE15C PLAN / WORKLOG / REPORT、INDEX、dragonfly_progress に追記。
