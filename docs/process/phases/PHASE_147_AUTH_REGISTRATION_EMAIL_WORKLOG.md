# Phase 147 WORKLOG: SPEC-011 初回登録 — 確認コードメール送信

## 2026-05-28 21:53 JST — 要件の切り口

- **判断:** 新 Spec を **SPEC-011** とし、SPEC-010（ログイン・Owner 全体）から **メール送信部分だけ分離**。010 は認証モデル・Owner  binding の SSOT のまま、011 は「初回 register/request の配送手段」に限定。
- **理由:** 010 §8 は provisioning **案の列挙**レベル。本番メール implement には送信失敗・debug_code 抑止・Mailable 設計など詳細が必要で、010 に全部足すと読みにくくなる。

## 2026-05-28 21:53 JST — 送信失敗時の HTTP

- **判断:** メール送信失敗時は **200 で成功を返さない**。Cache を `forget` して **5xx**（500 または 503）。
- **理由:** 200 のままだとユーザーはコード入力画面に進むがコードを受け取れず詰む。列挙攻撃対策（member 不在時 200）は維持し、**送信を約束したケース（member 特定済み）のみ**エラーを返す。

## 2026-05-28 21:53 JST — キュー

- **判断:** 初版は **`QUEUE_CONNECTION=sync`** の同期送信でよい。queue Worker は Out of scope。
- **理由:** 登録リクエスト頻度は低く、DragonFly 規模では sync で足りる。SMTP 遅延が問題化したら別 Phase。

## 2026-05-28 21:53 JST — debug_code

- **判断:** 本番は `RELIGO_REGISTRATION_EXPOSE_DEBUG_CODE=false` **必須**（現行 config のまま）。ローカルは `APP_DEBUG` 連動で debug 可。
- **理由:** 実装済みフラグを活かし、メール実装後もローカル UX を維持。

## 2026-05-28 21:53 JST — ドキュメント配置

- **判断:** 要件 SSOT を `docs/SSOT/AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md` に配置。Phase 記録は `PHASE_147_*`。
- **理由:** 他 AUTH_* SSOT と同階層。Registry は `02_specifications/SSOT_REGISTRY.md` 経由で参照。
