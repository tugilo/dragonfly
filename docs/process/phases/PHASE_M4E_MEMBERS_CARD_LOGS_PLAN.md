# Phase M4E Members Card 関係ログ表示 — PLAN

**Phase:** M4E  
**作成日:** 2026-03-10  
**SSOT:** [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1, §4.2 M17

---

## Phase

M4E — Members Card 表示時の「関係ログ（最近）」を既存 API で表示する。

---

## Purpose

- Members ページの **Card 表示** で、各カードの mc-logs に「関係ログ（最近）」を実データで表示する。
- FIT_AND_GAP §4.2 M17 の GAP「一覧に関係ログ（最近）なし」を、Card 表示に限定して解消する。List 表示は対象外。
- 既存 API は変更しない。既存の contact-memos API を呼び出して取得するのみ。

---

## Background

- M4D で List/Card 切替を実装し、Card 表示時は MemberCard の mc-logs に「— 詳細で確認」のプレースホルダのみ表示している（一覧 API に関係ログが含まれないため）。
- モック（§4.1）では .mc-logs に「関係ログ（最近）」＋複数 .log-i（種別・日付・テキスト）を表示している。
- 既存の `GET /api/contact-memos?owner_member_id=&target_member_id=&limit=N` でメモ履歴は取得可能。1to1 は `GET /api/one-to-ones?owner_member_id=&target_member_id=` で取得可能。これらを Card 表示時に利用する。

---

## Related SSOT

- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.1（.mcard 内 .mc-logs の表示内容）、§4.2 M17（関係ログの GAP）

---

## Scope

- **変更可能:** www/resources/js/admin/pages/MembersList.jsx の MemberCard / MembersCardGrid まわり、および関係ログ取得ロジック（既存 API 呼び出しのみ）。
- **変更しない:** API（バックエンド）、List 表示（Datagrid）、他ページ、FIT_AND_GAP の文言更新は REPORT 時のみ。

---

## Target Files

- www/resources/js/admin/pages/MembersList.jsx

---

## Implementation Strategy

1. **データ取得:** Card 表示で各 MemberCard に渡す record に対し、**MembersList.jsx で既存のメモ・1to1関連処理に使用している値（owner_member_id）を流用**して contact-memos を取得する。新しい state や認証取得処理は追加しない。取得は MemberCard 内で useEffect で行う（既存 API は変更しないため、Card ごとに GET contact-memos を呼ぶ形とする）。
2. **表示内容:** mc-logs 内に「関係ログ（最近）」見出しの下に、直近の contact-memos（最大 3 件）を種別（memo_type）・日付・本文抜粋で表示する。モックの .log-i に相当。**1to1 履歴の統合表示は今回の Phase では行わず、次 Phase の検討事項とする。**
3. **フォールバック:** 取得中は「読込中…」、0 件の場合は「—」または「詳細で確認」を表示する。
4. **既存 API のみ使用:** GET /api/contact-memos の既存パラメータ・レスポンス形式を変更しない。

## Tasks

- [ ] Task1: MemberCard で関係ログ用データ取得（contact-memos を target_member_id で取得、limit=3。owner_member_id は MembersList.jsx 既存の値を流用）
- [ ] Task2: mc-logs に .log-i 相当の表示（種別・日付・本文抜粋）を実装
- [ ] Task3: 読込中・0 件時の表示を整える

（1to1 履歴の mc-logs 統合表示は次 Phase の検討事項とする。）

---

## DoD

- Card 表示時、各 MemberCard の「関係ログ（最近）」に、既存 contact-memos API で取得した直近のメモが最大 3 件表示されること。
- 既存 API の仕様・パラメータ・レスポンスは変更していないこと。
- List 表示・Datagrid は変更しないこと。
- 既存の php artisan test およびフロントビルドが通ること。

---

## 参照

- モック .mc-logs / .log-i: www/public/mock/religo-admin-mock-v2.html
- 既存 contact-memos 利用箇所: MembersList.jsx 内 MemberDetailDrawer の refetchMemos（GET /api/contact-memos）
