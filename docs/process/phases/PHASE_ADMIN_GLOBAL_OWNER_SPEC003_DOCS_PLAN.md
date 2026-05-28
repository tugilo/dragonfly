# ADMIN_GLOBAL_OWNER_SPEC003_DOCS — PLAN（事後整理・記録）

**Phase ID:** ADMIN_GLOBAL_OWNER_SPEC003_DOCS  
**種別:** docs  
**Related SSOT:** [ADMIN_GLOBAL_OWNER_SELECTION.md](../../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md)（SPEC-003）

---

## 1. 背景

`ADMIN_GLOBAL_OWNER_SELECTION` に基づく **グローバル Owner** の実装（`ReligoOwnerProvider`、`religoOwnerStore`、`CustomAppBar` の Owner Select、`ReligoLayout` の未設定ゲート、`dataProvider` の `assertOwnerResolved`、主要画面の Context 統一、Dashboard の Owner 二重 UI 除去、禁止パターン除去）はコード上で進捗している。一方、tugilo 式の **PLAN / WORKLOG / REPORT** および **FIT_AND_GAP_MENU_HEADER** の実装反映、**PHASE_REGISTRY** への登録が未整理だった。

## 2. 目的

- SPEC-003 の **到達点**をリポジトリ内ドキュメントとして固定する。
- **完了したこと**と **別 Phase に送ること**を混在させない。
- SSOT §8 のうち **文書・記録に依存する DoD** を満たす。

## 3. スコープ

- 本 Phase 用の **PLAN / WORKLOG / REPORT**（本ファイル含む）の作成。
- `docs/SSOT/FIT_AND_GAP_MENU_HEADER.md` の **現行実装**への整合（§4 実装現状・AppBar 節の更新、SPEC-003 Owner の追記）。
- `docs/SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md` の **メタ表・§8 DoD チェック**の更新（実装済み項目の明示、未完了の明示）。
- `docs/process/PHASE_REGISTRY.md` への本 Phase 行の追加。
- `docs/INDEX.md` への Phase 文書リンクの追加。
- `docs/dragonfly_progress.md` への進捗行の追加。

## 4. 非スコープ

- アプリコードの変更（`/settings` の owner 未設定時導線、OneToOnesList フィルタと dataProvider の整合、§5.1 厳密化リファクタ等）。
- `religoOwnerMemberId.js` の削除（別 Phase）。

## 5. DoD

- [x] `PHASE_ADMIN_GLOBAL_OWNER_SPEC003_DOCS_{PLAN,WORKLOG,REPORT}.md` が `docs/process/phases/` に存在する。
- [x] `FIT_AND_GAP_MENU_HEADER.md` が **カスタム AppBar・Owner Select・ReligoLayout ゲート**を反映している。
- [x] `ADMIN_GLOBAL_OWNER_SELECTION.md` の §8 が **チェック可能な形**で更新されている。
- [x] PHASE_REGISTRY・INDEX・dragonfly_progress が更新されている。
- [x] REPORT に **別 Phase 候補**が明記されている。

## 6. 実施手順

1. PLAN（本ファイル）を確定する。
2. WORKLOG に棚卸し・判断・読了ファイルを記す。
3. REPORT に変更ファイル一覧・SSOT 整合・未完了・別 Phase を記す。
4. FIT_AND_GAP を編集する。
5. SSOT のメタ・§8 を編集する。
6. REGISTRY / INDEX / progress を更新する。

## 7. 検証方針

- 文書間のリンクが有効であること。
- FIT_AND_GAP の記述が、`ReligoLayout.jsx` / `CustomAppBar.jsx` / `app.jsx` の責務と矛盾しないこと。

## 8. 注意点

- 本 Phase は **実装後の文書同期**である。Merge Evidence を残す運用では、取り込み後に REPORT に merge commit id を追記する。
