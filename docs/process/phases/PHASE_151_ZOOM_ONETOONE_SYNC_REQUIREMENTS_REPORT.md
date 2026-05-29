# PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS REPORT

## Changed Files
- docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md（新規・SPEC-012）
- docs/02_specifications/SSOT_REGISTRY.md（SPEC-012 追加）
- docs/process/phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_PLAN.md（新規）
- docs/process/phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_WORKLOG.md（新規）
- docs/process/phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_REPORT.md（本書・新規）
- docs/process/PHASE_REGISTRY.md（Phase 151 追記）
- docs/INDEX.md（SSOT・Phase 追記）
- docs/dragonfly_progress.md（進捗追記）

## Summary
Zoom 連携による 1 to 1 の **予定起票・実績時刻反映・要約取得・相手正規化** を扱う要件 SSOT（SPEC-012）を新規作成した。ユーザー提示の 3 要件（①今後の予定→planned 起票、②実施済み要約取得、③相手未登録時の手動正規化）を機能要件 R1〜R3 に展開し、補強として実績時刻確定（R4）・1to1 判定/他ミーティング除外（R5）・重複防止（R6）・半自動フロー（R7）・Owner 連携（R8）を追加。さらに **R9（Zoom には BNI 以外の会議も含むため、取得一覧を全件表示し複数選択で登録要否を選ぶ UI）** を追加し、§8 を複数選択リスト（列定義・一括操作・確定・監査・既登録スキップ）として詳細化した。相手正規化は既存 M7/M8（CSV 取込）と SPEC-008 を流用し人の確認必須とした。カレンダー連携は当面非採用とし理由を明記。実装は段階1（読取取り込み＋登録要否 UI）→段階2（要約）→段階3（Webhook）の順を推奨。実装・DB 変更は本 Phase では行わない。

## DoD Check
- [x] 3 要件を機能要件に展開
- [x] 補強要件（時刻・判定・重複防止・半自動・Owner）を追加
- [x] R9 登録要否の複数選択 UI（全件表示・BNI 以外既定未選択・既登録スキップ）を定義
- [x] API キー等のアプリ資格情報は `.env`（`config/services.php` 経由）で管理しハードコード禁止、動的トークンは DB 暗号化保存を明記（§6）
- [x] Zoom 公式ドキュメント精査結果（要件→API/Webhook/スコープ/制約マッピング）を §6.1 に日本語整理
- [x] 相手未登録時の正規化フローを定義（M7/M8・SPEC-008 流用）
- [x] 段階・優先順位・リスク・カレンダー非採用理由を明記
- [x] SSOT_REGISTRY / PHASE_REGISTRY / INDEX / progress を同期
- [ ] Zoom プラン要件・API スコープ・要約取得可否の実検証（実装 Phase）
- [ ] DATA_MODEL §4.12 への zoom_* カラム追記（実装 Phase）

## Scope Check
OK（docs のみ。アプリコード・DB 未変更）

## SSOT Check
UPDATE REQUIRED（実装 Phase で DATA_MODEL §4.12 に `zoom_meeting_id` / `zoom_meeting_uuid` / `external_source` を追記する必要がある。本 Phase では要件記載のみ）

## Merge Evidence
merge commit id: （develop 取り込み後に追記）
source branch: feature/phase151-zoom-onetoone-sync-requirements
target branch: develop
phase id: 151
phase type: docs
related ssot: SPEC-012（および SPEC-006 / SPEC-007 / SPEC-008 参照）

test command: なし（docs フェーズ）
test result: スキップ（docsフェーズ）

changed files: 上記 Changed Files を参照

scope check: OK
ssot check: UPDATE REQUIRED（実装 Phase で DATA_MODEL 更新）
dod check: OK（要件ドキュメントとしての DoD は充足。実検証・スキーマ追記は実装 Phase）
