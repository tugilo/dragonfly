# ADMIN_GLOBAL_OWNER_SPEC003_DOCS — WORKLOG

**Phase ID:** ADMIN_GLOBAL_OWNER_SPEC003_DOCS  
**種別:** docs  
**Related SSOT:** [ADMIN_GLOBAL_OWNER_SELECTION.md](../../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md)

---

## 実施日時

2026-04-06 JST（本 WORKLOG 作成時点。merge 時刻は REPORT の Merge Evidence で確定する）

## 実施概要

SPEC-003（グローバル Owner）について、**実装棚卸し結果**を正として tugilo 式の PLAN / WORKLOG / REPORT を起こし、FIT_AND_GAP・SSOT メタ・PHASE_REGISTRY・INDEX・進捗ファイルを同期した。

## 読んだファイル（確認・編集の根拠）

- `www/resources/js/admin/ReligoOwnerContext.jsx`
- `www/resources/js/admin/religoOwnerStore.js`
- `www/resources/js/admin/ReligoLayout.jsx`
- `www/resources/js/admin/CustomAppBar.jsx`
- `www/resources/js/admin/app.jsx`
- `www/resources/js/admin/dataProvider.js`（`assertOwnerResolved`）
- `docs/SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md`
- `docs/SSOT/FIT_AND_GAP_MENU_HEADER.md`（旧 §4 が「デフォルト AppBar」のままだったため更新対象）

## 実施した確認

- `ReligoOwnerProvider` が `Admin` をラップしていること。
- `loading` 時は `ReligoLayout` が全画面スピナーのみを返し、`owner_member_id === null` かつ `!loading` のときメインをゲートすること。
- `CustomAppBar` に Owner の MUI `Select` とパンくず・検索（ダミー）・所属リンク・ME アバターがあること。
- `dataProvider` が owner 依存リソースで `assertOwnerResolved()` を使うこと。

## 判明したこと

- **主要挙動**は SPEC-003 のゴール（単一 owner・ヘッダー選択・未設定 UX・マジックナンバー禁止の方向）に沿っている。
- **§5.1** を「画面はクエリに `owner_member_id` を載せない」と厳密読みすると、直 fetch 画面は **同一 ID を URL に載せている**ため、**SSOT 文面との厳密一致は別 Phase**で整理するのがよい。
- **§8 DoD** のうち **FIT/GAP** と **Phase 記録**は本 WORKLOG 対応前は未充足だった。

## 判断したこと

- 実装を **コード変更 Phase と同一の docs Phase** に混ぜず、**ADMIN_GLOBAL_OWNER_SPEC003_DOCS** として **文書・記録のみ**を閉じる。
- `/settings` を owner 未設定時に開くか、OneToOnesList の owner フィルタと API の整合は **仕様判断が必要**なため **別 Phase** に送る。

## 残課題（別 Phase）

- owner 未設定時の `/settings` 例外。
- OneToOnesList の `owner_member_id` フィルタと `dataProvider` の単一 owner 強制の整合。
- §5.1 に沿った **注入の共通化**（`getResolvedOwnerMemberId` 等）と SSOT 文面のすり合わせ。
- `religoOwnerMemberId.js` の未使用整理。

## 次アクション

- develop への merge 後、REPORT に **Merge Evidence** を追記する。
- 別 Phase 起票時は `PHASE_REGISTRY` に **follow-up** 行を追加する。
