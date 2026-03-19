# Phase M7-C4.5-REQUIREMENTS: participants 差分更新 + members 更新 + Role History 連携 要件整理 — PLAN

**Phase ID:** M7-C4.5-REQUIREMENTS  
**Phase 名:** participants 差分更新 + members 更新 + Role History 連携 要件整理  
**種別:** docs  
**Related SSOT:** MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md, DATA_MODEL.md

---

## 背景

- M7-C3 では CSV 反映時に participants を全削除して再作成している。M7-C4-REQUIREMENTS で participants は差分更新にすべきと整理した。
- 毎週の参加者名簿には members のカテゴリー・役職が含まれており、members マスタ更新や Role History との整合にも使える可能性がある。
- 一方、カテゴリーは変わることがあり、役割は半年に一度変わる。単純に毎週上書きすると Role History の意味を壊す可能性がある。

## 目的

毎週のミーティング参加者名簿（CSV）を、参加者反映だけでなく、members マスタの更新と Role History（役割履歴）との整合まで含めて、どう扱うかを整理する。実装は行わず、要件整理・設計たたき台に徹する。

## 調査対象

- 現状の participants / members / role history（member_roles）の構造（DATA_MODEL, Member, MemberRole, ApplyMeetingCsvImportService, ImportParticipantsCsvCommand）
- MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS, MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS
- 毎週名簿から更新したい項目（名前・かな・カテゴリー・役職）
- カテゴリー変更と役割履歴の論点
- 差分更新（participants）と members / Role History 更新の関係

## 整理観点

1. 反映対象の整理（participants / members / Role History）。何を持つか・何が変わりうるか・毎週名簿からどこまで更新してよいか。
2. members 更新項目の分類（名前・かな・カテゴリー・役職・備考・地域・紹介者・アテンド等）。
3. カテゴリー変更の扱い（上書き可否・warning・マスタ照合・変更履歴・プレビュー）。
4. 役割 / Role History の扱い（現在値の保持方法・毎週の差分で何をすべきか・半年交代のモデル化・同じ役割継続時のルール・自動更新の是非）。
5. 差分更新との関係（participants 必須、members 同時か別ステップ、Role History 別ステップ推奨）。
6. UI/UX 要件（プレビューに member 更新候補・カテゴリー変更の色分け・役割変更候補を別セクション・Role History 確認必須・第一歩は確認のみ）。
7. データ要件（members の現在役割・member_roles の insert/close ルール・category 変更履歴・ログ・rollback/audit）。
8. 実装フェーズ案（M1〜M6）。
9. 推奨方針と今後の確認事項。

## 成果物

- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md（要件整理本体）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_PLAN.md（本ファイル）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_REPORT.md

## DoD

- 上記 4 ファイルが作成されていること。
- 反映対象の 3 層（participants / members / Role History）・members 更新項目の分類・カテゴリー変更・役割/Role History・差分更新との関係・UI/UX・データ・フェーズ案・推奨方針が一通り記載されていること。
- INDEX / PHASE_REGISTRY が更新されていること。
