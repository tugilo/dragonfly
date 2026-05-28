# SSOT 改善プロンプト：ADMIN_GLOBAL_OWNER_SELECTION 専用（実戦版）

**対象 SSOT:** [ADMIN_GLOBAL_OWNER_SELECTION.md](../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md)（SPEC-003）  
**汎用プロンプト:** [PROMPT_SSOT_IMPROVEMENT.md](PROMPT_SSOT_IMPROVEMENT.md) — 本ファイルは **`owner_member_id` 横断・ヘッダー移設** に絞った **SSOT 文書のレビュー**用。コード実装は [PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md)。**設計を守る統合実行**は [PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md](PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md)。**Phase 連続実行**は [PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md](PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md)。

---

## 使い方

1. 下記 **プロンプト本文** を **`## 対象 SSOT（全文）`** の直前までコピーする。
2. 末尾に `docs/SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md` の **全文**（またはレビュー対象セクション）を貼る。
3. 必要なら **上級オプション** を追記する。
4. 出力された追記案を SSOT に反映したら、[INDEX.md](../INDEX.md)・関連 FIT/GAP・Phase PLAN の Related SSOT を整合させる。

---

## プロンプト本文（ここからコピー）

```
あなたはプロダクト設計レビューの専門家です。
以下の SSOT（Religo 管理画面：グローバル Owner 選択、ファイル ADMIN_GLOBAL_OWNER_SELECTION.md）を、実装フェーズで判断の余地が最小になるレベルまで改善してください。

リポジトリは Religo（Laravel API + React Admin）。仕様索引は docs/02_specifications/SSOT_REGISTRY.md。別 SSOT（DATA_MODEL・MEMBERS 要件など）と矛盾する場合は矛盾を列挙し、どちらを正とするか追記案を出すこと。

## 目的

- Cursor / エンジニアが「判断なし」で実装できる状態にする
- owner_member_id を中心としたドメインをブレさせない
- 将来の認証導入時にも破綻しない設計にする

## 最重要レビュー観点（優先順）

### ① 未設定状態の完全定義（最重要）

現行 SSOT で不足しがちな点を埋めること：

- owner_member_id が null（未設定）のとき:
  - 各 API を呼ぶか／呼ばないか（一覧・詳細・POST の区別も）
  - UI に何を表示するか（ブロッキング／スケルトン／空一覧／バナーの区別）
  - React Admin dataProvider はどう振る舞うか（エラーにする／空を返す／取得を遅延する）

必ず追記または改善する項目:

- UI 表示（具体的な文言例またはメッセージキー方針）
- API 呼び出し制御（呼ぶ / 呼ばない / 条件付き）
- ガード条件の例（if (!ownerMemberId) return … 等、疑似コード可）
- ユーザー導線（Settings・ヘッダー・ダッシュボードへの誘導）

### ② 初期ロードの挙動

明確にすること:

- GET /api/users/me の結果が返る**前**に、owner を要する API が走るか
- 走る場合のデフォルト仕様（禁止なら「走らせない」と明記）
- 走らせない場合のローディング・スピナー・ルート全体のブロック範囲

### ③ 状態管理の単一化

定義すること:

- owner_member_id の**唯一の取得元**（どのレスポンスフィールドが SSOT 上の正か）
- React 側の保持方法（Context 名・Provider のおおよその配置・react-admin との関係）
- 更新後の再取得（refetch / invalidate / カスタムイベントのいずれかを明文化）
- 「ヘッダー用 state」と「dataProvider」と「各画面の useEffect」で**二重定義が起きない**構造のルール

### ④ dataProvider の責務

明文化すること:

- owner_member_id を**どこで注入するか**（getList の引数だけか、クロージャか、Context か）
- 未設定時の振る舞い（reject / 空配列 / 遅延）
- 各 API への付与ルール（query 必須パラメータ・body の owner フィールド）

### ⑤ 禁止事項の強化

「1 にフォールバックしない」をさらに具体化すること:

- コードに**存在してはならないパターン**（例: ?? 1、定数 OWNER=1、ownerMemberIdFallback の null→1）
- レビュー・CI での**検出方法**（grep パターン、禁止語リスト）

### ⑥ UI とドメインの分離

確認し、不足なら補強すること:

- ヘッダー UI が無くてもドメインルールが成立するか
- owner_member_id の決定が UI コンポーネント名に依存していないか

### ⑦ 実装順序（Phase）の明文化

現行 SSOT に無い場合は追加すること:

- Phase 1〜Phase 5 程度の**推奨実装順序**
- 各 Phase のゴール（1〜2 文）
- Phase 間の依存関係（例: Context 導入 → dataProvider 置換 → Members → Board）

### ⑧ イベント設計（任意 → 推奨）

検討し、採用なら追記すること:

- religo-owner-changed（既存 religo-workspace-changed と同型かどうか）
- 再取得のトリガー（誰が購読するか）

## 出力形式

次の 4 部で出力すること。

### 1. 改善ポイント一覧

各項目: **問題点** / **なぜ問題か** / **改善内容**

### 2. 追記・修正 SSOT（コピペ可能）

- セクション単位で提示する
- そのまま ADMIN_GLOBAL_OWNER_SELECTION.md に貼れる形式（見出しレベルは既存に合わせる）

### 3. 実装時のハマりポイント

- 想定バグまたは仕様ギャップ
- 防止策（テスト・ログ・フラグ）

### 4. 最終評価

- 改善後の SSOT のまま実装した場合の**安定性**（高/中/低と理由）
- **残るリスク**（認証・権限・レース条件など）

## 対象 SSOT（全文）

（以下に docs/SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md の全文、またはレビュー対象セクションを貼る）
```

---

## 上級オプション（任意・プロンプト末尾に追記）

```
## 追加指示

この SSOT のまま実装した場合に起こり得るバグまたは仕様ギャップを 3 つ想定し、それぞれに対して SSOT レベルでの修正案（どの節に何を足すか）を提示してください。
```

---

## メモ

- 汎用の観点も必要なら、[PROMPT_SSOT_IMPROVEMENT.md](PROMPT_SSOT_IMPROVEMENT.md) と併用するか、汎用プロンプトの観点を末尾に追記する。
- Phase 番号は実際の [PHASE_REGISTRY.md](PHASE_REGISTRY.md) と突き合わせ、採用時に PLAN の Phase 名と揃える。

---

## 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-04-06 | [PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md](PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md) を冒頭に追記。 |
| 2026-04-06 | [PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md](PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md) を冒頭に追記。 |
| 2026-04-06 | 実装プロンプト [PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md) との役割分担を冒頭に明記。 |
| 2026-04-06 | 初版（ADMIN_GLOBAL_OWNER 専用・観点8・出力4部・上級オプション） |
