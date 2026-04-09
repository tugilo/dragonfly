# tugilo 統合実装プロンプト：ADMIN_GLOBAL_OWNER（SPEC-003）

**対象 SSOT:** [ADMIN_GLOBAL_OWNER_SELECTION.md](../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md)  
**位置づけ:** SSOT を「仕様書」ではなく **絶対ルール**として扱い、**設計意図を崩さず**コードへ落とす。実装手順の細目だけなら [PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md) を使う。**浅い解釈で動くコード**を出させないときは **本プロンプトを優先**する。

---

## プロンプトの位置（tugilo 式 5 本）

| 用途 | ファイル |
|------|----------|
| 汎用・SSOT 文書の磨き込み | [PROMPT_SSOT_IMPROVEMENT.md](PROMPT_SSOT_IMPROVEMENT.md) |
| 本 SSOT 専用・文書レビュー | [PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md) |
| 実装手順（Phase・dataProvider・出力形式） | [PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md](PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md) |
| **統合実行（設計を守る実装）** | **本ファイル** |
| **Phase 1〜5 連続実行（司令）** | [PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md](PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md) |

---

## 使い方

1. 下記 **プロンプト本文** を **`## 参照 SSOT`** の直前までコピーする。
2. 末尾に `ADMIN_GLOBAL_OWNER_SELECTION.md` の全文または §4.4・§5.1〜5.3 を貼る。
3. Phase 1〜5 を **順に最後まで**進めるときは [PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md](PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md) を使う。単発の厳格実装のみ本プロンプトを再掲する。

---

## プロンプト本文（ここからコピー）

```
あなたは「実装を量産する係」ではなく、設計を守るエンジニアとして振る舞ってください。
以下の SSOT（ADMIN_GLOBAL_OWNER_SELECTION.md / SPEC-003）を、仕様ではなく絶対ルールとして扱い、意図を破壊しないコードのみを出力してください。

リポジトリ: Religo 管理画面（`www/` Laravel + React Admin）。索引: docs/02_specifications/SSOT_REGISTRY.md。

## よくある失敗（思考として禁止）

- とりあえず動くようにする
- 数値フォールバックで埋める（特に `1`）
- API が 422 になるから勝手に `owner_member_id` を補う
- 画面の都合だけで「別の React state」に正規の owner を複製する

上記はいずれも SSOT 違反です。

## tugilo Core（必ず守る）

### 1. SSOT は絶対

- SSOT とコードが矛盾する場合、**コードを SSOT に合わせる**。無理なら **実装を止め**、矛盾点を報告する（SSOT 側の不足の可能性）。

### 2. owner_member_id は UI の都合の state ではない

- 「ドメイン上のスコープ基準」として扱う。見た目用のローカル state と **二重管理**しない。

### 3. 解決元は原則一つ

- 正規の取得元は **`GET /api/users/me`**。これ以外から「正しい owner」を捏造しない（`1` 補完禁止）。

### 4. dataProvider が React Admin 経路の唯一の注入点

- Owner 依存の query/body への付与は **dataProvider に集約**（SSOT §5.1）。画面でクエリに足さない。hook でこっそり足さない。

### 5. 未設定はバグではなく「状態」

- `owner_member_id === null` は **正常な未設定**。API を撃たない・fallback しない・§4.4 の UI に従う。

## 実装ルール（強制）

### Context

- `OwnerContext`（名称は実装で可）を用意し、少なくとも次を持つ:

```js
{
  ownerMemberId: number | null,
  loading: boolean,
  error: Error | null,
}
```

- **解決済み owner の単一の保存場所**とする（ヘッダー・dataProvider が同じ参照）。

### 初期ロード（順序は固定）

1. `GET /api/users/me` 完了
2. Context に反映
3. Owner 必須の子ルート・一覧 fetch を許可

この順を **逆にしない**（§5.3）。

### dataProvider

- Owner 必須のリクエストでは、**未解決ならネットワークを発行しない**（reject / 空配列 / no-op は react-admin の契約に合わせるが、**勝手にデフォルト ID を付けない**）。

### ヘッダー（CustomAppBar）

- Select 変更 → `PATCH /api/users/me` → 成功後に Context 更新 → 一覧等の refetch / invalidate。

### CustomRoutes / 直 fetch

- dataProvider 外は **同じ解決関数**のみ使用（例: `getResolvedOwnerMemberId()`）。独自に `?? 1` しない。

## 禁止コード（削除対象）

- `|| 1` / `?? 1`（owner 文脈）
- `const OWNER_MEMBER_ID = 1`（スコープ用途）
- `ownerMemberIdFallback` の null→1 相当

レビュー時: `rg '\|\| 1'` / `rg '\?\? 1'` / `OWNER_MEMBER_ID` 等（§5.2）。

## Phase（実装順）

1. getMe + Context
2. Header の Owner Select + 未設定プレースホルダー
3. dataProvider への注入一元化
4. 各画面・Board 等の付与除去
5. cleanup（grep で再確認）

## 出力形式（必ず 4 つ）

1. 実装コード（Context / dataProvider / Header の要点）
2. 修正箇所一覧（ファイルパス）
3. 削除したフォールバック・`1` 固定の一覧
4. 動作確認手順（未設定・選択・PATCH・遷移）

## 最終ルール

SSOT に従う実装が**できない**場合は、無理に動くコードを書かず、**SSOT または前提の欠陥として報告**する。

## 参照 SSOT

（以下に ADMIN_GLOBAL_OWNER_SELECTION.md の全文または主要節を貼る）
```

---

## 補足（運用・次の一手）

- **Phase 単位の短いプロンプト**（例: Phase1 のみ）を増やす場合は、本プロンプトの「Phase」節をそのまま短く切り出してもよい。
- **grep を CI に載せる**は別タスク（`.github/workflows` や `package.json` script）。パターンは SSOT §5.2 を参照。
- **全コードスキャン**で SSOT 違反を列挙させる場合は、本プロンプトの「禁止コード」節を `rg` 用に展開した指示を別途付与する。

---

## 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-04-06 | [PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md](PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md) を 5 本構成表に追加。 |
| 2026-04-06 | 初版（tugilo 統合実行・4 本構成表・プロンプト本文） |
