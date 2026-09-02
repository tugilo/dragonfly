# Phase 302 — 1to1 相手検索（他チャプター登録済み相手をチャプター・氏名・カテゴリで検索）

**Phase ID:** 302  
**Type:** implement  
**Status:** completed  
**Branch:** `feature/phase302-one-to-one-target-search`  
**作成:** 2026-09-02 09:40 JST

## Purpose

1to1 作成／編集フォームの相手選択で、**他チャプターの登録済み相手を検索して選べる**ようにする。

現状（Phase 272）は「他のチャプター」を選ぶと、過去の 1to1 で既に `members` に登録済みの相手であっても、毎回 ①リージョン → ②チャプター → ③氏名入力 → 確定 を経る必要があり、検索が無い。「自分のチャプター」側は氏名・カテゴリで Autocomplete 絞込ができるが、単一チャプターなので「チャプター名で探す」ニーズはそもそも他チャプター側にある。

ユーザー要望（2026-09-02）: 「1to1画面で相手の検索機能が欲しい。チャプター、名前、カテゴリーなど」

## Related SSOT

- SPEC-021 [REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md](../../SSOT/REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md) §6.2 T2 / T4（本 Phase で T6 を追加し T2 の注記を補正）
- SPEC-006 [ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md)
- [FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md](../../SSOT/FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md)
- [CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md](../../SSOT/CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md) §4（候補ラベル表示）

### SSOT 補正（本 Phase で実施）

SPEC-021 T2 備考「他チャプター名簿は一覧表示しない」は **「クエリ未入力時に名簿を全件列挙しない」** の意図として維持し、**利用者がキーワードを入力したときのみ、該当する登録済み相手を検索結果として表示する** T6 を追加する。名簿の一覧表示（ブラウズ）は引き続き行わない。

## Scope

| 領域 | ファイル |
|------|----------|
| API | `www/app/Http/Controllers/Api/DragonFlyMemberController.php`（index）、`www/app/Http/Requests/Api/IndexDragonFlyMembersRequest.php` |
| UI | `www/resources/js/admin/pages/OneToOnesFormParts.jsx` |
| Tests | `www/tests/Feature/Api/DragonFlyMembersExtendedSearchTest.php`（新規） |
| Docs | Phase 302 3ファイル、SPEC-021 SSOT・Fit&Gap、PHASE_REGISTRY、INDEX、progress |

`package.json` / `composer.json` は変更しない。

## 設計

### API: `GET /api/dragonfly/members` 拡張（既存パラメータの挙動は変えない）

| パラメータ | 型 | 内容 |
|-----------|----|------|
| `q_extended` | boolean | `q` の対象を `name` / `name_kana` / `display_no` に加え **`workspaces.name`（チャプター名）・`categories.group_name` / `categories.name`（カテゴリ）** へ拡張 |
| `exclude_workspace_id` | integer（exists:workspaces） | 当該 workspace 所属メンバーを除外（自チャプター除外用）。`workspace_id` NULL の行（BNI 会員外など）は残す |
| `limit` | integer 1–200 | 返却件数の上限（検索 Autocomplete 用） |

### UI: 「他のチャプター」モードに検索を追加（`OtherChapterTargetFields`）

1. 先頭に **「登録済みの相手を検索」** Autocomplete（サーバー検索・debounce 250ms・1 文字以上で検索）を置く
   - 呼び出し: `GET /api/dragonfly/members?q=<入力>&q_extended=1&exclude_workspace_id=<owner の workspace_id>&limit=30`
   - 候補行: 主行「#No 氏名（チャプター）」＋ 副行「大カテゴリ / カテゴリ（or 役職）」（既存 `memberDisplay` ヘルパ流用）
   - 選択で `target_member_id` を set → 既存の `targetId` effect が相手を fetch し success Alert（「相手を設定しました」）と region/chapter/氏名を復元
2. 区切り「見つからない場合は新規に登録」の下に、既存の ①〜③ 手動登録フローをそのまま残す
3. 「自分のチャプター」モードは変更しない（既に氏名・カテゴリで絞込可）

## DoD

- [x] `GET /api/dragonfly/members?q=…&q_extended=1` がチャプター名・カテゴリ名でもヒットする（Feature テスト）
- [x] `exclude_workspace_id` で自チャプターが除外され、`workspace_id` NULL は残る（Feature テスト）
- [x] `limit` で件数が上限される（Feature テスト）
- [x] 既存 `q` の挙動（`q_extended` 無し）が変わらない（既存テスト `DragonFlyMembersIndexFilterSortTest` 通過・新規テストで `q=DIANA` が 0 件を確認）
- [x] 1to1 作成／編集の「他のチャプター」で、氏名・チャプター名・カテゴリいずれの入力でも登録済み相手が候補に出て、選択で相手が確定する（ローカル UI で「Diana」→ DIANA 3 名 → 選択で確定・所属復元を確認）
- [x] 見つからない場合は従来の手動登録フローが使える
- [x] `php artisan test` 全通過（605 passed）、`npm run build` 成功
- [x] SPEC-021 T6/A5 追加・Fit&Gap G13・INDEX・progress・PHASE_REGISTRY 更新

## Tasks

1. `IndexDragonFlyMembersRequest` に `q_extended` / `exclude_workspace_id` / `limit` を追加、`DragonFlyMemberController::index` に適用
2. Feature テスト `DragonFlyMembersExtendedSearchTest` 追加
3. `OneToOnesFormParts.jsx` に `RegisteredTargetSearch`（サーバー検索 Autocomplete）を実装し `OtherChapterTargetFields` 先頭へ配置
4. React build、`php artisan test`
5. SSOT / Fit&Gap / INDEX / progress / PHASE_REGISTRY 更新 → develop merge → Merge Evidence

## モック比較

モック比較: [docs/SSOT/MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) に従う。1to1 相手選択フォームはモックに該当画面なし（Phase 272 と同様）。差分は [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) 記録対象外、SPEC-021 Fit&Gap に記録する。
