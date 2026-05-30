# PHASE_153_ZOOM_INTEGRATION_SETUP_DOC WORKLOG

## Task1 - Runbook 作成
- 状態: 完了
- 判断: 実装（Phase 152）は完了しているため、本 Phase は **コード外の運用手順**に限定。`.env` は手動編集禁止ルールに従い、bin/setup.sh と同じ `php -r` + `preg_replace`（既存キーは置換・無ければ追記）方式を手順に採用。OAuth Redirect / Webhook は HTTPS 必須のため ngrok 等のトンネルを前提に明記。APP_URL もトンネルに合わせるとコールバック後のリダイレクトが正しく戻る点を注記。要約（段階C）は Zoom プラン依存で取得不可時は手動継続にフォールバックする旨を明示。
- 実施: docs/SSOT/ZOOM_INTEGRATION_SETUP.md を新規作成（全体フロー図・Zoom アプリ作成/スコープ・トンネル・.env 設定コマンド・config:clear・連携・取得/複数選択/登録・要約・Webhook 検証・運用注意・トラブルシュート・確認コマンド）。
- 確認: 手順の各コマンドはプロジェクト標準の docker compose 実行形（`-f infra/compose/docker-compose.yml --env-file project.env`）に統一。route:list で zoom ルート 10 件が存在することを確認済み。

## Task2 - 同期
- 状態: 完了
- 実施: SPEC-012 SSOT の関連リンク、INDEX の SSOT 節、progress、PHASE_REGISTRY（153）を更新。
