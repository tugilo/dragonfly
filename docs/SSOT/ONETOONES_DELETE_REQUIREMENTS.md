# 1 to 1（one_to_ones）削除ポリシー — SSOT

**最終更新:** 2026-06-03 22:20 JST（**Phase 184** — 理由付きキャンセル SSOT 追記）  
**ステータス:** **製品方針として確定**（DELETE 不採用・`canceled` 正規運用・**POST cancel**）  
**種別:** SSOT（実装・サポートの単一情報源）

**関連:** [DATA_MODEL.md](DATA_MODEL.md) §4.12、[FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §6、[ONETOONES_CANCEL_FIT_AND_GAP.md](ONETOONES_CANCEL_FIT_AND_GAP.md)

---

## 1. 製品方針（確定）

| 項目 | 内容 |
|------|------|
| **物理削除** | **`DELETE /api/one-to-ones/{id}` は実装しない**（UI にも削除ボタンを置かない）。不足ではなく **意図的な非採用**。 |
| **データの位置づけ** | 1 to 1 は **関係性の履歴**である。予定が無効になったことも **履歴として意味を持つ**。 |
| **無効化の手段** | **`status = canceled`** は「削除の代替」ではなく、**業務上の正規状態**として、予定の無効化を記録する。理由は **`POST /api/one-to-ones/{id}/cancel`** で **`cancel_reason` / `cancel_remark` / `canceled_at`** を付与（Phase 185 以降）。 |
| **UI 表記** | ユーザー向けは **「キャンセル」**（「削除」ボタンは置かない）。確定時に「履歴として残ります」と明示。 |
| **モックとの関係** | モック `#/one-to-ones` にも **削除導線は無い**。本方針と **矛盾しない**。 |
| **テスト・開発用の掃除** | **UI からの削除ではなく**、運用（DB 直接・Artisan 等）で行う。 |

---

## 2. `canceled` の定義（確定）

| 観点 | 内容 |
|------|------|
| **意味** | 当該 1 to 1 について **「予定が無効になった事実」** を残す。履歴を消さない。 |
| **いつ使うか** | 例会欠席・都合変更・**誤った予定の無効化**・重複の片方の手当てなど。 |
| **誤登録・重複** | **`POST cancel`** で片方を無効化（`cancel_reason=other` + 備考推奨）。**将来**、重複警告や validation は **別 Phase** で検討可能。 |
| **`planned` / `completed` / `canceled` の分担** | **planned**＝予定・準備中。**completed**＝実施済み。**canceled**＝無効化（実施には至らなかったが **記録として残る**）。 |
| **キャンセル操作の対象** | **`status=planned` のみ**。`completed` は **キャンセル Dialog の対象外**（Phase 184 合意）。 |

---

## 2.1 キャンセル理由（Phase 184 確定・Phase 185 以降 implement）

| UI ラベル | `cancel_reason` | `cancel_remark` |
|-----------|-----------------|-----------------|
| こちら都合 | `owner_convenience` | 任意 |
| 相手都合 | `target_convenience` | 任意 |
| その他 | `other` | **必須**（非空） |

- **`PATCH` で `status=canceled` に変更する経路は採用しない**（理由必須のため **`POST cancel` のみ**）。
- **`notes`** は議事・議題用のまま。キャンセル理由は **`cancel_reason` / `cancel_remark`** に分離。
- 一覧: 既定で canceled 行は非表示（`exclude_canceled`）。フィルタ表示時は **理由 Chip** を出す（Phase 186）。
- モック v2 は implement Phase **186–187** で Dialog・Chip を追加（§10.1 #9）。

合意ログ: [ONETOONES_CANCEL_FIT_AND_GAP.md](ONETOONES_CANCEL_FIT_AND_GAP.md) §10.1。

---

## 3. 現状の実装（事実）

| 対象 | 状態 |
|------|------|
| API | `GET` / `POST` / `GET/PATCH {id}` / `memos`。**DELETE なし**。**`POST {id}/cancel` は Phase 185 で追加予定**。 |
| ReactAdmin | `delete` 未実装・Resource に `delete` なし。**キャンセル Dialog は Phase 186**。 |
| 一覧 | **既定で「キャンセルを一覧から除く」**（`exclude_canceled=true` 相当）を ON。フィルタで canceled 表示時 **理由 Chip**（Phase 186）。 |
| Edit | 現状 `status` Select で `canceled` 選択可 → **Phase 186 で canceled を除外**（POST cancel のみ）。 |

---

## 4. 物理削除を採用しない理由（技術・製品）

- **`contact_memos.one_to_one_id`** は `nullOnDelete` のため、親を消すと **紐付けが外れる**（メモ本文は残る）。
- **Dashboard / Members 集計 / Activity** は `one_to_ones` 行を前提にした意味を持つ。**行を消すと履歴・集計の解釈が変わる**。
- **論理削除（`deleted_at`）** は別途スキーマ・クエリ・「キャンセル」との住み分けが必要で、**本フェーズでは見送り**。

---

## 5. 過去の検討メモ（アーカイブ）

以下は方針確定**前**の「調査・分岐」として残す。

### 5.1 製品として「削除」は必須か（歴史的論点）

| 案 | 概要 |
|----|------|
| **A. 削除しない** | `canceled` と編集のみ | **採用済み（本書 §1）** |
| B. 物理削除 API + UI | 未採用 |
| C. 論理削除 | 未採用 |

---

## 6. 参照ソース（コード）

- `www/routes/api.php` — `one-to-ones` のルート（DELETE なし）
- `www/resources/js/admin/dataProvider.js` — `one-to-ones` の `delete` 未実装
- `www/app/Services/Religo/OneToOneIndexService.php` — `exclude_canceled`（一覧既定）
- `www/database/migrations/2026_03_04_100005_add_memo_type_and_one_to_one_id_to_contact_memos_table.php` — `nullOnDelete`
