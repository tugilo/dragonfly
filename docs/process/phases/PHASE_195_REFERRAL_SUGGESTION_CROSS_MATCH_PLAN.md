# PLAN: Phase 195 — リファーラル提案 横断マッチング（つなぎ手経由・共有同意）

**Phase ID:** 195 / `REFERRAL-SUGGESTION-CROSS-MATCH`  
**種別:** implement  
**Related SSOT:** SPEC-015, SPEC-016, SPEC-009 §2.1, [REFERRAL_SUGGESTION_COMMON.md](../../SSOT/REFERRAL_SUGGESTION_COMMON.md) §0・§0.5・§0.7・§0.8（§0.8.6–7）, [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.19–§4.20

**ロードマップ:** [REFERRAL_SUGGESTION_PHASE_ROADMAP.md](REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

**前提:** Phase 190–192 merge 済み（`develop` / `main`）。理念 SSOT（North Star・Givers Gain）merge 済み（`feature/docs-referral-suggestion-northstar-20260604` → `develop` `2c8b250`）。

**モック比較:** [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) — 本 Phase でモーダル CTAs・設定 UI を変更するため、完了時に [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) に差分を追記（モック未収録分は FIT 列を正）。

---

## 1. 目的

MVP（190–192）の **単一議事録抽出**に加え、COMMON §0 の **関係コンテキスト** でリファーラル提案を生成する。

- **主役（subject）** — 121 入口では `target_member_id`、定例会では `subject_member_id`
- **横断コーパス** — 貢献共有 ON の他メンバー 121 ＋ 章の定例会議事録（直近 N 回）
- **二経路（§0.8.6）** — `corpus_source=self`（自己履歴）と `member_network`（つなぎ手経由）
- **Givers Gain（§0.8.7）** — `member_network` は **A に紹介をお願い** のみ。B 直接導線なし。`introductions` 既定 **from=A, to=C**

---

## 2. 製品判断（PLAN で確定）

| 論点 | 決定 | 理由 |
|------|------|------|
| 横断共有の初期値 | **`allow_cross_corpus_contribution = false`（オプトイン）** | §0.7 秘匿。明示同意後にコーパスへ貢献 |
| 定例会議事録 | **貢献設定の対象外。章内の直近議事録は常に横断コーパスに含める** | MP は章共有資産（COMMON §0.7.3） |
| 生成モード | **`context_mode=document`（現行）と `relationship`（新規）を共存** | 後方互換。UI は 121/定例会から **`relationship` を既定** |
| 横断 121 の範囲 | **completed のみ**、`status=canceled` 除外、owner が貢献 ON | 品質・プライバシー |
| 定例会の範囲 | **同一 workspace、直近 6 回**（`held_on` 降順）、`body_markdown` 非空 | プロンプト上限対策 |
| 主役 Pack | subject 関連の **過去 121（owner→target 双方向）** ＋ 当該接触本文 | §0.1 (A) |
| AI | 既存 BYO OpenAI（SPEC-013）。**Relationship Pack は文字数上限で truncate**（既存 24k chars 枠内） | Phase 194 ルール前処理は別 Phase |
| A への通知 | **P2**（依頼はメモ＋121 作成導線のみ） | スコープ抑制 |

決定後、COMMON §0.7.2 の「要決定」を本 PLAN 参照に更新する（REPORT 時）。

---

## 3. スコープ

### 3.1 DB（migration）

**新規テーブル `member_referral_corpus_settings`**

| 列 | 型 | 説明 |
|----|-----|------|
| id | bigint PK | |
| workspace_id | FK nullable | 章スコープ |
| member_id | FK | 設定主体（owner_member と 1:1 想定） |
| allow_cross_corpus_contribution | bool default **false** | §0.7 貢献 |
| timestamps | | |

ユニーク: `(workspace_id, member_id)` または `member_id` のみ（1 member = 1 chapter 前提）

**run テーブル拡張（両方）**

| 列 | 説明 |
|----|------|
| `context_mode` | `document` \| `relationship` |
| `context_digest` | Relationship Pack の SHA-256（`relationship` 時。`document` 時は従来 digest と同値でも可） |
| `subject_member_id` | 主役（121 でも保存） |
| `corpus_meta` | json nullable — `{consented_owner_count, o2o_excerpt_count, meeting_count}` |

**suggestion テーブル拡張（両方）**

| 列 | 説明 |
|----|------|
| `corpus_source` | `self` \| `member_network` |
| `suggested_contact_label` | contact B（nullable。`suggested_to_label` は互換のため残す） |
| `source_one_to_one_id` | 根拠 121（nullable FK） |
| `source_meeting_id` | 根拠定例会（nullable FK） |

既存 `direction` に **`via_connector`** を追加（normalizer・AI スキーマ）。

### 3.2 バックエンド

| コンポーネント | 責務 |
|----------------|------|
| `MemberReferralCorpusSettings` Model + `ReferralCorpusSettingsService` | GET/PATCH 設定・デフォルト false |
| `ReferralRelationshipContextBuilder` | 主役 Pack ＋ 同意済み他者 121 抜粋 ＋ 直近定例会抜粋 |
| `ReferralSuggestionAiService` | `relationship` 用 system/user プロンプト、`via_connector` 出力 |
| `OneToOneReferralSuggestionService` / `MeetingReferralSuggestionService` | `generate` に `context_mode` 対応・digest 重複キーに `context_mode`+`context_digest` |
| `ReferralSuggestionPayloadNormalizer` | `via_connector` パース。② 時 `suggested_from`=A, `suggested_to_member_id`=requester(C), contact→label |
| `RegisterReferralIntroduction`（既存を拡張） | `corpus_source=member_network` 時 **from/to 既定**＋note テンプレ |

**API 追加・変更**

| メソッド | パス | 内容 |
|----------|------|------|
| GET | `/api/referral-corpus-settings` |  acting owner の設定 ＋ `consented_peer_count` |
| PATCH | `/api/referral-corpus-settings` | `allow_cross_corpus_contribution` |
| POST | `.../referral-suggestions/generate` | body/query: `context_mode`（既定 `relationship`） |

### 3.3 フロント（`www/resources/js`）

| 画面 | 変更 |
|------|------|
| **設定** | Religo 設定または Profile に「他メンバーの提案に自分の 121 を使う」トグル＋同意者数表示 |
| **ReferralSuggestionDialogCore** | `corpus_source` でカード UI 分岐。`member_network`: **「{A} に紹介をお願い」**（121 作成 `target_member_id=A` へ prefill）、**B 直接 NG** |
| **RegisterReferralIntroductionDialog** | `via_connector` 時 from/to 初期値・説明文 |
| **OneToOnesList / MeetingsList** | 生成時 `context_mode=relationship` を送る |

**必須:** `npm run build`

### 3.4 テスト

- Feature: settings GET/PATCH、relationship generate（同意 ON/OFF でコーパス差）、`via_connector` normalize、register-introduction from=A
- 既存 190–192 テスト回帰（`context_mode=document` 既定互換）

### 3.5 ドキュメント（Phase 内）

- `DATA_MODEL.md` §4.19–4.20 ＋ `member_referral_corpus_settings`
- COMMON §0.7.2 デフォルト確定の 1 行
- FIT_AND_GAP（UI 変更分）
- WORKLOG / REPORT / PHASE_REGISTRY

---

## 4. 非スコープ（Phase 195 ではやらない）

- Phase **193**（KPI・フィルタ）・**194**（ルール前処理）の実装
- 全議事録全文の常時インデックス・オフラインサマリ（§0.2 Phase F 索引 — P2）
- 121 行単位の非公開フラグ（§0.7 P2）
- A へのプッシュ通知・依頼ワークフロー DB
- `benefit` 軸のみ OFF（§0.7.1 P2）
- 他章 workspace 横断

---

## 5. 実装タスク（推奨順）

| # | Task | 完了条件 |
|---|------|----------|
| T1 | migration + Models | migrate 成功 |
| T2 | ReferralCorpusSettings API | Feature test |
| T3 | ReferralRelationshipContextBuilder + unit/feature | 同意フィルタ・6 回定例会 |
| T4 | AI prompt + normalizer `via_connector` | パーステスト |
| T5 | generate 統合（121 → 定例会） | relationship run 保存 |
| T6 | register-introduction 既定 | from=A to=C |
| T7 | UI 設定 + Dialog CTAs + build | 手動受入 |
| T8 | docs + FIT_AND_GAP | SSOT 整合 |

---

## 6. DoD（Definition of Done）

- [ ] **§0.7** 貢献 ON/OFF 設定 UI・API。未同意 owner の 121 は他者 `relationship` 生成に含まれない
- [ ] **§0.8.6** 提案に `corpus_source`。`member_network` と `self` が混在して表示できる
- [ ] **§0.8** `member_network` に **「A に紹介をお願い」** のみ（121 prefill）。**B への連絡・URL ボタンなし**
- [ ] **§6 / §0.8.7** `register-introduction` で `via_connector` の既定 **from=connector, to=requester(owner)**。note に contact
- [ ] **§0.8.7** Givers Gain レビュー: C 横取りを促す UI がないこと（チェックリスト REPORT に記載）
- [ ] `context_mode=document` で既存 MVP 動作が壊れていない
- [ ] `php artisan test` 全通過
- [ ] `npm run build` 成功
- [ ] develop merge + **Merge Evidence**（REPORT）
- [ ] PHASE_REGISTRY `195` → completed

---

## 7. 受入テスト（手動）

| # | 手順 | 期待 |
|---|------|------|
| 1 | 設定で貢献 ON にする | `consented_peer_count` ≥1（他者も ON 時） |
| 2 | 121#42 で relationship 生成 | `via_connector` 候補があり、根拠に他者 121 or 定例会 |
| 3 | `member_network` 候補 | 「福田さんに紹介をお願い」系 CTA。B 直接なし |
| 4 | 紹介登録 | introductions が from=つなぎ手、to=自分 |
| 5 | 貢献 OFF のユーザー | 他者生成のコーパスにその人の 121 が出ない |

データ: [ロードマップ受入表](REFERRAL_SUGGESTION_PHASE_ROADMAP.md#受入テスト用データ全-phase-共通)

---

## 8. ブランチ・三点セット

| 項目 | 値 |
|------|-----|
| ブランチ | `feature/phase195-referral-suggest-cross-match` |
| PLAN | 本ファイル |
| WORKLOG | [PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_WORKLOG.md](PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_WORKLOG.md) |
| REPORT | [PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_REPORT.md](PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_REPORT.md) |

---

## 9. Open Questions（実装中に逸脱したら WORKLOG へ）

| # | 論点 | 暫定（本 PLAN） |
|---|------|-----------------|
| 1 | 設定 UI の置き場 | `/settings` 既存 Religo 設定ブロックに追加 |
| 2 | `suggested_contact_member_id` | P1 は **label のみ**。B が章メンバーでも label 優先（P2 で FK） |
| 3 | relationship 生成のコスト | 同意者 0 なら subject Pack のみで生成（他者 NW 候補は少ない想定を UI 表示） |

---

## 10. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-06-04 22:19 JST | 初版。§0.7–0.8.7 反映。オプトイン・定例会常時含む・二経路・Givers Gain DoD。 |
