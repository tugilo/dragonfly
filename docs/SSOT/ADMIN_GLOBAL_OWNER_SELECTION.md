# Religo 管理画面：グローバル Owner 選択（SSOT）

| 項目 | 内容 |
|------|------|
| 状態 | **実装あり（管理画面）** — 主要コードは `ReligoOwnerProvider` 等に反映済み。**記録・FIT/GAP:** Phase `ADMIN_GLOBAL_OWNER_SPEC003_DOCS`（[PLAN](../process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_DOCS_PLAN.md)）。**follow-up:** Phase `ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP`（[REPORT](../process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_REPORT.md)）で `/settings` ゲート例外・1 to 1 の owner フィルタ削除・§5.1 補足・`religoOwnerMemberId.js` 削除を反映。 |
| 関連 | [DATA_MODEL.md](DATA_MODEL.md)（User・Member）、[FIT_AND_GAP_MENU_HEADER.md](FIT_AND_GAP_MENU_HEADER.md)、[DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md)、[PROMPT_SSOT_IMPROVEMENT.md](../process/PROMPT_SSOT_IMPROVEMENT.md)（汎用）、[PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md)（**SSOT 文書のレビュー**）、[PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md)（**実装手順**）、[PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md)（**統合実行**）、[**PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md**](../process/PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md)（**Phase1〜5 連続実行・司令**） |
| API | `GET/PATCH /api/users/me`（`owner_member_id`） |

---

## 1. 背景と課題

- **Owner（自分）** は Religo 管理画面のスコープ基準であり、`owner_member_id` をクエリ・POST に載せる機能が複数画面に存在する。
- 現状、Owner 選択 UI は **ダッシュボード限定** の箇所があり、他画面は **`members.id = 1` へのフォールバック**や **初期 state の 1** など、**ダッシュボードで選んだメンバーと一致しない**ことがある。
- 利用者の期待は「**どの画面でも、いま選んでいる Owner が基準**」である。

本ドキュメントは、**Owner 選択をグローバルヘッダーに集約し、全画面で同一の基準を使う**ための要件と、**将来のユーザー認証導入時の移行方針**を定義する。

---

## 2. 目的（Goals）

1. **単一の基準**: 管理画面全体で、データ取得・更新の「自分」は **同一の `owner_member_id`** とする。
2. **UI の置き場所**: Owner 選択は **グローバルヘッダー（AppBar）** に配置し、ダッシュボード専用に依存しない。
3. **永続化**: 選択の保存は既存どおり **`PATCH /api/users/me`** の `owner_member_id`（DB: `users.owner_member_id`）を正とする。**`GET /api/users/me`** で復元する。
4. **マジックナンバー禁止**: 未設定時に **`1` へフォールバックしない**。未設定は明示的な UX（設定導線・エラー・空状態）で扱う。
5. **認証後の互換**: 将来ログインユーザーに紐づく形にしても、**API・ドメイン上の「Owner ID でスコープする」モデルは維持**できること。

---

## 3. SSOT：Owner の意味とデータ

| 概念 | 定義 |
|------|------|
| **Owner** | 操作中の「自分」に相当する **members テーブルの 1 行**（`members.id`）。 |
| **保存場所** | `users.owner_member_id`（現在の管理ユーザー行）。単一チャプター運用・1 ユーザー 1 オーナー想定は既存 DATA_MODEL に従う。 |
| **読み取り** | `GET /api/users/me` の `owner_member_id`。 |
| **更新** | `PATCH /api/users/me` の `body: { owner_member_id: <members.id> }`。 |

ダッシュボードで既に行っている **PATCH による保存** は、この SSOT と一致しており、**ヘッダーへ UI を移す場合も同じ API を用いる**。

---

## 4. UI 要件：グローバルヘッダー

### 4.1 配置

- **実装想定**: `CustomAppBar.jsx` / `ReligoLayout.jsx` 系の **常時表示ヘッダー**。
- **ラベル**: 例「Owner」または「自分（メンバー）」— 既存ダッシュボード表記と揃える。
- **コントロール**: メンバー一覧から選択する **Select**（検索付きにするかは実装 Phase で FIT/GAP 判断）。

### 4.2 振る舞い

- 初回ロード: `GET /api/users/me` で `owner_member_id` を取得し、Select の値に反映。
- 変更時: `PATCH /api/users/me` で保存。成功後、**依存データを再取得**する（既存ダッシュボードの `saveOwner` と同様の考え方）。
- **全画面共通**: ルートがダッシュボードでなくても、ヘッダーの Owner は同じ state（または Context）を参照する。

### 4.3 ダッシュボードからの移設

- ダッシュボード **専用** の Owner ドロップダウンは **削除または非表示**とし、**二重表示にしない**。
- ダッシュボード固有の「初回オーナー未設定」カードは、**ヘッダーと連動**した導線（未設定時はヘッダーまたは同じ PATCH フロー）に寄せるか、実装 Phase で文言のみ調整する。

### 4.4 未設定時の挙動（必須）

`owner_member_id` が **null**（未解決・未設定）の場合、次を守る。

#### UI

- ヘッダーの Select は **未選択状態**で表示する。
- **メインコンテンツはデータを表示しない**（一覧・詳細・ボードのいずれも、Owner スコープが必要なものは描画しない）。
- **例外:** ルート **`/settings`**（ReligoSettings：所属チャプター等）のみ、`owner_member_id` 未設定でも **メインに子ルートを表示**する。それ以外のルートはゲートする（follow-up: `ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP`）。

#### 表示

- メイン領域に **「Ownerを選択してください」** と表示する（文言は実装で微調整可だが、意味はこの SSOT と一致させる）。

#### API

- `owner_member_id` が **未解決**の状態で、Owner を要する **API を実行してはならない**（一覧取得・POST・PUT 等、クエリ/body に `owner_member_id` が前提の呼び出しを禁止）。

#### 実装ルール

- Owner スコープが必要な処理の先頭でガードする。例: `if (!ownerMemberId) return;`（早期 return。子コンポーネントに不正な fetch をさせない）。

---

## 5. アプリ全体の振る舞い（実装指針）

以下は **実装 Phase** でコードに落とす際の指針。本 SSOT は API 契約を変えない。

| 領域 | 指針 |
|------|------|
| **React Admin dataProvider** | 下記 **§5.1**。`owner_member_id` 未指定時に `1` を使わない。**グローバルに解決した Owner ID**（Context または `getMe()` の結果）を dataProvider 経由で付与する。 |
| **DragonFly Board（Connections）** | 初期 state を `1` に固定しない。`me` または Context と同期。 |
| **Members / Member 詳細** | 定数 `OWNER_MEMBER_ID = 1` を廃止し、**同一の Owner 解決**を使う。画面側で `owner_member_id` を独自付与しない（§5.1）。 |
| **1 to 1 作成・一覧・モーダル** | **ヘッダー Context / dataProvider と二重定義しない**よう統一する。 |
| **フォールバック関数** | `ownerMemberIdFallback` の **`null → 1`** は廃止または非推奨とし、呼び出し側で未設定を明示処理する。 |

### 5.1 dataProvider の責務（必須）

- **dataProvider** が、React Admin 経由で叩く **Owner 依存 API** に対し、`owner_member_id` を **付与する唯一の責務**を持つ（クエリ / 必要なら body の方針に合わせる）。
- **各画面コンポーネント**で `owner_member_id` をクエリに足してはならない（重複・不整合の源になる）。
- 注入する値は **Context で保持した解決済み ID**、または **getMe() で解決した値**に限定する（§5.3 の初期ロード完了後）。

※ **CustomRoutes** や `fetch` 直書きの画面（Connections 等）は dataProvider 外のため、**同じ解決済み `owner_member_id` のみ**を参照する別モジュール（例: `getResolvedOwnerMemberId()`）で統一する。二重付与は禁止。

**補足（SPEC-003 follow-up）:** 「各画面コンポーネントで `owner_member_id` をクエリに足してはならない」の意図は、**画面ごとに別々のロジックで Owner ID を決めて付与することを禁止**するものである。**`ReligoOwnerContext` / `religoOwnerStore` が返す同一の解決済み `owner_member_id`** を、dataProvider 以外の `fetch`（例: 集計 API、メンバー絞り込み）のクエリに含めることは、**単一真実の伝播**であり本 SSOT と矛盾しない。禁止するのは **§5.2 のマジックナンバー**および **ヘッダー・me 解決と無関係な独自 ID の付与**である。

### 5.2 禁止パターン（厳格）

以下の **意図**を満たすコードは **存在してはならない**（`owner_member_id` のフォールバックとしての `1`）。

- `owner_member_id || 1`
- `owner_member_id ?? 1`
- `const OWNER_MEMBER_ID = 1`（Owner スコープ用途）
- `if (!owner_member_id) owner_member_id = 1`（および同等の黙示的代入）

**レビュー時の検出（目安）:**

| 手段 | パターン例 | 注意 |
|------|------------|------|
| grep / ripgrep | `\|\| 1` | `owner_member_id`・`ownerMemberId` 周辺を優先して確認 |
| grep / ripgrep | `\?\? 1` | 同上 |
| grep / ripgrep | `= 1` | **誤検出が多い**。`display_no` 等との区別し、`OWNER` / `owner_member` 系のみを対象とする |

機械的な禁止だけでなく、**意味として「未設定を 1 にする」**コードはすべて本 SSOT に反する。

### 5.3 初期ロード制御（必須）

- `owner_member_id` が **未取得**の間は、Owner を要する **API を実行してはならない**（§4.4 と整合）。
- 初期ロードでは **`GET /api/users/me` の完了を待ってから**、dataProvider 経由の一覧取得等を開始する（ルート全体をスピナーで包む・Admin 子を条件付きレンダーする等、実装は Phase で決める）。

**オプション**: `window` カスタムイベント（既存の `religo-workspace-changed` と同型）で `religo-owner-changed` を発火し、**同一タブ内の一覧の再取得**を促す。必須ではない。

---

## 6. 将来：ユーザー認証を追加したとき

### 6.1 UI

- **グローバルヘッダーの Owner 選択 UI は削除（または管理者のみ表示）**してよい。
- 一般ユーザーは「自分のメンバー ID」が **ログインコンテキストから一意に決まる**想定。

### 6.2 機能・API

- **Owner ID ベースでスコープする**というモデルは維持する。
  - クエリ・POST の `owner_member_id`、集計・フラグ・メモ・1 to 1 などは、**認証後はサーバが「ログインユーザーに許可された member id」のみ受け付ける**形に寄せる（実装は別 Phase・セキュリティ SSOT）。
- `GET /api/users/me` は、認証後も **解決済みの `owner_member_id`** を返すか、JWT クレームと DB の整合を取る設計とする。

### 6.3 移行のイメージ

| 段階 | Owner の決まり方 |
|------|-------------------|
| 現在〜本 SSOT 実装後 | ユーザーがヘッダーで選択 → `users.owner_member_id` に保存。 |
| 認証後 | UI 省略。**ログインユーザー ↔ member** の紐付けで `owner_member_id` が決定（必要なら初回のみ設定画面）。 |

---

## 7. 非目標（本ドキュメントの範囲外）

- 多テナント・複数チャプター同時操作の詳細設計（Workspace との優先順位は既存 Religo SSOT に従う）。
- サーバ側の権限チェック（誰がどの `owner_member_id` を指定できるか）の詳細—認証 Phase で別途。

---

## 8. 実装完了の判断（DoD 案）

運用メモ（2026-04-06）: 以下は **コード / 文書 / follow-up** に分けて追記する。**§5.1 を「画面はクエリに owner を載せない」と厳密読みした場合**、直 fetch は同一 ID を URL に載せるため **別 Phase で SSOT 文面または実装をすり合わせる**こと。

- [x] グローバルヘッダーに Owner 選択があり、**全主要画面**で同じ選択が参照される。（`CustomAppBar` + `useReligoOwner` / `religoOwnerStore`）
- [x] ダッシュボードに Owner 専用の重複 UI がない（または仕様どおりの単一導線のみ）。（Dashboard から Owner 操作を除去済み）
- [x] コードベースに **`owner_member_id` の `1` 固定・null→1 フォールバック**が残っていない（検索で確認）。（棚卸し・grep 前提。取り込み前に再実行推奨）
- [x] `npm run build` / `php artisan test` 通過。（実装取り込み時の記録を REPORT に残すこと）
- [x] [FIT_AND_GAP_MENU_HEADER.md](FIT_AND_GAP_MENU_HEADER.md) に差分があれば追記。（2026-04-06 更新・Phase `ADMIN_GLOBAL_OWNER_SPEC003_DOCS`）
- [x] §4.4・§5.1〜5.3 の **挙動**はコードで概ね満たす。§5.1 の **厳密な「画面はクエリに載せない」**読みと実装の整合は **ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP** で補足追記済み（独自付与禁止と Context 由来 ID の両立）。
- [x] §9 のプロンプト群はリポジトリに存在する。
- [ ] §10 の **SSOT 改善プロンプト適用で本文が完全レビュー済み**とは限らない（必要時に [PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md) を実行）。

---

## 9. 実装プロセス（重要）

本 SSOT に基づく **コード実装** は、次のいずれか（または併用）を Cursor / GPT / Claude に渡す前提とする。

| プロンプト | 向き |
|------------|------|
| [PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT.md) | Phase 分割・dataProvider・Context・出力形式まで具体化した **実装手順** |
| [PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md) | SSOT を **絶対ルール**として扱い、浅い解釈で「動くコード」だけを出させない **統合実行（設計守備）** |
| [PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md) | Phase 1〜5 を **順番に**最後まで完走させる **司令（連続実行）**。各 Phase **完了判定まで**。**TUGILO_EXECUTION を全 Phase で最優先** |

**実装 Phase** では **Phase 1〜5** を順に進め、§4.4・§5.1〜5.3 と矛盾しないコードにする。迷いやすい・AI がフォールバックしがちな場合は **TUGILO_EXECUTION** を優先する。**一気通貫で進める**ときは **PHASE_RUNNER** を使う。

---

## 10. SSOT 改善プロセス（重要）

本 SSOT **文書**は、次の **レビュー専用プロンプト**により追記・改善される前提とする（実装プロンプトとは役割が異なる）。

- [PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md)

**実装 Phase に入る前**に、上記プロンプトを対象ドキュメント（本ファイル）へ適用し、少なくとも次を満たすこと。

- **未設定状態**が §4.4 レベルで完全定義されている。
- **初期ロード**の挙動が §5.3 と矛盾しない。
- **dataProvider の責務**が §5.1 と矛盾しない（画面独自付与が残っていない設計になっている）。
- **フォールバック**（`|| 1` 等）が設計・コード両面で存在しない、または検出・削除手順が明文化されている。

---

## 11. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-04-06 JST | **Phase ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP:** §4.4 に `/settings` ゲート例外を追記。§5.1 に「独自付与禁止」と Context 由来 ID のクエリ許容の補足を追記。 |
| 2026-04-06 JST | **Phase ADMIN_GLOBAL_OWNER_SPEC003_DOCS:** [FIT_AND_GAP_MENU_HEADER.md](FIT_AND_GAP_MENU_HEADER.md) を現行 AppBar・Owner・ゲートに更新。§8 DoD チェックを運用メモ付きで更新。PLAN/WORKLOG/REPORT（[PLAN](../process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_DOCS_PLAN.md)）。 |
| 2026-04-06 13:54 JST | [PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_PHASE_RUNNER.md) 新規。§9 表・メタ表・INDEX。 |
| 2026-04-06 13:49 JST | §9 に「実装 / 統合実行」表を追加。[PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md](../process/PROMPT_ADMIN_GLOBAL_OWNER_TUGILO_EXECUTION.md) 新規。メタ表・INDEX 更新。 |
| 2026-04-06 14:05 JST | §9 実装プロセス（PROMPT_ADMIN_GLOBAL_OWNER_IMPLEMENT）、メタ表・DoD・§10 と役割分担を明記。 |
| 2026-04-06 13:41 JST | §4.4 未設定時、§5.1〜5.3（dataProvider・禁止パターン・初期ロード）、§10 SSOT 改善プロセス、DoD 追記。 |
| 2026-04-06 | 初版（要件・認証後方針・関連 SSOT リンク） |
