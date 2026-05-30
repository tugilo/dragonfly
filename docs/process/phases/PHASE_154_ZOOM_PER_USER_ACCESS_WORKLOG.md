# PHASE_154_ZOOM_PER_USER_ACCESS WORKLOG

## Task1 - ゲートを auth:sanctum へ
- 状態: 完了
- 判断: Zoom 連携はデータ的にユーザー単位で完結しており、admin 限定にする必然性がない。各メンバーが自分用に使えるよう、zoom グループの `religo.chapter_admin` を **`auth:sanctum`** に変更。callback は署名 state で user 解決、webhook は署名検証のため現状維持。
- 実施: `routes/api.php` の zoom グループ middleware を変更。
- 確認: `route:list` で zoom ルート維持。

## Task2 - アクセス制御テスト
- 状態: 完了
- 判断: 「未認証 401／認証済み member 200／他ユーザーの import を参照・編集不可」を担保する。
- 実施: `tests/Feature/Zoom/ZoomImportAccessTest.php` を追加（status 401/200・index スコープ・他人 import 更新 403）。
- 確認: Zoom 16 件・全体 410 passed。

## Task3 - ドキュメント
- 状態: 完了
- 実施: SPEC-012（認証/署名欄・§実装・変更履歴）と ZOOM_INTEGRATION_SETUP（権限欄・連携手順）を「認証済みユーザー単位」に更新。
