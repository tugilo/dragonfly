# PLAN: ONETOONES-P3（1 to 1 Create/Edit UX 改善）

| 項目 | 内容 |
|------|------|
| Phase ID | **ONETOONES-P3** |
| 種別 | implement |
| Related SSOT | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` §6、`docs/SSOT/DATA_MODEL.md` §4.12、ONETOONES-P1/P2 REPORT |
| 前提 | P1/P2 完了（一覧・統計・フィルタ・編集 API） |
| ブランチ（想定） | `feature/phase-onetoones-p3-create-edit-ux` |

## 1. 背景

- 一覧の実用性・視認性は P1/P2 で改善済み。残差分は **Create/Edit の操作感**（Owner 毎回選択、別ページ Create の重さ、メモの意味づけ）。
- モック完全一致は目的とせず、**日常的に記録・更新しやすい**体験を優先する。

## 2. 対象範囲

1. **Owner 既定:** `GET /api/users/me` の `owner_member_id` を一覧 `filterDefaultValues`・クイック作成・フル Create の初期値に。未設定時は従来互換 `1`（`ownerMemberIdFallback`）。
2. **Create UX:** 一覧から **Dialog によるクイック追加**（相手・状態・任意の日時・例会 ID・notes）。従来の **`/one-to-ones/create` フルフォーム**は維持（ツールバー「フォームで追加」）。
3. **Edit UX:** 既存のヘッダー文脈・ツールバー「一覧へ戻る」・保存後一覧 redirect を維持・整合。
4. **notes 導線:** 一覧メモ Dialog・Create/Edit のラベル／helper で **「当該 1to1 の要約メモ」** と明示。**contact_memos** は時系列・履歴の本格領域として後続とドキュメントに分離。

## 3. 対象外

- contact_memos 本格統合、統計と一覧フィルタの完全同期、権限大改修、履歴型メモモデル新設。

## 4. 実装方針

- 既存 REST・react-admin Resource 構造は維持。Dialog は `List` 子で `useListContext` / `useRefresh` を利用。
- Owner は引き続き変更可能（マルチユーザー前提を壊さない）。

## 5. テスト観点

- `php artisan test` 全件、`npm run build`。
- 手動: 一覧初期表示で Owner フィルタが me に近い値になること、クイック作成で保存・一覧更新、メモ Dialog→編集遷移、P1/P2 回帰（統計・フィルタ・行操作）。

## 6. DoD

- Owner 既定の UX が改善している。
- Create が一覧から軽く開始できる。
- notes の位置づけが利用者目線で説明されている。
- PLAN / WORKLOG / REPORT・REGISTRY・INDEX・progress・FIT_AND_GAP・DATA_MODEL の必要箇所を更新済み。
