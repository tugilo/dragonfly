# Phase 272 WORKLOG

tool: claude-code

## 判断メモ

- **シード戦略:** 新規テーブルは作らず `countries` / `regions` / `workspaces.region_id` を活用。既存 12 workspace は slug 突合で **id を維持**（22 件のクロスチャプター 1to1 FK を壊さない）。
- **NE外チャプター:** 全国を一律登録せず、既存121に登場したチャプターのみ正しいリージョンで登録する。大人なじみ=BNI 東京南、クリエーションズ=BNI 千葉セントラル、インフィニティ=BNI 静岡セントラル。田辺光さんはBNI会員外のため workspace/region 未設定。
- **東京NE 25件目:** ユーザー確認により、立ち上げ中の EduTech を東京NEリージョンとして追加。門松直幸さんの既存121相手 member を EduTech に紐付ける。
- **members API:** `workspace_id` は Request にあったが query 未適用だったため実装。`region_id` は workspace 経由で join。
- **1to1 UI:** 自チャプターは名簿 Autocomplete。他チャプターはリージョン（手動可）→ チャプター（手動可）→ 名前 → `POST /api/dragonfly/cross-chapter-targets/resolve` で `target_member_id` 解決。他チャプター名簿は一覧しない。
- **121 履歴:** 編集時に他チャプター相手はフォームへ region/workspace/名前を復元。

## 追補（同一 Phase 内の UX 改善・データ整合）

- **モーダル UI（誰でも使える化）:** 他チャプター相手選択を①リージョン→②チャプター→③名前のステップ式に再構成（番号バッジ・確定後 success Alert）。Quick Create の Owner 表示を生 ID から「#番号 氏名」に変更。
- **他チャプター相手の type:** `CrossChapterTargetResolveService` が新規相手を `visitor` で作成し「BNI会員以外」バッジが付いていた不具合を修正。別チャプター BNI 会員のため `member` に変更。既存の誤登録 21 件（DIANA・大人なじみ・EduTech・インフィニティ等の他チャプター所属者）も `member` に是正。
- **Members 名簿スコープ:** Members 一覧・1to1 リードを DragonFly チャプター在籍（`workspace_id` = bni_dragonfly または NULL のレガシー行）に限定。`ReligoDragonFlyWorkspace` を新設し、`dragonfly_chapter_only` フィルタを API に追加。他チャプター相手は 1to1 履歴側にのみ表示。
- **退会済みメンバー:** リストから Delete しかできなかった導線を改善。`type = former`（退会済み）を追加し、Members 行・カードに「退会済みにする」ボタンを実装（削除せず一覧から除外・履歴は保持）。`former` は名簿/リード/Dashboard peer から除外し、履歴 Chip は「退会済み」表示。
