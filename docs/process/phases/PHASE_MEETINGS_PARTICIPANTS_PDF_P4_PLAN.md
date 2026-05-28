# Phase M7-P4: member 照合と反映前確認の強化 — PLAN

**Phase:** M7-P4  
**Phase Type:** implement  
**作成日:** 2026-03-17

---

## 1. 背景

- M7-P3-IMPLEMENT-2 で編集済み候補を participants に全置換で反映できるようになった。
- member の扱いは「名前完全一致で検索 or 新規作成」のみで、反映前に「どの候補が既存 member に一致するか」「どれが新規作成されるか」が見えない。
- BO 割当への影響等もあり、反映前に安心して判断できるようにする必要がある。

## 2. 目的

participants 反映前に、各候補について「既存 member に一致するか」「新規作成対象か」を見えるようにし、件数集計と確認ダイアログで反映前確認を強化する。

## 3. スコープ

**今回やること**

- candidates ごとに member 照合結果（match_status, matched_member_id, matched_member_name）を取得し API で返す。
- Drawer の候補一覧・編集外表示で照合結果を表示する（既存 member / 新規作成 Chip）。
- 集計（matched_count, new_count, total_count）を API と UI で表示する。
- 「participants に反映」確認ダイアログに集計を表示し、反映前確認を強化する。
- participants 反映ロジック（M7-P3-IMPLEMENT-2）は変更せず、確認情報を増やすのみ。

**今回やらないこと**

- 名前ゆらぎの高度な類似検索
- 手動で member を選び直す UI
- introducer / attendant 設定
- 差分更新・BO 保護ロジック・OCR

## 4. 変更対象ファイル

- www/app/Services/Religo/CandidateMemberMatchService.php（新規）
- www/app/Http/Controllers/Religo/MeetingController.php（show で candidates に match 付与・集計追加）
- www/resources/js/admin/pages/MeetingsList.jsx（照合列・集計表示・確認ダイアログ強化）
- www/tests/Feature/Religo/MeetingControllerTest.php（match 情報・集計のテスト追加）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_PLAN.md（本ファイル）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_REPORT.md
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

## 5. member 照合方針

- candidate.name を trim し、`Member::where('name', $name)->first()` で完全一致検索。
- 見つかったら match_status: matched, matched_member_id, matched_member_name を付与。
- 見つからなければ match_status: new, matched_member_id: null, matched_member_name: null。
- 名前が空の候補は照合対象外とし、集計では total に含めず（apply と同様）、表示上は new として扱ってよい。

## 6. API 返却方式

- **A案採用:** GET /api/meetings/{meetingId} の participant_import に以下を追加する。
  - candidates: 各要素に match_status, matched_member_id, matched_member_name を付与。
  - matched_count, new_count, total_count（名前が空でない候補のみの件数）。

一覧 API は変更しない。

## 7. UI 表示方針

- 候補一覧（編集モードでないとき）: 列「照合」を追加。matched → success Chip「既存 member」、new → warning Chip「新規作成」。既存一致時は matched_member_name を補助表示可能。
- 解析候補ブロック上部: 「既存一致 N件 / 新規作成 N件 / 合計 N件」を表示。
- 反映確認ダイアログ: 「合計 N件」「既存 member 一致 N件」「新規作成 N件」を表示し、続けて既存の注意文言を表示。

## 8. テスト観点

- show の participant_import.candidates に match_status, matched_member_id, matched_member_name が含まれること。
- 既存 Member と名前完全一致の候補は matched になること。
- 一致しない候補は new になること。
- matched_count / new_count / total_count が正しいこと。
- parse_success でない場合や candidates が空の場合は match 情報・集計が null であること。
- apply の既存テストが通ること（回帰なし）。

## 9. DoD

- [x] candidates ごとに既存 member / 新規作成が分かる（API と UI）
- [x] 件数集計が確認できる（API と UI）
- [x] 反映前確認ダイアログに集計を表示できる
- [x] participants 反映の既存機能を壊さない
- [x] php artisan test が通る
- [x] npm run build が通る
- [x] PLAN / WORKLOG / REPORT と INDEX・REGISTRY・progress を更新している
