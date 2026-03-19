# Phase M1: participants 差分更新（BO保護あり）— PLAN

**Phase ID:** M1（participants 差分更新）  
**Phase 名:** participants 差分更新（BO保護あり）  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md

---

## 背景

- M7-C3 では CSV 反映時に participants を meeting 単位で全削除して再作成している。
- participant_breakout は participant_id に cascadeOnDelete のため、反映のたびに BO 割当が消える。
- M7-C4-REQUIREMENTS で差分更新＋削除候補方式が推奨された。本 Phase ではさらに安全寄りに「削除は行わない」とする。

## 目的

- CSV 反映時に既存 participants を全削除しない。
- BO（participant_breakout）を壊さない。
- CSV との差分で追加・更新・未掲載を扱い、追加・更新のみ実行する（安全モード）。
- 差分件数（追加 / 更新 / 未掲載）を API と UI で返す・表示する。

## スコープ

**やること**

1. CSV 反映ロジックを全置換から差分更新に変更する。
2. 既存 participant と CSV 行を member_id ベースで突き合わせる。
3. 追加対象を新規 participant として作成する。
4. 既存 participant は type 等のみ更新し、introducer/attendant は維持する。
5. CSV にない既存 participant は削除せず残す。
6. 差分件数（added_count / updated_count / missing_count）を API で返す。
7. UI の確認文言と実行後表示を差分更新前提に変更する。

**やらないこと**

- 削除候補の実削除、差分プレビュー画面、BO あり participant の削除可否選択。
- members 基本情報更新、Role History 更新、introducer/attendant の反映、imported_by / 監査ログ強化。

## 変更対象ファイル

- www/app/Services/Religo/ApplyMeetingCsvImportService.php
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php
- www/resources/js/admin/pages/MeetingsList.jsx
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_*.md

## 差分更新方針

- **キー:** CSV 行から member を解決した member_id で既存 participants と比較。
- **追加:** CSV にあり既存にない member_id → Participant::create。
- **更新:** CSV にあり既存にもある member_id → type のみ更新。introducer_member_id / attendant_member_id は既存維持。
- **未掲載:** 既存にあり CSV にない member_id → 何もしない（削除しない）。

## BO 保護方針

- participant を削除しないため、participant_breakout は cascade で消えない。BO 割当は維持される。

## テスト観点

- CSV 反映で既存 participants が削除されないこと。
- 既存 member_id 一致の participant は type が更新されること。
- CSV にない既存 participant は残ること。
- 新規 CSV 行は participant が追加されること。
- BO 付き participant が残ること。
- applied_count / imported_at が追加+更新件数で更新されること。
- rows 0 件 / CSV 未登録 / 必須列不正は従来どおりエラーになること。

## DoD

- CSV 反映が全置換ではなく差分更新になっている。
- 既存 participant が削除されない。
- BO を壊さない。
- 追加 / 更新 / 未掲載件数が API と UI で分かる。
- php artisan test が通る。
- npm run build が通る。
