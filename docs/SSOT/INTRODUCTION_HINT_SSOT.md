# Introduction Hint（紹介発想）SSOT

**Phase:** C-8  
**前提:** [RELATIONSHIP_SCORE_SSOT.md](RELATIONSHIP_SCORE_SSOT.md)（C-7）のスコアを条件に利用する。  
**実装:** `www/resources/js/admin/pages/DragonFlyBoard.jsx`（Connections 右ペイン）

---

## 1. 目的

**メンバー同士の紹介可能性を可視化**する UI 知性として **Introduction Hint（紹介発想）** を追加する。**UI 計算のみ**。新 API・Backend 変更は禁止。

---

## 2. 紹介候補のロジック

owner を中心に、**接触のあるメンバー同士**のうち、次の**すべて**を満たすペア (A, B) を紹介候補とする。

| 条件 | 内容 |
|------|------|
| 条件1 | same_room_count >= 3（接触がある） |
| 条件2 | category が異なる（同業は紹介対象外） |
| 条件3 | relationship score >= 2（C-7 の関係温度を利用） |
| 条件4 | want_1on1 === false（既に深い関係は除外） |

※ ペア抽出は「ログイン中の owner を中心に、owner が接触のあるメンバー同士のうち、異業種・score>=2・want_1on1 false の組み合わせ」とする。最大 3 件。優先度は SSOT で定義（例: score 合計・同室回数）。

---

## 3. 表示ルール

- **最大 3 件**
- 形式: **業種（名前） → 業種（名前）**
- 理由（任意）: 例「施工現場で接点あり」

---

## 4. UI 配置

**Connections 右ペイン**の並び順:

- Relationship Score
- **Introduction Hint**（C-8 で追加）
- Relationship Log

---

## 5. 利用データ

- **members**（メンバー一覧・カテゴリ含む）
- **ContactSummary**（複数 contact 分は既存取得を利用。C-8 では全メンバー分の summary は既存の members with summary_lite または都度取得しない方針で、**右ペインで選択中の 1 件の summary のみ**でなく、一覧で持っている summary_lite を利用する）
- **C-7 の calculateRelationshipScore**

※ 実装では、members に `with_summary=1` で取得した `summary_lite`（same_room_count 等）を利用し、紹介候補ペアを**クライアント側**で算出する。全員分の詳細 summary を追加 fetch しない（二重 fetch 禁止）。

---

## 6. 非目的（禁止）

- 新 API・DB・Backend・Service 変更
- 既存 fetch の二重化

---

## 7. 関連

- [RELATIONSHIP_SCORE_SSOT.md](RELATIONSHIP_SCORE_SSOT.md) — 条件3 で score >= 2 を使用。
- [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) — Connections に Introduction Hint を Fit で追記。
