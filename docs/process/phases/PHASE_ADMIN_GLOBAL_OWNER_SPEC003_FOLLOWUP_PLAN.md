# ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP — PLAN

**Phase ID:** ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP  
**種別:** implement（SSOT 追記を含む）  
**Related SSOT:** [ADMIN_GLOBAL_OWNER_SELECTION.md](../../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md)（SPEC-003）  
**前提:** グローバル Owner の**主要実装は完了**。[ADMIN_GLOBAL_OWNER_SPEC003_DOCS](PHASE_ADMIN_GLOBAL_OWNER_SPEC003_DOCS_REPORT.md) 完了済み。

---

## 1. 背景

SPEC-003 の docs Phase で、以下が **未完了・follow-up** として切り出された。

1. **`/settings`**：`owner_member_id` 未設定時、`ReligoLayout` がメイン全体をゲートし **CustomRoutes の `/settings` も表示されない**（`app.jsx` で `ReligoSettings` は `Route path="/settings"`）。
2. **OneToOnesList**：フィルタに `owner_member_id`（NumberInput）がある一方、`dataProvider` の `one-to-ones` getList は **`assertOwnerResolved()` のみ**でフィルタの owner を参照しない（```40:57:www/resources/js/admin/dataProvider.js```）。
3. **§5.1**：SSOT の「各画面コンポーネントで `owner_member_id` をクエリに足してはならない」と、**Context 由来の ID を直 fetch に載せる**現装の言葉面のズレ。
4. **`religoOwnerMemberId.js`**：他モジュールからの import が **現状ない**（grep 根拠）。

---

## 2. 目的

- 上記 1〜4 を **仕様判断 → 実装または SSOT 追記**で収束させる。
- **グローバル単一 Owner**（SPEC-003）を崩さない。

---

## 3. スコープ

### 3.1 実装するもの（本 Phase で必ずコードまたは SSOT に落とす）

| 項目 | 内容 |
|------|------|
| **/settings 例外** | `ReligoLayout` で **`useLocation()`** により **`pathname === '/settings'` のときはゲートを適用せず** `props.children` をそのまま表示する（下記「判断」参照）。 |
| **OneToOnesList** | 一覧フィルタから **`owner_member_id` の NumberInput を削除**する。既定の owner はヘッダー Context のみと明示（ヘルパーテキストまたは非編集表示は任意）。 |
| **§5.1** | SSOT に **§5.1 補足（1 段落）**を追記し、「**独自に** owner を決めて付与禁止」「**ReligoOwnerContext / religoOwnerStore が返す同一の解決済み ID** をクエリに含めることは許容」と明文化する（下記「判断」参照）。 |
| **religoOwnerMemberId.js** | **ファイル削除**。他ファイルに import が無いことをビルド前に再確認。必要なら `fetchReligoMe` 相当は **将来** `ReligoOwnerContext` または API モジュールに集約する旨を SSOT または WORKLOG に1行記す。 |

### 3.2 判断のみドキュメント化するもの（実装は上記に含まれる）

- **§5.1 の「単一注入点」**：**SSOT 追記で足りる**。全面リファクタ（全 URL をヘルパー1本に）**は本 Phase の非スコープ**（効果に対し変更範囲が大きい）。

### 3.3 別 Phase に送るもの

- **Owner Select の検索付き**（UI/UX）。
- **dataProvider 以外の fetch をすべてラップする**専用モジュールへの移行（リファクタのみ）。
- **サーバ側**の「別 owner を指定したら 403」などの権限制御（SSOT §7 範囲外）。

---

## 4. 非スコープ

- グローバル Owner の **再設計**（複数 Owner の並行操作など）。
- `/settings` 以外のルートを**個別列挙**で例外化する（**`/settings` のみ**）。

---

## 5. 関連 SSOT

- [ADMIN_GLOBAL_OWNER_SELECTION.md](../../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md) — §5.1 補足追記、必要なら §4.4 に `/settings` の一文。
- [FIT_AND_GAP_MENU_HEADER.md](../../SSOT/FIT_AND_GAP_MENU_HEADER.md) — ReligoLayout の挙動に `/settings` 例外を追記する場合。

---

## 6. DoD

- [x] `ReligoLayout`：`/settings` で owner 未設定でも **ReligoSettings が表示**される。
- [x] OneToOnesList：`owner_member_id` フィルタ入力が**なく**、一覧は **グローバル owner のみ**とドキュメント・挙動が一致する。
- [x] `ADMIN_GLOBAL_OWNER_SELECTION.md` §5.1 に**補足段落**が入り、現行実装と矛盾しない。
- [x] `religoOwnerMemberId.js` が削除され、`npm run build` が通る。
- [x] `php artisan test` が通る。
- [x] WORKLOG・REPORT に判断理由を記載。Merge Evidence を REPORT に記載。

---

## 7. 実施手順

1. **ReligoLayout**：`useLocation` を import。`loading`/`ownerMemberId` の条件分岐の前に、`pathname === '/settings'` なら `props.children` をそのまま `Layout` に渡す分岐を追加。
2. **OneToOnesList**：`Filter` から `NumberInput source="owner_member_id"` を削除。`filterDefaults` から `owner_member_id` を除去するか、**内部既定のみ**（表示しない）に留める。
3. **SSOT**：§5.1 補足。任意で §4.4 に「設定画面は `/settings` のみ owner 未設定でも表示可」。
4. **`religoOwnerMemberId.js` 削除**と import 再 grep。
5. ビルド・テスト。WORKLOG・REPORT 更新。

---

## 8. 検証方針

- 手動：`/admin` で owner 未設定（DB で null）にしたうえで `/settings` に直接遷移し、**設定画面が表示**されること。
- 手動：1 to 1 一覧でフィルタに owner ID が**出てこない**こと。
- 自動：既存 Feature テスト。必要なら Layout 用の最小テストは**別判断**（本 Phase では必須としない）。

---

## 9. 注意点

- **ReligoSettings** が owner 未設定時に **API エラー**になる場合は、その画面内のガード・メッセージで対応（本 PLAN のスコープに含める）。
- **禁止**：一覧で「別の owner を見る」ためのフィルタを**復活**させること（SPEC-003 と矛盾）。

---

## 10. 判断ポイント整理（起票時結論）

### 10.1 `/settings`（owner 未設定時）

| パターン | 内容 |
|----------|------|
| **A** | **`pathname === '/settings'` のときだけ** `ReligoLayout` のゲートを適用しない。 |
| **B** | ゲート維持。ワークスペース・チャプター変更は **別 URL** や **ヘッダー専用モーダル**に移す（要新設）。 |

**推奨案: A**  
**理由:** `ReligoSettings` は **`default_workspace_id` 等**の設定を扱い、**owner_member_id 未設定でも**チャプター選択は業務上必要になりうる。B は新規 UI/ルート設計が要り、SPEC-003 follow-up のコストを超える。**A は変更箇所が `ReligoLayout` のみ**で、既存 `Route path="/settings"` を活かせる。

---

### 10.2 OneToOnesList の `owner_member_id` フィルタ

| 案 | 内容 |
|----|------|
| **UI 削除** | フィルタ入力をやめ、一覧は常にグローバル owner。 |
| **API 対応** | フィルタ値を `dataProvider` が `owner_member_id` クエリに反映（グローバルと異なる owner の一覧を見る）。 |

**推奨案: UI 削除**  
**理由:** SPEC-003 は **単一の「自分」**を全画面で共有する。**API 対応**は「別 owner の 1to1 を一覧表示」となり、**グローバル Owner モデルと矛盾**する（管理者向け監査用途なら別 SSOT・別 Phase）。

---

### 10.3 §5.1「単一注入点」と文言

| 案 | 内容 |
|----|------|
| **SSOT 修正** | 「クエリに載せない」を **「独自に決めた ID を載せない」**に緩和し、Context/store 由来の ID は明記。 |
| **実装修正** | 直 fetch をやめ、すべて dataProvider 経由に寄せる（大規模）。 |

**推奨案: SSOT 修正（補足追記）**  
**理由:** 現装は **すでに単一真実**（Context + store）。文言が厳しすぎて **実装を不正と誤読**しているだけ。**実装修正**は RA と非 RA の境界でコストが高く、成果は文言修正と同等の理解整合に留まる部分が大きい。

---

### 10.4 `religoOwnerMemberId.js`

| 案 | 内容 |
|----|------|
| **削除** | import が無いことを確認のうえファイル削除。 |
| **残す** | 将来の `fetchReligoMe` 用に空ファイル相当で温存。 |

**推奨案: 削除**  
**理由:** 現状 **import 0 件**（`www/resources/js` grep）。死蔵ファイルは検索ノイズ。**必要になったら** `ReligoOwnerContext` または `api/me.js` に集約すればよい。

---

## 11. 判断サマリ（表）

| 論点 | 決定 |
|------|------|
| `/settings` | **パターンA**：`/settings` のみゲート外。 |
| OneToOnesList | **UI から owner フィルタ削除**。 |
| §5.1 | **SSOT 補足**（実装の全面寄せは別 Phase）。 |
| religoOwnerMemberId.js | **削除**。 |
