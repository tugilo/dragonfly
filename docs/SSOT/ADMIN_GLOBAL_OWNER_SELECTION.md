# Religo 管理画面：グローバル Owner 選択（SSOT）

| 項目 | 内容 |
|------|------|
| 状態 | draft（実装 Phase 前の要件・方針） |
| 関連 | [DATA_MODEL.md](DATA_MODEL.md)（User・Member）、[FIT_AND_GAP_MENU_HEADER.md](FIT_AND_GAP_MENU_HEADER.md)、[DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md)、[PROMPT_SSOT_IMPROVEMENT.md](../process/PROMPT_SSOT_IMPROVEMENT.md)（汎用）、[**PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md**](../process/PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md)（**本 SSOT 専用・実戦版**） |
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

---

## 5. アプリ全体の振る舞い（実装指針）

以下は **実装 Phase** でコードに落とす際の指針。本 SSOT は API 契約を変えない。

| 領域 | 指針 |
|------|------|
| **React Admin dataProvider** | `owner_member_id` 未指定時に `1` を使わない。**グローバルに解決した Owner ID**（Context または `getMe()` の結果）を使う。 |
| **DragonFly Board（Connections）** | 初期 state を `1` に固定しない。`me` または Context と同期。 |
| **Members / Member 詳細** | 定数 `OWNER_MEMBER_ID = 1` を廃止し、**同一の Owner 解決**を使う。 |
| **1 to 1 作成・一覧・モーダル** | 既に `GET /api/users/me` や一覧フィルタに寄せる修正がある場合は、**ヘッダー Context と二重定義しない**よう統一する。 |
| **フォールバック関数** | `ownerMemberIdFallback` の **`null → 1`** は廃止または非推奨とし、呼び出し側で未設定を明示処理する。 |

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

- [ ] グローバルヘッダーに Owner 選択があり、**全主要画面**で同じ選択が参照される。
- [ ] ダッシュボードに Owner 専用の重複 UI がない（または仕様どおりの単一導線のみ）。
- [ ] コードベースに **`owner_member_id` の `1` 固定・null→1 フォールバック**が残っていない（検索で確認）。
- [ ] `npm run build` / `php artisan test` 通過。
- [ ] [FIT_AND_GAP_MENU_HEADER.md](FIT_AND_GAP_MENU_HEADER.md) に差分があれば追記。

---

## 9. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-04-06 | 初版（要件・認証後方針・関連 SSOT リンク） |
