# Connections Intelligence（関係の知性）SSOT

**Phase:** C-6  
**前提:** [CONNECTIONS_REQUIREMENTS.md](CONNECTIONS_REQUIREMENTS.md)（モック一致・UX改善）を崩さない。  
**実装:** `www/resources/js/admin/pages/DragonFlyBoard.jsx`（Connections 右ペイン）

---

## 1. 目的

Connections 右ペインに **Relationship Summary（関係の要約）** を追加し、BNI メンバーとの関係判断を速くする。**UI 知性のみ**。新規 API は追加しない。

---

## 2. 表示項目（最小セット）

| # | 項目 | データソース | 表示 |
|---|------|--------------|------|
| 1 | 同室回数 | summary.same_room_count | 数値。無い場合は — |
| 2 | 直近同室 | summary.last_same_room_meeting | #number（held_on）。無い場合は — |
| 3 | 1to1 回数 | summary.one_on_one_count / oneToOnes | 合計 count / 直近日付。無い場合は — |
| 4 | 直近メモ | summary.latest_memos | 最新 3 件（日付＋本文抜粋） |
| 5 | Next Action | ルールベース（クライアント計算） | 最大 3 件。下記ルール |

---

## 3. Next Action ルール

| Rule | 条件 | 提案 |
|------|------|------|
| A | same_room_count >= 3 かつ 1to1_count == 0 | 「1to1を提案」 |
| B | latest_memos が 0 件 | 「メモを書く」 |
| C | 1to1 に status === 'planned' が存在 | 「実施後メモを残す」 |
| D | 例会メモが直近に多い（meeting 種別メモ多） | 「紹介メモ整理」 |

表示は **💡 次の一手** 見出し＋箇条書き（最大 3 件）。各提案にショートアクション（📅 1to1登録 / ✏️ メモを書く / 👥 詳細）。

---

## 4. データソース（既存 API のみ）

- `GET /api/dragonfly/contacts/:id/summary?owner_member_id=` — 既に右ペインで取得済み。二重 fetch 禁止。
- `GET /api/one-to-ones?owner_member_id=&target_member_id=` — 既に右ペインで取得済み。同上。

---

## 5. UI 配置

- **Relationship Log** の**上**に **🧠 Relationship Summary** ブロックを追加。
- 選択メンバー名・アクションボタンの直下、関係ログより上（判断材料を先に）。

---

## 6. 非目的（禁止）

- 新規 API 追加
- 新しい状態管理基盤
- 既存 summary 取得の二重化

---

## 7. 関連

- [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) — Connections の Fit/Gap に C-6 追加分を追記する。
