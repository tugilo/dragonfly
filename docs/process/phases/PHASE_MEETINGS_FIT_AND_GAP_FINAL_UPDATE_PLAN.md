# Phase Meetings FIT&GAP Final Update — PLAN

**Phase:** Meetings FIT&GAP Final Update（docs）  
**作成日:** 2026-03-17  
**Related SSOT:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)、[FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md)、M1〜M6 各 REPORT

---

## 1. 背景

- M1〜M6 により Meetings 画面の一覧改善・行アクション・詳細 Drawer・例会メモ Dialog・ツールバー・統計カードが実装完了している。
- FIT_AND_GAP_MEETINGS.md の §2.2（API）・§3（Fit/Gap 一覧）・§4（まとめ）は一部のみ更新されており、§3 の表で M02/M06/M09/M10/M11/M12/M13/M14/M15 がまだ Gap のままになっている。§4 の「推奨」も古い優先度のまま。
- FIT_AND_GAP_MOCK_VS_UI.md の §5 Meetings と §11 まとめは「一覧のみ」「詳細パネル未実装」等の古い記述のまま。実装完了状態を SSOT に正しく反映する必要がある。

---

## 2. 目的

- M1〜M6 の実装完了状態を FIT_AND_GAP 系ドキュメントに正確に反映する。
- 「主要 Gap は概ね解消済み」「細かな表現差・レイアウト差は残る」ことを明確に記述する。
- INDEX と PHASE_REGISTRY の整合を確認し、本 Phase を登録する。

---

## 3. スコープ

- **変更可能:** docs/SSOT/FIT_AND_GAP_MEETINGS.md、docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md、docs/INDEX.md、docs/process/PHASE_REGISTRY.md、docs/process/phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_*.md
- **変更しない:** 実装コード、M1〜M6 の既存 PLAN/WORKLOG/REPORT の本文、MOCK_UI_VERIFICATION.md の構造（参照整合のみ）

---

## 4. 更新対象ファイル

| ファイル | 更新内容 |
|----------|----------|
| docs/SSOT/FIT_AND_GAP_MEETINGS.md | §2.2 API を一覧/詳細/メモ/stats・フィルタに合わせて記述。§3 の M01〜M15 を再評価。§4 まとめを「主要機能実装済み・残りは表現差」に書き換え。 |
| docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md | §5 Meetings の表を現状に合わせて更新。§11 まとめの Meetings 記述を「M1〜M6 実装済み」に更新。 |
| docs/INDEX.md | PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE の 3 ファイルを一覧に追加（必要なら）。 |
| docs/process/PHASE_REGISTRY.md | 本 Phase（Meetings FIT&GAP Final Update, docs）を追加。 |

---

## 5. 更新方針

### 5.1 FIT_AND_GAP_MEETINGS.md

- **§2.2:** 一覧 API の返却項目（id, number, held_on, breakout_count, has_memo）とクエリ（q, has_memo）。詳細 GET /meetings/{id}、メモ GET/PUT /meetings/{id}/memo、統計 GET /meetings/stats を列挙。
- **§3:** M01 Fit、M02 Fit（M1 でサブ説明追加済み）、M03 Fit、M04 Fit、M05 は **Partial Fit** または **Gap（説明付き）**：モックは two-col 固定、実装は Drawer で詳細表示。機能面では「行選択で詳細を見る」は充足。見た目は右固定パネルではないため Partial Fit とし、注記で「Drawer で同等機能」と明記。M06 Fit、M07/M08/M09/M10 Fit、M11 は「解消済み（名前列削除）」で Fit 相当に。M12/M13 Fit。M14 は「Drawer で詳細表示。右パネル固定ではないが機能は充足」として **Fit（Drawer 採用）** または **Partial Fit** とし、注記で説明。M15 Fit。
- **§4:** Fit は現状の揃っている点を列挙。Gap は「解消済み」ではなく「残差分」に変更し、副表示（今年度・平均・割合）・レイアウト差（two-col  vs Drawer）・統計の副数値のみ。推奨を「次の改善候補」に縮小し、実運用に耐える状態に到達した旨を記載。

### 5.2 FIT_AND_GAP_MOCK_VS_UI.md

- **§5:** 表の実装列を「タイトル＋サブ説明」「統計カード 4 種」「ツールバー（検索・メモ・件数）」「一覧：番号・日付・BO数・メモ・Actions」「行クリックで Drawer／詳細」「例会メモモーダル」に更新。Fit/Gap を FIT_AND_GAP_MEETINGS の評価に合わせる。レイアウト（two-col vs Drawer）は Partial Fit または説明付きで記載。
- **§11:** 「Meetings: 一覧のみで…未実装」を「Meetings: M1〜M6 で一覧・統計・ツールバー・Drawer・例会メモモーダルを実装済み。詳細は FIT_AND_GAP_MEETINGS 参照。レイアウトは two-col ではなく Drawer 採用。」に変更。

### 5.3 M05 / M13 / M14 の扱い

- **M05 レイアウト:** モックは two-col 固定。実装は 1 カラム＋行クリックで Drawer。**Partial Fit** とし、「詳細は Drawer で表示。two-col 固定ではないが、行選択で例会詳細を確認する機能は充足。」と注記。
- **M13 行クリック:** 実装は行クリックで Drawer を開く。**Fit**（行クリックで詳細導線は実装済み。表示は右パネルではなく Drawer）。
- **M14 右パネル/詳細:** モックは右固定パネル。実装は Drawer で同内容（番号・日付・BO数・メモ・本文・BO割当・メモ編集/Connectionsへ）を表示。**Fit（Drawer 採用）** とし、「表示は右パネル固定ではなく Drawer。機能面では同等。」と注記可能。

---

## 6. 確認観点

- M1〜M6 の各 REPORT に記載の実装内容と矛盾しないこと。
- 実装していないもの（今年度回数・平均/例会・割合など）を Fit にしないこと。
- FIT_AND_GAP_MEETINGS と FIT_AND_GAP_MOCK_VS_UI の Meetings 記述が一致すること。
- INDEX に本 Phase の 3 ファイルが含まれること。PHASE_REGISTRY に本 Phase が追加されていること。

---

## 7. DoD

- [x] FIT_AND_GAP_MEETINGS.md の §2.2・§3・§4 が M1〜M6 完了状態に更新されていること。
- [x] FIT_AND_GAP_MOCK_VS_UI.md の §5・§11 の Meetings 記述が更新されていること。
- [x] INDEX.md と PHASE_REGISTRY.md の整合が取れ、本 Phase が登録されていること。
- [x] PLAN / WORKLOG / REPORT が揃っていること。
- [x] 既存ドキュメントの他セクションを壊していないこと。
