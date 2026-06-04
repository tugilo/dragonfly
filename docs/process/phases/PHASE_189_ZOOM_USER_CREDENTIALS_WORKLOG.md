# PHASE 189 WORKLOG — Zoom ユーザー資格情報

## 2026-06-04 08:57 JST

### 判断

- AI BYO key（`user_ai_credentials`）と同型の `user_zoom_credentials` を新設。OAuth トークン用 `zoom_accounts` とは分離（アプリ資格情報 vs 動的トークン）。
- `ZOOM_REDIRECT_URI` は Religo サーバー固定のため `.env` 維持。ユーザーは Zoom アプリ側にこの URL を登録する。
- Webhook は同一 URL を複数 Zoom アプリが指すため、署名検証時に env + 全ユーザー secret を試行。Middleware が一致 secret を `zoom_webhook_secret` attribute にセットし url_validation で使用。
- env フォールバックは移行期間用に残す（ユーザー未登録時のみ）。
