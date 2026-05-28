# PHASE15A Religo SSOT（DATA_MODEL）現状実装同期 — WORKLOG

**Phase:** PHASE15A SSOT DATA_MODEL 同期  
**作成日:** 2026-03-05

---

## 実施内容

1. **Entities 表の更新**  
   - categories（B1）, roles（B2）, member_roles（B3）を追加。

2. **Relationships の追記**  
   - member → category（category_id → categories）。members.category 廃止を明記。
   - member → 役職履歴（member_roles, roles）。members.role_notes 廃止。current_role の定義（term_end IS NULL, term_start <= 今日）。「去年のプレジは誰？」は member_roles を期間で絞って照会する旨を記載。

3. **§4.2 members の差し替え**  
   - 主要カラムに category_id を追加。category / role_notes は「廃止済み」として説明を追加。

4. **新規 §4.3 〜 §4.5**  
   - §4.3 categories: group_name（大カテゴリ）, name（実カテゴリ）。表示は「group_name / name」。
   - §4.4 roles: 役職マスタ。
   - §4.5 member_roles: term_start, term_end。current_role の SSOT 定義を記載。

5. **§4.6 以降の節番号繰り上げ**  
   - meetings → 4.6, participants → 4.7, breakout_rooms → 4.8, participant_breakout → 4.9, contact_flags → 4.10, contact_memos → 4.11, one_to_ones → 4.12, introductions → 4.13。

6. **§8 既存実装との対応**  
   - members の Phase14 変更を反映。categories / roles / member_roles を新規テーブルとして記載。
   - API 互換: attendees / roommates で category 表示用文字列・current_role 名を返す旨を追記。

7. **PLAN / WORKLOG / REPORT 作成、INDEX 更新。**
