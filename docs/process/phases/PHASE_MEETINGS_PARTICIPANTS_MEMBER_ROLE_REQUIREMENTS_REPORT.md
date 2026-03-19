# Phase M7-C4.5-REQUIREMENTS: participants 差分更新 + members 更新 + Role History 連携 要件整理 — REPORT

**Phase ID:** M7-C4.5-REQUIREMENTS  
**完了日:** 2026-03-19

---

## 作成したドキュメント一覧

- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md（要件整理本体）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_PLAN.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_REPORT.md（本ファイル）

---

## 要件整理の要約

- **反映対象 3 層:** (A) participants … その回の参加者、meeting ごと、BO に影響。追加・更新は CSV を正とし、削除は削除候補（BO ありは削除しない）。(B) members … 名前・かな・カテゴリー等。名前・かなは更新候補で反映可。カテゴリーは変更時 warning と確認のうえ更新。役職は member_roles で管理。(C) Role History … member_roles が正。毎週名簿からは変更候補の表示のみとし、確定は人が行う。
- **members 更新項目:** 名前・かなは差分で更新候補。カテゴリーは差分で warning と確認。役職は Role History 連動で自動更新せず候補表示。紹介者・アテンドは participant 単位で設定可。
- **カテゴリー変更:** 既存と異なる場合は warning と「カテゴリー変更候補」表示。categories マスタ照合。変更履歴は第一歩では持たない。
- **役割 / Role History:** 現在役職は member_roles から導出。毎週の自動更新は行わない。役割変更は「候補表示 → 人が確定」とし、同じ役職継続では履歴を増やさない。
- **差分更新との関係:** participants は必須で同一反映。members 基本情報は同一反映で更新候補を適用。Role History は別ステップ推奨、第一歩は候補表示のみ。
- **フェーズ案:** M1 participants 差分更新 → M2 members 基本情報 → M3 カテゴリー変更候補プレビュー → M4 Role History 差分検知 → M5 Role History 確定フロー → M6 ログ・監査。

---

## 推奨方針

- まずは participants 差分更新のみ実装（M1）。members は名前・かな・カテゴリーを更新候補として出し（M2, M3）、確認のうえ反映。Role History は自動更新せず変更候補の表示のみに留め（M4）、確定反映は M5 または別 Phase。

---

## 次に進むなら何をやるか

- **M1（実装）:** participants 差分更新（M7-C4 の D1〜D4 に相当）。差分比較・プレビュー・安全な反映・BO 保護。
- その後 M2（members 更新候補の表示と反映）→ M3（カテゴリー変更候補の強化）→ M4（役割変更候補の表示）→ M5（Role History 確定フロー）の順で検討。

---

## Merge Evidence

（develop 取り込み後に記入。本 Phase は docs のみのため merge は任意）

phase id: M7-C4.5-REQUIREMENTS  
phase type: docs  
changed files: 上記 4 ファイル + INDEX + PHASE_REGISTRY + dragonfly_progress
