# Phase 322 PLAN — Zoom 取込の相手照合で、入会後のメンバー行を優先する

**作成:** 2026-11-05 17:58 JST  
**Phase Type:** implement（Service・テスト・SSOT 追記）  
**Branch:** `feature/phase322-zoom-member-match`（develop から作成。現在の作業ツリーに Phase 321 等の未コミット変更があるため、実装開始時に切る）  
**Related SSOT:** SPEC-012 `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md`（Zoom 1to1 取込）／`docs/SSOT/ZOOM_IMPORT_MEMBER_RESOLUTION_FIT_AND_GAP.md`（相手の解決）／`docs/SSOT/ZOOM_IMPORT_DEDUP_REQUIREMENTS.md`（重複防止）／SPEC-008 `MEMBERS_DEDUPLICATION_RUNBOOK.md`（members 行は履歴として残す）

---

## Purpose

Zoom 取込で 1to1 の相手を **人単位で正しい `members` 行** に紐づける。同じ人に入会前のビジター・ゲスト行と入会後のメンバー行があるとき、取込が古い行を選び、1人の 1to1 履歴が複数の id に分かれている。また、氏名の空白の違いだけで照合に失敗し、重複したゲスト行と重複 1to1 ができている。

## 背景（2026-11-05 の本番 Zoom 取込で発生）

| 事象 | 例 | 原因 |
|------|----|------|
| 入会後の面談がビジター行に紐づく | 小渕茉那虎 `#180` → visitor `#324`（member は `#412`）、大倉拓朗 `#186` → visitor `#347`（member は `#387`） | `ZoomMeetingSyncService::matchMember()` が `Member::where('name', $name)->first()`。順序指定なしで、古い行が先に返る |
| 空白違いで照合できず重複作成 | 「大和田和学」で新規ゲスト `#423` と 1to1 `#185` が作られ、既存の `#408`・`#171` と重複 | 氏名の完全一致のみ。全角・半角スペースを正規化していない |

データはローカルで手修正済み（2026-11-05 17:58 JST。`#180`・`#186`・`#146`・`#88` をメンバー行へ付け替え、`#185`・`#423` を削除）。本 Phase はコード側の再発防止。

---

## Scope

- `www/app/Services/Zoom/ZoomMeetingSyncService.php`（`matchMember()`）
- 必要なら照合用の小さなクラス／メソッドを `www/app/Services/Zoom/` に追加
- `www/tests/Feature/Zoom/`（照合のテスト追加）
- `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md`（相手照合の優先順位を追記）
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_322_zoom_member_match_prefer_member_{PLAN,WORKLOG,REPORT}.md`

対象外: 既存の重複 `members` 行の統合・削除（SPEC-008 の運用で別判断）、`ZoomImportApplyService` の重複判定（同日・同相手）ロジックの変更、UI 変更、本番 DB の手修正（ローカル修正分は db 同期で反映）。

---

## 設計（案）

| 項目 | 決定 |
|------|------|
| メール一致 | 従来どおり最優先。複数ヒット時も下の優先順位で 1 行を選ぶ |
| 氏名の正規化 | 前後の空白除去に加え、全角・半角スペースを取り除いて比較する（`REPLACE` で DB 側も同じ正規化） |
| 同名が複数あるときの優先順位 | 1) `type=member` かつ未退会（`left_at` が使える場合） 2) `type=member` 3) その他の type のうち `id` が最大（最新） |
| 曖昧なとき | 優先順位で決まらない場合（例: member が2行）は `matched` にせず、従来の `new` / 手動確認に回す（誤紐づけを避ける） |
| 既存の matched 行 | 既に `matched` で `matched_member_id` がある取込行は上書きしない（現行の挙動を維持） |

---

## DoD

- 同名のビジター行とメンバー行があるとき、取込がメンバー行に照合するテストが green。
- 「大和田和学」と「大和田　和学」のように空白だけ違う氏名が同一人物として照合されるテストが green。
- member が複数ヒットする曖昧ケースで自動紐づけしないテストが green。
- `php artisan test` 全体が green。
- SPEC-012 に照合の優先順位を追記。
- INDEX / 進捗 / PHASE_REGISTRY を同期。REPORT に Merge Evidence（merge 実施後）。

---

## Tasks

1. `feature/phase322-zoom-member-match` を develop から作成（未コミット変更の扱いをユーザーと確認してから）。
2. `matchMember()` に氏名正規化と優先順位を実装。
3. Feature テスト追加・全体テスト。
4. SPEC-012 追記。
5. WORKLOG・REPORT・INDEX・進捗・PHASE_REGISTRY。
6. develop へ merge → 1 push（ユーザー指示後）。
