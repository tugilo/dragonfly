# ONETOONES 総括メモ（P1〜P4 完了版）

**プロダクト:** Religo（dragonfly リポジトリの管理画面）  
**対象:** 1 to 1 管理（`one-to-ones` リソース）  
**Phase:** [ONETOONES-P1](phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_REPORT.md) → [P2](phases/PHASE_ONETOONES_STATS_DISPLAY_REPORT.md) → [P3](phases/PHASE_ONETOONES_CREATE_EDIT_UX_REPORT.md) → [P4](phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_REPORT.md)

**関連 SSOT:** [DATA_MODEL.md §4.12](../SSOT/DATA_MODEL.md)（§4.12.1 リード一覧・Dashboard 右列）、[FIT_AND_GAP_MOCK_VS_UI.md §6](../SSOT/FIT_AND_GAP_MOCK_VS_UI.md)、Dashboard 全体は [DASHBOARD_FIT_AND_GAP.md §4](../SSOT/DASHBOARD_FIT_AND_GAP.md)

---

## 1. 概要

本フェーズでは、1 to 1 管理機能について **「一覧中心で使える実運用レベル」まで引き上げること** を目的として実装を進めた。

結果として、次の流れを一貫した UX として成立させた。

- 一覧で状況把握
- フィルタで絞り込み
- その場で登録
- 編集・履歴管理
- 統計で可視化

---

## 2. 到達状態（できること）

### 2.1 一覧（List）

- フィルタ（owner / target / status / 期間 / q / workspace）
- 検索・件数表示・行アクション（メモプレビュー・編集）
- 一覧からのクイック作成（Dialog）
- Owner デフォルト自動設定（`GET /api/users/me`）

→ **日常操作の中心として成立**

### 2.2 統計（Stats）

- `GET /api/one-to-ones/stats`
- **一覧と同一 filter** を適用（`OneToOneIndexService::applyIndexFilters` 共有）
- **want_1on1_on_count:** フィルタ後の **distinct target_member_id** × `dragonfly_contact_flags.want_1on1`

→ **「今どうなっているか」が一覧文脈と一致して分かる**

### 2.3 作成・編集（Create / Edit）

**クイック作成（List）**

- 最小入力で登録
- 軽量な Dialog UX

**フル作成 / 編集**

- 従来フォーム（`/one-to-ones/create`、Edit）
- 詳細編集可能

→ **軽さと柔軟性の両立**

### 2.4 メモ構造（重要）

| 層 | 役割 |
|----|------|
| **notes**（`one_to_ones`） | 当該 1 to 1 の**要約**（単一フィールド） |
| **contact_memos** | `memo_type = one_to_one`、`one_to_one_id` で紐付け、**履歴**として蓄積。Edit に一覧＋追加 UI、`GET/POST .../memos` |

→ **「要約」と「履歴」を分離**

### 2.5 `/api/users/me`

- `id`
- `owner_member_id`
- `member_id`（`owner_member_id` のエイリアス）

→ フロントの「自分前提」処理が安定

---

## 3. 設計上の重要な決定

### 3.1 filter の単一化

**`OneToOneIndexService::applyIndexFilters()`**

- index / stats 共通
- 今後の拡張の基準点

→ **ズレない設計**

### 3.2 メモの責務分離

| 種類 | 用途 |
|------|------|
| notes | 要約（最新の一行サマリ） |
| contact_memos | 履歴（時系列） |

→ 将来的な拡張（検索・分析など）に耐える構造

### 3.3 UI 戦略

- 一覧中心
- モック完全再現ではなく**実用優先**
- Dialog + フル画面の併用

→ 現場で使える UI に寄せた判断

---

## 4. Fit & Gap 総括

### Fit（達成）

| 項目 | 状態 |
|------|------|
| 一覧中心 UX | 完成 |
| フィルタ | 対応 |
| stats | filter 連動 |
| 作成 UX | クイック + フル |
| メモ | 構造分離完了 |
| `/me` | 安定 |

### Gap（残課題）

**G1: メモの活用深化**

- スレッド化、検索・タグ、AI 要約 など

**G2: stats UI の強化**

- グラフ、KPI カード、トレンド など

**G3: 導線強化**

- Members → 1 to 1 作成
- Connections → 1 to 1
- Dashboard 連携

**G4: 認証統合**

- `owner_member_id` の完全統一、RBAC / scope

---

## 5. 今後の優先順位

**高**

1. **導線強化（G3）** — 使われるかに直結 → **着手予定:** [ONETOONES-P5 PLAN](phases/PHASE_ONETOONES_P5_LEADS_PLAN.md)（Members / Dashboard）
2. **stats UI（G2）** — 見える化 → 行動につながる

**中**

3. **メモ拡張（G1）** — AI 活用の基盤

**低（後続）**

4. **認証・権限（G4）** — 本格運用フェーズで対応

---

## 6. 現在の評価

**状態:** 「作った」ではなく **「使える」** 状態

**レベル感**

- モック検証段階 → 完了
- 基本機能 → 完成
- 実運用 → 可能
- 改善フェーズ → これから

---

## 7. tugilo 的な意味

今回の P1〜P4 は単なる機能実装ではなく、  
**業務（1 to 1 管理）を「入力・可視化・蓄積」の流れとして仕組みに落とし込んだフェーズ** である。

---

## 8. 一言でまとめると

**1 to 1 を「記録」から「運用できる仕組み」に変えたフェーズ。**

---

## 9. 削除ポリシー（ONETOONES-DELETE-POLICY-P1・2026-03-23 追記）

P1〜P4 完了後、**1 to 1 を「履歴を残す前提の記録システム」として定義し直す**フェーズを実施した。

- **物理削除は採用しない**（DELETE API なし）。不足ではなく **製品方針**。
- **`canceled`** は削除の代替ではなく、**予定無効化を履歴として残す正規状態**。
- **一覧**は既定で **キャンセル行を除く**（`exclude_canceled`）。必要時にフィルタで「キャンセル」も閲覧可能。

詳細は [ONETOONES_DELETE_REQUIREMENTS.md](../SSOT/ONETOONES_DELETE_REQUIREMENTS.md)、`PHASE_ONETOONES_DELETE_POLICY_P1_PLAN.md`（process/phases）。
