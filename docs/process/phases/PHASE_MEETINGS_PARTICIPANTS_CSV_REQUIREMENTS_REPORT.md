# Phase M7-P11-REQUIREMENTS: ChatGPT作成CSVのアップロード連携 要件整理 — REPORT

**Phase:** M7-P11-REQUIREMENTS  
**完了日:** 2026-03-17

---

## 作成したドキュメント一覧

- docs/SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md（要件整理本体）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_PLAN.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_REPORT.md（本ファイル）

---

## 要件整理の要約

- **目的:** ChatGPT 等で作成した参加者 CSV を Meeting に紐づけてアップロードし、確認のうえ members / participants に反映する方式の要件を整理した。
- **業務フロー:** 案A（即反映）・案B（確認・修正して反映）・案C（PDF と CSV 両方保持・CSV 優先）を比較し、**案B** を推奨。プレビューと簡易修正を挟み、人が「反映」で確定する形。
- **データ:** CSV は Meeting に紐づけて保存。PDF とは別テーブル（例: meeting_csv_imports）を推奨。participants は全置換。反映履歴（imported_at, applied_count）を検討。
- **CSV 仕様:** 必須列は種別・名前。任意に No, よみがな, 大カテゴリー, カテゴリー, 役職, 紹介者, アテンド, オリエン。種別はメンバー/ビジター/代理出席/ゲスト。UTF-8、ヘッダ必須、1 人 1 行。
- **既存連携:** ImportParticipantsCsvCommand のロジックを Service 化し、CLI と Web の両方から利用する共通化を推奨。members / participants / categories / roles は既存 DATA_MODEL に従う。
- **フェーズ案:** C1 アップロード保存 → C2 プレビュー → C3 反映 → C4 反映履歴・再反映ルール → C5 PDF フローとの統合整理。

---

## 推奨方針

- **第一歩:** Meeting に CSV をアップロード → プレビューで確認 → 全置換で participants に反映（案B + C1〜C3）。
- **CSV を「確定データ」に近いものとして扱う。** PDF 解析は「候補生成」に留め、運用では CSV を優先する。PDF フローは廃止せず、二つの入口として並列で用意する。
- **CLI との共通化:** パース・Member 解決・Participant 更新を Service に抽出し、CLI と Web の両方から利用する。

---

## 次に進むなら何をやるか

- **C1 実装:** Meeting に CSV をアップロードして保存する API と UI。新テーブル（meeting_csv_imports）のマイグレーション、POST エンドポイント、Drawer に「参加者CSV」ブロックとアップロード導線。
- **C2 実装:** アップロード済み CSV のパース結果を返す API とプレビュー表の UI。
- **C3 実装:** ImportParticipantsCsvCommand のロジックを Service に切り出し、Web から「反映」を呼び出す。全置換で participants を更新。
