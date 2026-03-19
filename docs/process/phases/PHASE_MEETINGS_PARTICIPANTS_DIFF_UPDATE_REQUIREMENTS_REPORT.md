# Phase M7-C4-REQUIREMENTS: participants 差分更新 要件整理 — REPORT

**Phase ID:** M7-C4-REQUIREMENTS  
**完了日:** 2026-03-19

---

## 作成したドキュメント一覧

- docs/SSOT/MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md（要件整理本体）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_PLAN.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_REPORT.md（本ファイル）

---

## 要件整理の要約

- **現状:** CSV 反映は participants を全削除してから CSV で再作成。participant_breakout は participant に cascadeOnDelete のため、BO 割当がすべて消える。
- **守りたいもの:** 既存 participant、BO 割当、introducer/attendant、手動マッチ、反映履歴。差分更新では participant を安易に削除せず、追加・更新を優先し、削除は「削除候補」として確認のうえ行う方針を整理した。
- **差分判定:** 同一人物は **member_id** で判定。CSV 行から member 解決した member_id と既存 participants の member_id を比較し、追加・更新・削除候補を算出する。
- **案比較:** 案A 全置換（現状）／案B 未掲載は残す／案C 未掲載は削除候補。案C を推奨。BO 設定済み participant は削除しないルールで BO を保護する。
- **UI/UX:** 反映前に差分プレビューを必須とし、追加・更新・削除候補を色分け表示。BO ありの削除候補には warning を出し、「BO ありは削除しない」をデフォルトとする。
- **フェーズ案:** D1 差分比較ロジック・D2 プレビュー・D3 安全な差分反映・D4 BO 保護ルール・D5 履歴・ログ強化。

---

## 推奨方針

- 案C（差分更新・未掲載は削除候補）を採用する。
- CSV にない既存 participant は即削除せず、削除候補として表示し確認のうえ削除する（または削除しないを選べる）。
- BO 設定済み participant は削除対象から外す（BO ありは削除しないをデフォルト）。
- 反映前に差分プレビューを必須とする。

---

## 次に進むなら何をやるか

- **D1（実装 Phase）:** 差分比較ロジックの設計・Service 化。CSV 行から member_id 一覧を取得し、既存 participants と比較して追加・更新・削除候補を返す API と、BO 紐づけ有無の取得。
- その後 D2（プレビュー API/UI）→ D3（安全な差分反映）→ D4（BO 保護）→ D5（履歴強化）の順で検討。

---

## Merge Evidence

（develop 取り込み後に記入。本 Phase は docs のみのため merge は任意）

phase id: M7-C4-REQUIREMENTS  
phase type: docs  
changed files: 上記 4 ファイル + INDEX + PHASE_REGISTRY + dragonfly_progress
