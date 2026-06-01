# Zoom 取り込みと既存DBの重複解消 — 要件整理（ドラフト）

**関連 SSOT:** [ZOOM_ONETOONE_SYNC_REQUIREMENTS.md](ZOOM_ONETOONE_SYNC_REQUIREMENTS.md)（SPEC-012）、[ZOOM_IMPORT_MEMBER_RESOLUTION_FIT_AND_GAP.md](ZOOM_IMPORT_MEMBER_RESOLUTION_FIT_AND_GAP.md)、[MEMBERS_DEDUPLICATION_RUNBOOK.md](MEMBERS_DEDUPLICATION_RUNBOOK.md)（SPEC-008）、[ONETOONES_DELETE_REQUIREMENTS.md](ONETOONES_DELETE_REQUIREMENTS.md)
**作成:** 2026-05-31 10:20 JST
**位置づけ:** Zoom 同期で作成した 1to1/メンバーが、**既存の手動登録レコードと重複**した問題の原因・解消方針の整理。実装前の合意用（docs のみ）。

---

## 1. 事象（実機調査・本番 religo_app）

Zoom 同期→登録後、画面の 1to1 一覧に **同じ人・同じ日時の 1to1 が2件**並ぶ、**同一人物が別メンバーで2件**ある、という重複が発生。

| 指標 | 値 |
|------|----|
| `one_to_ones` 合計 | 60（`external_source`：**zoom 29 / manual 31**） |
| **同一 owner+target+同日**の重複グループ | **8 組**（各 manual×zoom の2件） |
| `members` 合計 | 148。うち **同一人物が別IDで重複**（例: 御手洗） |

### 1.1 重複の2類型

**(A) 1to1 セッションの重複（8組）** — 同じ相手・同じ日に **手動登録(manual)** と **Zoom由来(zoom)** が並存。
- 例: `owner37×target9×05-21` = [id28 manual] + [id51 zoom]、`×target119×05-18` = [id25 manual]+[id56 zoom] 等。

**(B) メンバーの重複（同一人物が別ID）** — Zoom 取り込みの「新規メンバー作成」で、**既存メンバーと表記が違う**ため別人として作成された。
- 例: **御手洗** → 既存 `id124 御手洗氏（名 TODO）(visitor)` と Zoom 新規 `id141 御手洗宏樹 (guest)` の **2件**（各々に 1to1 が1件ずつ）。
- 同様に仮登録名 `飯塚氏（名 TODO）(id97)`・`下辻氏（名 TODO）(id121)` 等が、正式名で再作成されると重複化するリスク。

---

## 2. 原因

| 類型 | 原因 |
|------|------|
| (A) セッション重複 | 取り込み確定（`ZoomImportApplyService`）の重複判定が **`zoom_meeting_uuid` / `zoom_meeting_id` の一致のみ**。既存の **手動 1to1 は zoom_* を持たない**ため「別物」と見なされ、新規作成された。 |
| (B) メンバー重複 | 相手マッチ・新規作成の同名判定が **氏名の完全一致のみ**。`御手洗氏（名 TODO）` と `御手洗宏樹` のような **表記ゆれ・仮登録名**を同一人物と検知できず、新規メンバーを作成した。 |

---

## 3. 目的（To-Be）

1. **取り込み時に既存と重複させない**（手動・Zoom を問わず同一セッション/同一人物を検知）。
2. **発生済みの重複を安全に解消**（メンバー名寄せ・重複 1to1 の整理）。
3. **記録の価値を失わない**（議事録 notes を持つ手動側を温存し、Zoom の実時刻を活かす）。

---

## 4. 要件

### 4.1 取り込み時の重複防止（再発防止）
| # | 要件 | 区分 |
|---|------|------|
| R1 | apply 時、`zoom_*` 一致に加え **「同一 owner＋target＋日時近接（同日 or ±N時間）」の既存 1to1** を重複候補として検知する | Must |
| R2 | 既存が見つかったら **新規作成せず、既存にひも付け**（既存 manual 行へ `zoom_meeting_id/uuid` をバックフィル、必要なら `started_at/ended_at` を Zoom 実時刻で補完） | Must |
| R3 | 取り込み一覧で **「既存に一致（重複）」を表示**し、ユーザーが「既存に統合 / それでも新規」を選べる | Should |
| R4 | 相手マッチ・新規作成で **表記ゆれ・仮登録名（「○○氏（名 TODO）」等）を含むあいまい一致候補**を提示し、既存メンバーへ寄せやすくする（M8 suggestions の考え方流用） | Must |
| R5 | 新規メンバー作成前の重複ガードを **完全一致＋姓一致＋かな一致＋仮登録名パターン**に拡張 | Should |

### 4.2 既存重複のクリーンアップ（後始末）
| # | 要件 | 区分 |
|---|------|------|
| R6 | **メンバー重複の統合**（SPEC-008 `MemberMergeService`）: 御手洗 `id141→id124` 等、canonical に寄せて FK（one_to_ones 等）を付け替え | Must |
| R7 | **重複 1to1 の整理**: 同一セッションの2件は **手動(notes 有)を残し、Zoom 重複側を無効化**（`status=canceled` か DB 削除）。Zoom 側の実時刻は手動側へ移植可 | Must |
| R8 | クリーンアップは **プレビュー→確認→実行**（不可逆操作のため証跡を残す） | Must |

### 4.3 非目標
- 全自動マージ（誤統合リスク。人の確認を挟む）。
- ONETOONES の UI 物理削除導線の新設（[ONETOONES_DELETE_REQUIREMENTS.md](ONETOONES_DELETE_REQUIREMENTS.md) 方針は維持。整理は canceled か DB 運用）。

---

## 5. 重複判定キー（設計）

- **1to1 セッション同一性:** `owner_member_id` 一致 ＋ `target_member_id` 一致（または同一人物に名寄せ後）＋ `COALESCE(started_at, scheduled_at)` の **同日（推奨）/ ±数時間**。
- **メンバー同一性:** 完全一致 → かな一致 → 姓一致＋（業種/チャプター近接）→ 仮登録名（`%（名 TODO）` 等）と実名の照合。**最終判断は人**。
- バックフィル: 一致した既存 1to1 に `zoom_meeting_id/uuid`・`external_source` 据置（manual のまま or `zoom+manual` 区別は実装 Phase で決定）。

---

## 6. 対応案

### 6.1 再発防止（取り込み側）
| 案 | 内容 | 評価 |
|----|------|------|
| **A（推奨）** | `ZoomImportApplyService` に **owner+target+同日**の既存検知を追加。既存があれば作成せず `imported`＋既存に紐付け＋zoom_* バックフィル。一覧に「既存と重複」表示（R3） | 再発を根本で止める |
| B | 取り込み前プレビューで重複だけ警告（作成は止めない） | 弱い（人依存） |

### 6.2 既存クリーンアップ（1回限り）
| 案 | 内容 | 評価 |
|----|------|------|
| **A（推奨）** | (1) メンバー重複を `MemberMergeService` で統合（御手洗等）→ (2) 同一セッション化した 1to1 のうち **Zoom 重複側を canceled/削除**、notes は手動側へ集約。**プレビュー付きスクリプト or 管理UI** | 安全・証跡あり |
| B | 手動で 1件ずつ修正 | 件数少なめ（8組＋数名）なら可だが再現性低い |

---

## 7. 推奨スコープ（フェーズ案）

- **Phase X1（再発防止・implement）:** R1/R2（apply の owner+target+同日 重複検知＋バックフィル）＋R4（あいまい候補提示）。テスト必須。
- **Phase X2（クリーンアップ・implement or 運用）:** R6 メンバー統合＋R7 重複 1to1 整理（プレビュー→実行）。本番データ対象のため **バックアップ＆証跡**。
- R3/R5 は UI 余力で追従。

---

## 8. リスク・確認事項

| 項目 | 内容 |
|------|------|
| 誤統合 | 別人を同一視すると関係データが壊れる。人の確認必須・プレビュー。 |
| notes 消失 | クリーンアップで手動側 notes を必ず残す（Zoom 側を消す）。 |
| 実時刻 | Zoom の started/ended を手動側へ移植するか（推奨）。 |
| 物理削除 | ONETOONES 方針上 UI 物理削除は不採用。canceled か DB 運用で。 |
| バックフィル方針 | 既存 manual に zoom_* を入れた場合 `external_source` をどう扱うか（manual 維持を推奨）。 |

## 9. Open Questions

1. セッション同一の時間窓は **同日**でよいか（±数時間にするか）。
2. 重複 1to1 の無効化は **`canceled`** と **DB 物理削除** のどちら（notes は手動側に集約前提）。
3. クリーンアップは **管理UI** で行うか、**1回限りの Artisan スクリプト**（プレビュー付き）で行うか。
4. メンバー名寄せの自動候補の強さ（姓一致まで出すか・誤検知許容度）。

---

## 10. 実装状況

| 要件 | 状態 |
|------|------|
| R1/R2 取り込み時の同日重複検知＋バックフィル | **実装済み（Phase 159）**。`ZoomImportApplyService` が apply 時に「owner+target+同日」の既存（手動含む）を検知し、新規作成せず Zoom 実時刻・`zoom_meeting_uuid` を既存へバックフィルして紐付け（既存 notes は保持）。テスト `test_same_owner_target_same_day_links_existing_and_backfills`。 |
| クリーンアップ（既存重複の解消） | **実施済み（運用・2026-06-01）**。本番 backup 後、御手洗 141→124・権堂 142→123 統合、セッション重複11組を manual 残し・zoom バックフィル・zoom 削除。本番 one_to_ones 60→49 / members 148→146・重複0。 |
| R4/R5 メンバーあいまい一致 | 未実装（次段）。 |
| 同名メンバー重複（久米・森園・渡邉・米澤の4組） | 未対応（Zoom 無関係・participants 突合が必要・別ステップ）。 |

## 11. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-05-31 10:20 JST | 初版。実機調査（セッション重複8組・メンバー重複〔御手洗等〕）と原因（zoom_* 一致のみ・氏名完全一致のみ）、再発防止/クリーンアップ要件・対応案・Open Questions を整理。 |
| 2026-06-01 13:45 JST | クリーンアップ実施（本番）＋ R1/R2 実装（apply の同日重複検知・バックフィル・Phase 159）。Open Questions 確定: 時間窓=同日／重複は物理削除／クリーンアップは Artisan/tinker 運用。 |
