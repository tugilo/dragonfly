# Relationship Score（関係温度）SSOT

**Phase:** C-7  
**前提:** [CONNECTIONS_INTELLIGENCE_SSOT.md](CONNECTIONS_INTELLIGENCE_SSOT.md)（C-6）を崩さない。  
**実装:** `www/resources/js/admin/pages/DragonFlyBoard.jsx`（Connections 右ペイン）

---

## 1. 目的

メンバーとの**関係の深さを直感的に把握**する UI 知性として **Relationship Score（関係温度）** を追加する。**UI 計算のみ**。新規 API・Backend 変更は禁止。

---

## 2. データソース

**ContactSummary** の既存データのみ使用。

- same_room_count
- last_same_room_meeting
- interested
- want_1on1
- latest_memos（API が latest_memos のキーで返す）

---

## 3. 計算ルール（最大 5）

| 条件 | 加算 |
|------|------|
| same_room_count >= 10 | +2 |
| same_room_count >= 5 | +1 |
| recent memo あり（latest_memos 長さ > 0） | +1 |
| interested === true | +1 |
| want_1on1 === true | +1 |

合計を 0〜5 にクリップする。

---

## 4. 表示ルール

| スコア | 表示 |
|--------|------|
| 5 | ★★★★★ |
| 4 | ★★★★☆ |
| 3 | ★★★☆☆ |
| 2 | ★★☆☆☆ |
| 1 | ★☆☆☆☆ |
| 0 | ☆☆☆☆☆ |

---

## 5. UI 配置

**Connections 右ペイン**で、**🧠 Relationship Summary の下**にブロックを追加。

- 見出し: **Relationship Score**
- 表示: ★ 0〜5（上記表示ルール）

---

## 6. 非目的（禁止）

- 新 API・DB 変更・Backend 変更・Service 変更
- 既存 summary 取得の二重 fetch

---

## 7. 関連

- [CONNECTIONS_INTELLIGENCE_SSOT.md](CONNECTIONS_INTELLIGENCE_SSOT.md) — Summary ブロックの上に C-7 ブロックを追加。
- [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) — Connections に Relationship Score を Fit で追記。
