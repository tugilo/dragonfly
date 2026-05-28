# 実装プロンプト：ADMIN_GLOBAL_OWNER_SELECTION（tugilo / SPEC-003）

**対象 SSOT:** [ADMIN_GLOBAL_OWNER_SELECTION.md](../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md)  
**用途:** SSOT に従い **コードを実装・修正**するときに Cursor / Claude / GPT へ渡す **そのまま貼れる指示**（設計レビュー用は [PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md)）。  
**より厳格に「設計を守る」:** [PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md](PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md)（浅い解釈・fallback 防止）。  
**Phase 1〜5 を順に完走:** [PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md](PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md)。

---

## 使い方

1. 下記 **プロンプト本文** を **`## 参照・前提`** の直前までコピーする。
2. 必要なら `ADMIN_GLOBAL_OWNER_SELECTION.md` の該当節を貼る。
3. Phase 単位で切る場合は、**出力形式**のうち該当 Phase だけを指示に追加する。
4. 完了後、`npm run build`（`www/` のフロント変更時）と `php artisan test` を SSOT DoD どおり実行する。

---

## プロンプト本文（ここからコピー）

```
あなたはフロントエンドおよびバックエンド統合実装のプロフェッショナルです。
以下の SSOT に基づき、判断の余地を最小化して実装を完了してください。

リポジトリ: Religo 管理画面（Laravel `www/` + React Admin）。仕様索引: docs/02_specifications/SSOT_REGISTRY.md（SPEC-003）。

## 目的

- `owner_member_id` をグローバルに統一する
- 数値 `1` へのフォールバックをコードベースから排除する
- React Admin では dataProvider を Owner 付与の中心に据える（SSOT §5.1）

## 実装方針（絶対ルール）

### 1. 単一の真実（SSOT）

- 解決済み `owner_member_id` の取得元は **`GET /api/users/me`** を正とする（表示用の一時 state は Context に載せ、サーバと PATCH で整合させる）。
- 各画面が **独自の**「正しい owner」state を持たない（二重定義禁止）。

### 2. 禁止事項（厳守）

次を書かない。既存があれば削除する。

- `owner_member_id || 1` / `owner_member_id ?? 1`
- `const OWNER_MEMBER_ID = 1`（Owner スコープ用途）
- `if (!owner_member_id) owner_member_id = 1` および同等の黙示的代入
- `ownerMemberIdFallback` の null→1 相当のフォールバック全般

### 3. dataProvider

- React Admin が叩く **Owner 依存 API** には、dataProvider が `owner_member_id` を付与する（SSOT §5.1）。
- 各画面コンポーネントでクエリに `owner_member_id` を足さない。
- CustomRoutes / 直 fetch は dataProvider 外のため、**同じ解決済み ID** を返す共通ヘルパ（例 `getResolvedOwnerMemberId()`）のみ使用。

### 4. 未設定時の挙動（§4.4）

- `owner_member_id` が null の間: Owner 必須の **API を呼ばない**。
- メイン: 「Ownerを選択してください」。ヘッダー Select は未選択。
- ガード: `if (!ownerMemberId) return;` 等で子に不正 fetch をさせない。

### 5. 初期ロード（§5.3）

1. `GET /api/users/me` 完了まで待つ
2. `owner_member_id` を Context に格納
3. その後に Owner 必須の一覧 fetch / 子ルート描画

### 6. 状態管理

- React Context（または同等）で `owner_member_id`（と loading / error）を保持し、ヘッダーと dataProvider が同じ値を参照する。

### 7. ヘッダー（CustomAppBar）

- Owner Select を配置。変更時: `PATCH /api/users/me` → 成功後 Context 更新 → 一覧等の refetch / invalidate。

### 8. 既存コードの修正対象

- 初期 `useState(1)`、定数 `OWNER_MEMBER_ID = 1`、`getOwnerMemberId` の `?? 1`、画面直書きの owner クエリ、など SSOT と矛盾する箇所を洗い出して修正。

### 9. Phase 順で実装

- **Phase 1:** `getMe` + Context（Provider を Admin ルートを包む）
- **Phase 2:** CustomAppBar に Owner Select + 未設定時プレースホルダー
- **Phase 3:** dataProvider で owner 注入の一元化
- **Phase 4:** Members / MemberShow / OneToOnes / DragonFlyBoard 等の付与・fallback 除去
- **Phase 5:** cleanup（grep で `|| 1` `?? 1` `OWNER_MEMBER_ID` を再確認）

## 出力形式

1. **実装コード**（または差分の要点）— Context、dataProvider、ヘッダー、必要なラッパ
2. **修正箇所一覧** — ファイルパスと変更内容
3. **削除・廃止したコード一覧** — fallback / 1 固定
4. **動作確認手順** — 未設定・選択・PATCH・画面遷移

## 重要

- 「とりあえず動く」ためのフォールバックは禁止。SSOT と矛盾する場合は **実装を止めて** 矛盾点を報告する。

## 参照・前提

（必要なら docs/SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md の該当節を貼る）
```

---

## メモ

- 本プロンプトは **実装** 向け。SSOT 文書そのものを磨くときは [PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md) を使う。
- Phase は [PHASE_REGISTRY.md](PHASE_REGISTRY.md) の次番号と PLAN 名で正式化すること。

---

## 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-04-06 | [PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md](PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md) を冒頭に追加。 |
| 2026-04-06 | [PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md](PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md) への参照を冒頭に追加。 |
| 2026-04-06 | 初版（tugilo 式・Phase1〜5・出力4部） |
