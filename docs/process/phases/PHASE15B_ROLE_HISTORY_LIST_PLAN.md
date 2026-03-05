# PHASE15B Religo 役職履歴（member_roles）照会 API + ReactAdmin — PLAN

**Phase:** 役職履歴を「調べやすく」する API と ReactAdmin 一覧  
**作成日:** 2026-03-05  
**SSOT:** [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.5 member_roles

---

## 1. 目的

- 「去年のプレジは誰だっけ？」を UI で即検索できるようにする。
- role_notes の“過去”を member_roles の term で絞って追えるようにする。
- Members 編集は現状維持（壊さない）。

## 2. 追加 API

**GET /api/member-roles**

- filters: role_id, member_id, from, to（term_start/term_end に対する期間）
- sort: term_start DESC, id DESC
- response: id, member_id, member_name, role_id, role_name, term_start, term_end（term_end NULL ＝ 現役）

GET /api/roles は既存を流用（フィルタ UI 用）。

## 3. ReactAdmin

- Resource: member-roles（閲覧特化、編集不要）
- List: フィルタ（Role, 期間 from/to, Member）、列（Member, Role, term_start, term_end, 状態＝現役/過去）

## 4. DoD

- [x] 新規 API テスト green（role/期間/member 絞り込み、sort、term_end NULL 含む）
- [x] ReactAdmin で一覧表示・絞り込みができる
- [x] 既存 27 本を含め全テスト green（32 passed）
- [x] PLAN / WORKLOG / REPORT、INDEX、dragonfly_progress 更新

## 5. Git

- ブランチ: `feature/phase15b-role-history-list`
- コミット: 1 コミット
