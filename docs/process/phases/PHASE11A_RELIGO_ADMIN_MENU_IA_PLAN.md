# PHASE11A Religo 管理画面メニュー整理（IA）— PLAN

**Phase:** ReactAdmin+MUI メニューを情報設計（IA）どおりに整理し、「1 to 1 は Meeting と独立」であることを UI で明確にする  
**作成日:** 2026-03-04  
**SSOT:** Religo プロダクト要件、PR レス運用（docs/git/PRLESS_MERGE_FLOW.md）

---

## 1. 狙い

- メニューを「例会（Meetings/BO）」と「関係づくり（1 to 1）」で分け、**1 to 1 が Meeting 配下に見える誤解**を排除する。
- 1 to 1 は Meeting 非依存の独立ログであることをメニュー構成で伝える。
- 既存の Board / Meeting / BO / メモ / Phase10R・Phase10 互換の導線は壊さない。

## 2. メニュー順（IA）

1. **Board（会の地図）** — ダッシュボード（既存 DragonFlyBoard）
2. **Members（メンバー）** — メンバー一覧への導線
3. ---（区切り）---
4. **Meetings（例会）** — 例会への導線（BO は Meeting または Board 内導線のためメニュー必須ではない）
5. ---（区切り）---
6. **1 to 1（予定・履歴）** — 1 to 1 独立一覧への導線（Phase11B で実装。本 Phase ではリンクのみ仮置きでクリックで壊れないようにする）

## 3. スコープ

- **変更対象:** ReactAdmin のカスタム Menu 導入（または既存 Menu の拡張）、Layout にメニューを渡す。
- **ルーティング:** 既存を尊重。`/` = Board（ダッシュボード）、`/members`、`/meetings`、`/one-to-ones` をメニューから遷移可能にする。
- **Phase11B 前提:** `/one-to-ones` は Phase11B で Resource を実装する。本 Phase では該当パスに仮の一覧または「準備中」表示を置き、クリックで 404/エラーにならないようにする。

## 4. 実装方針

- React Admin の `Layout` に `menu` プロパティでカスタム `Menu` を渡す。
- `Menu` 内で `Menu.DashboardItem`（Board）、`Menu.ResourceItem` または `Menu.Item` で Members / Meetings / 1 to 1 を並べ、区切りは MUI `ListDivider` 等で表現する。
- Resource: `members`、`meetings`、`one-to-ones` を登録し、各 list は Phase11A ではプレースホルダーコンポーネントでよい（11B で one-to-ones を実装）。

## 5. DoD

- [x] メニューが上記の意図通り並ぶ
- [x] 既存画面（Board）への導線が壊れていない
- [x] docs 更新（PLAN / WORKLOG / REPORT ＋ INDEX / progress）
- [x] 1 コミット push → develop へ --no-ff merge → push
