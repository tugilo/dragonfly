# Phase M7-P1-UX: PDF状態の視認性改善 — PLAN

**Phase:** M7-P1-UX（参加者PDF列の視認性）  
**Phase ID:** M7-P1-UX  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)

---

## 1. 背景

- M7-P1-LIST で一覧に参加者PDF列（Chip あり/なし）を追加済み。さらに一目で状態が分かるよう、軽量な UX 改善を行う。

---

## 2. 目的

- 「あり」を success（緑）、「なし」を default（グレー）で維持しつつ、ありの場合はアイコン（📄 or PictureAsPdfIcon）を追加して視認性を上げる。
- やりすぎず、他列（メモ等）と統一感を保つ。

---

## 3. スコープ

- **変更対象:** MeetingsList.jsx の HasParticipantPdfField のみ。
- **変更しない:** API、フィルタ、Drawer、他列の見た目。

---

## 4. 変更内容

- HasParticipantPdfField の「あり」Chip に `icon={<PictureAsPdfIcon sx={{ fontSize: 16 }} />}` を追加。「なし」は従来どおりラベルのみ（アイコンなし）。
- 色は既存どおり success / default のまま。

---

## 5. テスト観点

- 一覧で参加者PDF列が表示され、ありの行でアイコン付き Chip が見えること。
- 既存のフィルタ・Drawer・他機能に影響がないこと。
- php artisan test / npm run build が通ること。

---

## 6. DoD（Definition of Done）

- [x] 「あり」Chip に PDF アイコンが付いている。
- [x] 「なし」は従来どおり。他列と統一されている。
- [x] PLAN / WORKLOG / REPORT が揃っている。
- [x] テスト・ビルドが通る。
