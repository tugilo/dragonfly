# Phase 126 WORKLOG: SPEC-010 ログインと Owner 紐づけ

## 判断と実装方針（docs）

1. **SPEC-010 を active にした理由**  
   前ターンで `AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md` の章立て（目的・データ・Authorization・UI・移行・DoD）を揃え済み。実装 Phase に入る前の「要件の正」として Registry で **active** にし、以降の変更は **改訂履歴 + 新 Phase** で追う方針とした。

2. **DATA_MODEL への最小追記**  
   `owner` の定義（§1.2）は既存の正とし、**認証後のユーザー↔Owner バインドとサーバ検証**は SPEC-010 に委譲する旨を 1 行だけ足し、ドリフトを防ぐ。

3. **SPEC-003 との役割分担**  
   SPEC-003 は「無認証〜ヘッダー Owner」の UI/初期ロード・禁止パターン。SPEC-010 は「認証後の actor・`owner_member_id` 整合・代理操作の例外枠」。§6 は SPEC-010 へ誘導済み（前ターン）；本 Phase では Registry / active 化で **実装時の参照順**を明確にした。

4. **実装しないこと**  
   認証ライブラリ選定・ルート変更は別 **implement** Phase。本 Phase はドキュメントと Registry のみ。
