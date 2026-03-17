# Phase M7-P1-SSOT: 参加者PDF列の仕様反映 — PLAN

**Phase:** M7-P1-SSOT（参加者PDF列の SSOT 反映）  
**Phase ID:** M7-P1-SSOT  
**作成日:** 2026-03-17  
**フェーズ種別:** docs  
**Related SSOT:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)、[MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md)

---

## 1. 背景

- M7-P1 / M7-P1-LIST で参加者PDFのアップロード・一覧表示（参加者PDF列）が実装済み。
- 設計と実装の整合のため、SSOT（FIT_AND_GAP_MEETINGS.md）に一覧表示仕様を明記する必要がある。

---

## 2. 目的

- 現在実装済みの「参加者PDF列（一覧表示）」を SSOT に反映し、設計と実装の齟齬をなくす。
- 一覧は boolean のみ、詳細は Drawer 側で確認するという方針を SSOT に固定する。

---

## 3. スコープ

- **変更対象:** docs/SSOT/FIT_AND_GAP_MEETINGS.md のみ。
- **変更しない:** 実装コード・API・他ドキュメントの記述（必要に応じて参照を追記するだけ）。

---

## 4. 変更内容

- **2.1 フロントエンド:** 一覧の列に「参加者PDF」を追記。M7-P1-LIST で追加した旨を注記。
- **2.2 API:** 一覧返却項目に `has_participant_pdf` を追記。詳細 API に participant_import を追記。参加者PDF関連 API（import/show/store/download）を一文で記載。
- **2.3 新規:** 「参加者PDF列・データ仕様（M7-P1-LIST）」として、一覧表示（Chip・列順）、一覧 API（has_participant_pdf, boolean のみ）、詳細（Drawer で participant_import）を明記。
- **§3 フィット＆ギャップ:** 一覧：参加者PDF（M10b）の行を追加。実装拡張として Fit。
- **§4 まとめ:** Fit に参加者PDF列・Drawer の参加者PDF登録/ダウンロードを追記。

---

## 5. テスト観点

- docs のみの変更のため、php artisan test は既存のままパスすることを確認。
- npm run build は変更なしのためそのままパスすることを確認。
- SSOT の記述が実装（MeetingsList.jsx の列構成・MeetingController の返却項目）と齟齬がないことを目視確認。

---

## 6. DoD（Definition of Done）

- [x] FIT_AND_GAP_MEETINGS.md に参加者PDF列の一覧表示仕様が明記されている。
- [x] 一覧は has_participant_pdf（boolean）のみ、詳細は Drawer で participant_import を確認する旨が書かれている。
- [x] 実装（一覧列・API 返却）と SSOT の記述に齟齬がない。
- [x] PLAN / WORKLOG / REPORT が揃っている。
- [x] INDEX / PHASE_REGISTRY / dragonfly_progress を更新している。
