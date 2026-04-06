# ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP — WORKLOG

**Phase ID:** ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP  
**種別:** implement  
**Related SSOT:** [ADMIN_GLOBAL_OWNER_SELECTION.md](../../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md)

---

## 実施概要

PLAN §10 の判断に従い、(1) `ReligoLayout` に `useLocation` による **`pathname === '/settings'` 時のゲート回避**、(2) `OneToOnesList` から **`owner_member_id` フィルタ UI** を削除し、統計・相手フィルタ・クイック作成を **`useReligoOwner()`** 基準に揃え、`filterDefaultValues` から `owner_member_id` を除去、(3) `ADMIN_GLOBAL_OWNER_SELECTION.md` の **§4.4 例外** と **§5.1 補足**、(4) **`www/resources/js/admin/religoOwnerMemberId.js` 削除**（`www` 配下に import 0 件を再 grep で確認）、(5) 関連 FIT/GAP の **Owner 記述の更新** を実施した。

**merge 単位:** `develop` の取り込み済みコミットには `ReligoOwnerContext` 等が無かったため、**follow-up と同じ feature ブランチ・同一コミット**に `ReligoOwnerContext` / `religoOwnerStore` / AppBar・`dataProvider`・各画面の `useReligoOwner` 接続を含めた（REPORT「変更ファイル」参照）。PLAN のスコープ外の別機能ではなく、follow-up を動かす前提の SPEC-003 実装残分である。

## 調査対象

- `www/resources/js/admin/ReligoLayout.jsx`
- `www/resources/js/admin/pages/OneToOnesList.jsx`
- `www/resources/js/admin/dataProvider.js`（`one-to-ones` getList は変更なし・`assertOwnerResolved` 前提のまま）
- `religoOwnerMemberId.js`（削除前に `www` 配下 grep で import なし）
- `www/resources/js/admin/pages/ReligoSettings.jsx`（owner 未設定でも `GET /api/users/me` + workspaces で読み込み可能であることを確認）

## 判断内容

起票時点の結論は [PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_PLAN.md](PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_PLAN.md) §10 参照。実装時の追加判断は以下。

| 論点 | 決定 |
|------|------|
| `/settings` | パターンA：`useLocation().pathname === '/settings'` のとき `props.children` をそのまま表示 |
| OneToOnesList | フィルタから `NumberInput` 削除。`filterDefaultValues` は `{ exclude_canceled: true }` のみ。統計 API は `OneToOnesStatsCards` で Context の `owner_member_id` を `buildOneToOneStatsQuery` へマージ |
| §5.1 | PLAN どおり補足段落を追記（独自付与禁止と Context 由来 ID のクエリ許容の両立） |
| religoOwnerMemberId.js | 削除。将来 `fetchReligoMe` 相当が必要なら `ReligoOwnerContext` または API モジュールに集約（PLAN §3.1 表） |

## 未決事項

なし（本 Phase スコープ内）。

## 次アクション

- feature ブランチでコミットし、`develop` へ **merge --no-ff** 後、`php artisan test` 再実行・push。REPORT に **Merge Evidence**（merge commit id 等）を追記。
- スコープ外の候補：Owner Select 検索付き、直 fetch の共通ラッパ、サーバ側 owner 整合（PLAN §3.3）。
