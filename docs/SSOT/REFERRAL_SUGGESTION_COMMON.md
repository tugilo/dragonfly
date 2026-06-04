# リファーラル提案 — 共通アーキテクチャ SSOT

**位置づけ:** [ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md](ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md)（**SPEC-015**・121）と [CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md](CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md)（**SPEC-016**・定例会）の**共通部分**。個別入口・入力ソース・FK は各 SPEC を正とする。

**ステータス:** active（要件確定・**実装未着手**）  
**作成:** 2026-06-04 12:54 JST  
**最終更新:** 2026-06-04 12:54 JST  
**前提:** [REFERRAL_RECORDING_REQUIREMENTS.md](REFERRAL_RECORDING_REQUIREMENTS.md)（SPEC-009）、[ONETOONE_PREP_PROFILE_REQUIREMENTS.md](ONETOONE_PREP_PROFILE_REQUIREMENTS.md)（SPEC-013・BYO AI）

---

## 1. 製品上の位置づけ

Religo の **リファーラル提案**は、**接触の記録（議事録 Markdown）** から **外部リファーラル候補**を抽出し、人が確認したうえで **`introductions`（SPEC-009）** に接続する機能族である。

| ソース | Spec | 入力 DB | 入口 UI |
|--------|------|---------|---------|
| **121（1 to 1）** | SPEC-015 | `one_to_ones.notes` | 1 to 1 一覧 |
| **定例会（MP 等）** | SPEC-016 | `meeting_minutes.body_markdown` | Meetings 一覧 / 議事録モーダル |

**正（確定した紹介の SSOT）** は常に `introductions`。提案テーブルは **由来・根拠・採否履歴** を保持する。

---

## 2. 共通用語

| 用語 | 定義 |
|------|------|
| **リファーラル提案** | AI またはルールが議事録から抽出した紹介候補 1 件。`pending` / `accepted` / `dismissed` / `deferred`。 |
| **提案実行（run）** | ある時点の議事録本文を入力に、提案一覧を**生成した 1 回**。再生成のたびに **新 run**（上書きしない）。 |
| **本文指紋（digest）** | 正規化した Markdown 本文のハッシュ（例: SHA-256）。`notes_digest`（121）/ `body_digest`（定例会）。 |
| **採用（accept）** | 提案を承認し編集可能に保存。任意で `introductions` 作成＋リンク。 |
| **つなぎ履歴** | 確定 `introductions` ＋ どの run / どの接触から生まれたかのメタデータ。 |

---

## 3. 共通 UX 原則

| 原則 | 説明 |
|------|------|
| **人の確認必須** | 自動で `introductions` を作らない。 |
| **run 履歴** | 同一接触の議事録が更新されても、過去 run は残す。 |
| **digest 重複抑制** | 同一 digest で再生成ボタン → **新 run を作らず**最新 run を返す（既定）。 |
| **stale 表示** | 最新 run の digest ≠ 現在 DB 本文 digest → 「議事録更新あり・提案未再生成」バッジ / Alert。 |
| **物理削除なし** | run / suggestion 行は監査・振り返りのため削除しない。 |
| **P1 対象** | **外部リファーラル**候補のみ。内部（TYFCB）は P2 以降。 |
| **AI** | ユーザー BYO key（`user_ai_credentials`）。OFF 時は「AI 設定が必要」。 |

---

## 4. 提案 1 件 — 共通フィールド

各ソース SPEC で列名は同型。SPEC-016 のみ追加列あり（§5）。

| フィールド | 説明 |
|------------|------|
| **direction** | 紹介の向き（121 / 定例会で列挙値が異なる — 各 SPEC 参照） |
| **summary** | 紹介要約（1〜2 文） |
| **rationale** | 根拠（議事録のどの節・表・発言か） |
| **quality_notes** | 注意（NCAS 不適切だが例会内合意 等） |
| **suggested_from_member_id** | 紹介元メンバー（nullable） |
| **suggested_to_member_id** | 紹介先メンバー（nullable） |
| **suggested_to_label** | 未突合時の自由テキスト（業種・像） |
| **confidence** | `high` / `medium` / `low` |
| **status** | `pending` / `accepted` / `dismissed` / `deferred` |
| **introduction_id** | 採用後に `introductions` へリンク（nullable） |
| **edited_snapshot** | 採用時の編集内容（json, nullable） |

サーバ側: **存在する member_id のみ**採用。同一カテゴリ紹介は **警告フラグ**（強制除外しない）。

---

## 5. SPEC-016 追加フィールド（定例会のみ）

| フィールド | 説明 |
|------------|------|
| **source_section** | `main_presentation` / `weekly_presentation` / `visitor_intro` / `share_story` / `education` / `other` |
| **subject_member_id** | 提案の**主役メンバー**（MP 登壇者・シェアストーリー登壇者等。nullable＝ビジター未登録） |

---

## 6. `introductions` への共通マッピング（採用時）

| 提案 | introductions |
|------|----------------|
| `suggested_from_member_id` | `from_member_id` |
| `suggested_to_member_id` | `to_member_id` |
| `owner_member_id` | ログインユーザーの owner（記録者） |
| `summary` + `rationale` | `note`（結合テンプレは実装 Phase） |
| 接触日 | `introduced_at` 初期値（121 日 / 定例会 `held_on` — 編集可） |
| — | `referral_kind = external`（固定） |

**定例会（SPEC-016）追加:** `meeting_id` を **必ず**セット（どの定例会由来か）。

---

## 7. 共通 API パターン（実装 Phase）

ソースごとにパス prefix が異なるが、操作は同型:

| 操作 | パターン |
|------|----------|
| 生成 | `POST .../referral-suggestions/generate` |
| 一覧 | `GET .../referral-suggestions?run_id=` |
| 更新 | `PATCH .../referral-suggestions/{id}` |
| 紹介登録 | `POST .../referral-suggestions/{id}/register-introduction` |

すべて **owner スコープ**。AI はサーバ内サービス（ユーザー credential）。

---

## 8. 非目的（共通）

- Introduction Hint（Connections）の置き換え — Hint は BO 同席ベース、本機能族は **接触議事録文脈**。
- BNI 公式「質の高いリファーラル」の自動判定。
- 定例会の **リファラル件数報告**（§10 等）の自動記録 — それは章の集計。本機能は **これからつなぐ候補**。

---

## 9. 実装フェーズ（機能族全体）

| Phase | 121（SPEC-015） | 定例会（SPEC-016） | process Phase |
|-------|-----------------|-------------------|---------------|
| **A 要件** | ✅ | ✅ | （docs 2026-06-04） |
| **B MVP** | API + UI | API + UI | **190** API → **191** UI |
| **C** | register・stale・過去 run | 同上 | **192** |
| **D** | introductions フィルタ・KPI | 同上 | **193** |
| **E** | ルール前処理 | MP 節パーサ | **194** |

ロードマップ: [process/phases/REFERRAL_SUGGESTION_PHASE_ROADMAP.md](../process/phases/REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

---

## 10. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-06-04 13:38 JST | process Phase 190〜194 ロードマップ連携（§9）。 |
| 2026-06-04 12:54 JST | 初版。SPEC-015 / SPEC-016 の共通アーキテクチャを整理。定例会議事録（MP 等）を機能族に包含。 |
