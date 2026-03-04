# PHASE08 Religo workspace_id 自動取得（1 to 1 登録）— PLAN

**Phase:** 1 to 1 登録 UI の workspace_id を手入力から自動取得に変更  
**作成日:** 2026-03-04  
**SSOT:** [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.1 workspaces, §5.1 Workspace Scope Rules

---

## 1. 狙い

- Phase07 の workspace_id **手入力（初期値 1）**をやめ、単一 workspace 運用では「workspaces の先頭 1 件」を自動採用して事故率をゼロにする。
- 取得できない場合のみ、UI で入力を促し保存を無効にする（ガード）。

## 2. スコープロック

- **変更対象:** UI（DragonFlyBoard.jsx）＋ 1 to 1 登録で workspace を取得するための最小 API。
- **変更しない:** POST /api/one-to-ones の仕様、DB スキーマ、既存ルート（contact-memos, one-to-ones 以外）。Phase07 の planned/canceled 挙動はそのまま。

## 3. 方針

- 単一 workspace 運用では **GET /api/workspaces の先頭 1 件**を自動採用して workspace_id を埋める。
- 取得できない場合（API 失敗 or 0 件）は、ガイドメッセージを表示し保存ボタンを無効にする。
- 将来 multi-workspace のときは Select 化する余地を残す（今回は最小のまま）。

## 4. 既存 API の確認と追加

- **確認結果:** GET /api/workspaces は現状ないため、**最小限の GET /api/workspaces を追加**する（UI のみでは取得できないため）。
- **仕様:** `GET /api/workspaces` → 200, body: `[{ id, name, slug? }]`（id 昇順）。0 件の場合は `[]`。

## 5. UI 実装（DragonFlyBoard.jsx）

- コンポーネント初期化時（または Board 表示時）に **1 回** GET /api/workspaces を呼ぶ。
- **取得成功かつ 1 件以上:** 先頭の `id` を 1 to 1 登録モーダルの workspace_id として固定。入力欄は **read-only 表示**（または「ワークスペース: {name}」のように表示）し、送信時はその id を渡す。
- **取得失敗 or 0 件:** 1 to 1 登録モーダルで「workspace が未作成です。seed で 1 件作成してください。」などのガイドを表示し、**保存ボタンは無効**。

## 6. DoD

- [ ] GET /api/workspaces が存在し、先頭 1 件を UI が利用できる
- [ ] workspace_id 手入力が不要になる（自動で確定）
- [ ] 取得失敗時のガード（メッセージ表示＋保存不可）が動く
- [ ] Phase07 の動作を壊さない（planned/canceled 含む）
- [ ] PLAN / WORKLOG / REPORT 作成済み、1 コミット push、develop へ merge（--no-ff）

## 7. 手動スモーク（WORKLOG に記録）

- workspace 取得成功 → workspace_id が自動で入り、planned 登録できる
- workspace 取得失敗（API 失敗 or 0 件）→ 保存不可でガイドが出る
