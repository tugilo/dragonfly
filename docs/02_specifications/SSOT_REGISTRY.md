# SSOT Registry

このプロジェクトのSingle Source of Truth一覧。
AIは仕様を参照する際、必ずこの一覧を起点とする。

| Spec ID | Spec Name | File | Status |
|---|---|---|---|
| SPEC-001 | Religo システム全体仕様 | system_requirements.md | draft |
| SPEC-002 | 接触ロジック整合（last_contact・999・1to1 completed） | ../SSOT/CONTACT_LOGIC_ALIGNMENT.md | active |
| SPEC-003 | 管理画面グローバル Owner 選択 | ../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md | implemented（主要コード）／記録: Phase ADMIN_GLOBAL_OWNER_SPEC003_DOCS |
| SPEC-004 | Dashboard ウィークリープレゼン原稿表示 | ../SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md | implemented（主要コード）／記録: Phase DASHBOARD-WEEKLY-P1 / Phase 119 |
| SPEC-005 | Dashboard 次の1to1候補のカテゴリ表示 | ../SSOT/DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md | implemented（主要コード） |
| SPEC-006 | 1 to 1 とチャプター外（他チャプター BNI メンバー）— 解釈A・階層・API/UI | ../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md | implemented（主要コード）／記録: Phase ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1 |
| SPEC-007 | ビジター・ゲスト入会、代理出席、Connections と participants の業務・データ方針 | ../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md | active |
| SPEC-008 | members 重複の発生条件・影響・マージ運用（Runbook・案 A/B/C） | ../SSOT/MEMBERS_DEDUPLICATION_RUNBOOK.md | active |
| SPEC-009 | リファーラル記録（外部・内部／TYFCB 相当） | ../SSOT/REFERRAL_RECORDING_REQUIREMENTS.md | active／記録: Phase 122 |
| SPEC-010 | ユーザーログインと Owner（オーナー）紐づけ | ../SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md | active／記録: Phase 126 |
| SPEC-011 | 初回アカウント登録 — 確認コードメール送信 | ../SSOT/AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md | active／記録: Phase 147 |
| SPEC-012 | Zoom 連携による 1 to 1 予定・実施・要約取り込み | ../SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md | active（主要コード・Phase A〜D 実装）／記録: Phase 151（要件）・Phase 152（実装）・154（ユーザー単位） |
| SPEC-013 | 1 to 1 事前準備（NCAS/PDF 添付・テキスト化・AI 原稿生成・BYO key） | ../SSOT/ONETOONE_PREP_PROFILE_REQUIREMENTS.md | active（P1+P2 主要コード・OpenAI 実装）／記録: Phase 155 |
| SPEC-014 | 定例会議事録 DB 化（meeting_minutes・file→DB・Meeting ハブ IA） | ../SSOT/CHAPTER_MINUTES_REQUIREMENTS.md | active（主要コード）／記録: Phase 180 |
| SPEC-015 | 1 to 1 実施後リファーラル提案（一覧ボタン・提案モーダル・run 保存・introductions リンク） | ../SSOT/ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md | active（**MVP 190–192 実装済み**／Phase F=195） |
| SPEC-016 | 定例会議事録リファーラル提案（MP・ウィークリー等・Meetings 入口・run 保存・introductions＋meeting_id） | ../SSOT/CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md | active（**MVP 190–192 実装済み**／Phase F=195） |
| SPEC-017 | SONAE 要件定義（Religo 拡張／単体利用対応・小規模コミュニティ向け安否確認・緊急連絡） | ../SSOT/SONAE_REQUIREMENTS.md | draft／記録: Phase 224・232 |
| SPEC-018 | チームMTG議事録 DB 化（meeting_types・team_id・import-team-minutes・Meetings 種別履歴） | ../SSOT/TEAM_MEETING_MINUTES_REQUIREMENTS.md | active（要件確定・実装未着手）／記録: Phase 234 |
| — | リファーラル提案 共通（§0 理念・§0.8 つなぎ手・§0.8.6 二経路・§0.8.7 Givers Gain） | ../SSOT/REFERRAL_SUGGESTION_COMMON.md | active |

## Statusの値
- active     : 現在有効なSSOT
- draft      : 作成中・未確定
- deprecated : 廃止（参照禁止）

## ルール
- 新しい仕様ファイルを作成したら必ずこのRegistryに登録する
- deprecatedになった仕様は削除せず状態を変更して残す
- Spec IDは SPEC-### の形式で連番管理する

## 既存 SSOT（docs/SSOT/）との対応

本プロジェクトでは docs/SSOT/ 配下にも仕様が存在する。新規 Phase で参照する際は、必要に応じて本 Registry に Spec ID を追加し、該当ファイルを登録すること。

## SSOT 品質改善（レビュー用プロンプト）

実装可能な粒度まで SSOT を引き上げるための **コピペ用プロンプト**: [PROMPT_SSOT_IMPROVEMENT.md](../process/PROMPT_SSOT_IMPROVEMENT.md)
