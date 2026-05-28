# tugilo Phase Runner：ADMIN_GLOBAL_OWNER（SPEC-003）

**対象 SSOT:** [ADMIN_GLOBAL_OWNER_SELECTION.md](../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md)  
**最優先ルール:** [PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md](PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md)  
**補助手順:** [PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md)

**目的:** Phase 1〜5 を **順番に**実行し、**SSOT を崩さず**最後まで実装を完了させる（飛ばし・並列・未検証の進行を禁止）。

---

## プロンプトの位置（tugilo 式 5 本）

| レイヤー | プロンプト |
|----------|------------|
| 思想 | SSOT（`ADMIN_GLOBAL_OWNER_SELECTION.md`） |
| 文書改善 | [PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md) / [PROMPT_SSOT_IMPROVEMENT.md](PROMPT_SSOT_IMPROVEMENT.md) |
| 手順 | [PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md) |
| 守り | [PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md](PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md) |
| **制御（本ファイル）** | **Phase を最後まで連続実行** |

---

## 使い方

1. 下記 **プロンプト本文** を **`## 参照 SSOT`** の直前までコピーする。
2. 末尾に `ADMIN_GLOBAL_OWNER_SELECTION.md` の全文または §4.4・§5.1〜5.3 を貼る。
3. **セッションごとに 1 Phase** で切るか、コンテキストが許すなら 1 セッションで 1〜5 を連続指示する（後者はトークン上限に注意）。

---

## プロンプト本文（ここからコピー）

```
あなたは単なる実装者ではなく、Phase を管理しながら設計を守るエンジニアとして振る舞ってください。

## 参照（必ず読む）

- SSOT: ADMIN_GLOBAL_OWNER_SELECTION.md（SPEC-003）
- すべての Phase で最優先: PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md の原則（禁止思考・tugilo Core・dataProvider 単一注入）
- 手順の補足: PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md

## 最重要ルール

### 1. TUGILO_EXECUTION を最優先

各 Phase で必ず従う。違反するなら **実装を止め**、矛盾を報告する。

### 2. Phase は必ず順番通り

Phase1 → Phase2 → Phase3 → Phase4 → Phase5

- 飛ばさない
- 並列にしない
- 勝手に巻き戻さない（問題があれば報告してから対応）

### 3. 各 Phase は「完了判定」まで

「実装しただけ」「とりあえず動いた」では **完了にしない**。**検証**（該当 Phase の完了条件）までやって初めて次へ。

### 4. 次の Phase に進む条件

次を満たす場合のみ進む:

- SSOT 違反がない
- `|| 1` / `?? 1` 等の fallback がその Phase の範囲に残っていない
- dataProvider の責務（§5.1）を壊していない

## Phase 定義

### Phase1: Owner 解決基盤

**目的:** `GET /api/users/me` で owner を取得し Context に保持する。

**やること:** OwnerContext（または同等）、getMe、loading / error。

**完了条件:**

- `ownerMemberId` が Context から取得できる
- 未設定時は `null` のまま（fallback なし）
- §5.3 の順序（me 完了前に Owner 必須 API を叩いていない）

---

### Phase2: UI 統合（ヘッダー）

**目的:** Owner 選択をグローバルヘッダーへ。

**やること:** CustomAppBar に Select、PATCH、§4.4 の未設定 UI。

**完了条件:**

- 変更 → PATCH 成功 → Context 更新 → 必要な refetch
- 未設定時は「Ownerを選択してください」等（§4.4）

---

### Phase3: dataProvider 統一

**目的:** owner 付与を dataProvider に一元化（§5.1）。

**やること:** dataProvider 修正、未解決時はネットワークを撃たない等。

**完了条件:**

- React Admin 経路の Owner 依存 API に owner が一貫して付く
- 画面コンポーネントが独自に query に `owner_member_id` を足していない

---

### Phase4: 既存コード修正

**目的:** fallback 完全排除。

**やること:** `|| 1` / `?? 1` / `OWNER_MEMBER_ID = 1` 等の削除、各画面・CustomRoutes / 直 fetch の統一。

**完了条件:**

- 目標パターンの grep で該当なし（§5.2）。CustomRoutes も `getResolvedOwnerMemberId()` 等に寄せ済み。

---

### Phase5: 最終整合

**目的:** SSOT・DoD と一致。

**やること:** 全画面の動作確認、初期ロード、未設定、ヘッダー PATCH。

**完了条件:**

- SSOT §8 DoD を満たす
- `npm run build` / `php artisan test`（フロント・PHP 変更時）

## 実行フロー（各 Phase で繰り返す）

1. 当該 Phase の実装
2. 出力（下記 4 部）
3. 自己検証（完了条件チェック）
4. 問題があれば当 Phase 内で修正
5. 完了宣言
6. 次の Phase へ（Phase5 まで）

## 出力形式（毎 Phase）

必ず次の 4 つ:

1. 実装コード（要点）
2. 修正箇所一覧
3. 削除コード一覧（fallback / 1 固定）
4. 動作確認手順

## 強制停止条件

次の場合は **進めない**:

- SSOT と矛盾し、コード側で無理やり合わせないと進まない
- fallback しか解決策がない
- dataProvider を破壊しないと動かない

→ **SSOT または前提の不足**として報告する。

## 禁止思考

- とりあえず動かす / 後で直す
- UI 優先でドメインを曲げる
- API のエラーに合わせて勝手に ID を埋める

## 開始

**Phase1** から開始する。

## 参照 SSOT

（以下に ADMIN_GLOBAL_OWNER_SELECTION.md の全文または主要節を貼る）
```

---

## メモ

- 長いセッションでは **Phase ごとに新しいチャット**で本プロンプトを再掲し、「Phase N 完了・次は Phase N+1」と明示するとブレにくい。
- Phase 名は [PHASE_REGISTRY.md](PHASE_REGISTRY.md) の正式番号と PLAN で揃える。

---

## 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-04-06 13:54 JST | 初版（Phase1〜5・完了条件・TUGILO 最優先・5 層表） |
