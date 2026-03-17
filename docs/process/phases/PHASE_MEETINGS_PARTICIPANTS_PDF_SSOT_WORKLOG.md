# Phase M7-P1-SSOT: 参加者PDF列の仕様反映 — WORKLOG

**Phase:** M7-P1-SSOT  
**作成日:** 2026-03-17

---

## 実施内容

- **FIT_AND_GAP_MEETINGS.md の修正:**
  1. §2.1 フロントエンドの一覧説明に「参加者PDF」列を追加。M7-P1-LIST で追加した旨を注記。
  2. §2.2 API の一覧返却項目に `has_participant_pdf` を追加。詳細 API に participant_import を追記。参加者PDF関連 API（import/show, store, download）を一文で記載。
  3. §2.3 を新設。「参加者PDF列・データ仕様（M7-P1-LIST）」として、一覧表示（列順・Chip 仕様）、一覧 API（boolean のみ、ファイル名は返さない）、詳細（Drawer で participant_import）を明記。
  4. §3 フィット＆ギャップ一覧に M10b「一覧：参加者PDF」を追加。モックにはなく実装拡張として Fit。
  5. §4 まとめの Fit に、一覧列（参加者PDF）と Drawer の参加者PDF登録/ダウンロードを追記。

---

## 実装との照合

- MeetingsList.jsx: 列順は番号・開催日・BO数・メモ・参加者PDF・Actions。HasParticipantPdfField で Chip あり/なし。→ SSOT と一致。
- MeetingController: index で has_participant_pdf を返却。show で participant_import。→ SSOT と一致。

---

## 結果

- SSOT に一覧表示仕様が明記され、実装と齟齬がない状態になった。
- 本 Phase は docs のみのため、テスト・ビルドは既存のまま実行して回帰なしを確認する。
