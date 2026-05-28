# Phase 121 WORKLOG: チャプター外1to1相手の所属チャプター補正

## 2026-05-17 22:28 JST

### 判断

- SPEC-006 では `one_to_ones.workspace_id` は記録コンテキストで、相手の所属チャプターは `target_member.workspace_id` で表現する。
- Phase 120 ではDB未登録の相手を `visitor` として最小登録したが、所属チャプターが分かる相手は `workspace_id` を持たせる必要がある。
- 現在の `workspaces` は `Default Workspace` のみだったため、文書で所属チャプターが確認できる外部チャプターを `workspaces` に作成する。
- 国/リージョン階層は未整備のため、今回作成する `workspaces.region_id` は `null` とする。
- 木村秀継さんは文書上の所属チャプターが未確定のため、推測登録しない。

### 実施方針

- `slug` で `workspaces` を冪等に作成する。
- 対象 `members` を名前で取得し、該当 `workspace_id` に更新する。
- 既存の `one_to_ones.workspace_id = 1` は、次廣側の記録コンテキストとして維持する。

## 2026-05-17 22:30 JST

### 実施結果

- `workspaces` に次の4件を冪等作成した。
  - `bni_diana` / BNI Diana
  - `bni_otona_najimi` / BNI 大人なじみ
  - `bni_kernel` / BNI カーネル
  - `bni_reverie` / BNI レブリー
- 次の `members.workspace_id` を更新した。
  - 鈴木 健介 → BNI Diana
  - 飯塚氏（名 TODO） → BNI 大人なじみ
  - 伊藤 隆夫 → BNI 大人なじみ
  - 田村 広大 → BNI カーネル
  - 礒部 昌之 → BNI レブリー
- 木村 秀継は所属チャプター未確定のため `workspace_id = null` のまま維持した。

### 検証

- `one_to_ones.id` 17 / 20 / 21 / 23 / 24 について、`one_to_ones.workspace_id` と `target_member.workspace_id` が異なり、クロスチャプターとして判定できることを確認した。
- 既存 `workspace_id = 1` の表示名は `Default Workspace` のまま。これは従来データの記録コンテキスト名であり、DragonFly 表示名への補正は別判断とする。
