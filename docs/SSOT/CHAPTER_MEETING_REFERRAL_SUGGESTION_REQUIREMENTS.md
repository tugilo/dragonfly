# 定例会議事録リファーラル提案（メインプレ等）— SSOT

**Spec ID:** SPEC-016（[SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md) 参照）  
**ステータス:** active（要件確定・MVP 190–192 実装済み・**全記録理念は COMMON §0 Phase F**）  
**作成:** 2026-06-04 12:54 JST  
**最終更新:** 2026-06-04 22:14 JST  
**共通:** [REFERRAL_SUGGESTION_COMMON.md](REFERRAL_SUGGESTION_COMMON.md)（§0 理念・§0.7 共有同意・**§0.8 つなぎ手経由**・§0.8.6 二経路・**§0.8.7 Givers Gain**）  
**前提:** [CHAPTER_MINUTES_REQUIREMENTS.md](CHAPTER_MINUTES_REQUIREMENTS.md)（SPEC-014）、[REFERRAL_RECORDING_REQUIREMENTS.md](REFERRAL_RECORDING_REQUIREMENTS.md)（SPEC-009）、[MEETING_DOMAIN_IA.md](MEETING_DOMAIN_IA.md)、[DATA_MODEL.md](DATA_MODEL.md)

---

## 1. 目的

**チャプター定例会の議事録**（`meeting_minutes.body_markdown`）から、**外部リファーラルとして記録しうる紹介候補**を抽出し、利用者に**提案**する。主な抽出対象は **メインプレゼン（MP）** の「紹介希望先」「求めている紹介先」だが、**ウィークリープレゼン・ビジター紹介・シェアストーリー・教育コーナー** も対象とする。

利用者が確認・編集したうえで、既存 **`introductions`（SPEC-009）** に接続し、**`meeting_id`** で定例会由来を追跡する。

121 側は [ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md](ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md)（SPEC-015）。共通原則（BNI きっかけ作り・Givers Gain・二経路）は [REFERRAL_SUGGESTION_COMMON.md](REFERRAL_SUGGESTION_COMMON.md) **§0.8**。

### 1.0 BNI 理念との位置づけ

- **MVP:** 当回 `body_markdown` からの抽出（経路 **①** に近い — owner がつなげる紹介の取りこぼし防止）。
- **Phase F:** MP 横断・他者 121 由来の **②** では **つなぎ手 A 経由・from=A**（COMMON §0.8.6–7）。B への直接導線は出さない。

### 1.1 解く課題

| 課題 | 本機能の答え |
|------|----------------|
| MP で「紹介希望先」を聞いたが、翌週には忘れている | **Meetings から「リファーラル」** → 議事録ベースの提案モーダル |
| 議事録 md は充実しているが DB 上は閲覧のみ | **SPEC-014 の `body_markdown` を AI 入力**に活用 |
| 121 と同様、**再取り込みで本文が更新**される | run ＋ **`body_digest`** で版管理（COMMON §3） |
| 定例会で聞いた紹介機会を **`introductions` に残したい** | 採用時 **`meeting_id` 付き**で紹介登録 |

### 1.2 非目的

- COMMON §8 の共通非目的に加え:
- **リファラル発表セクション**（週次件数・サンキュー読み上げ）の自動記録 — 既に交換済みの報告。候補抽出の主対象にしない（P1）。
- 定例会議事録の **管理画面編集**（SPEC-014 非目標のまま）。
- **全参加者分**を owner 無関係に生成 — ログインユーザーの **owner 視点**（自分がつなげる紹介）に限定。
- COMMON §0.8 非目的: **contact B への直接コンタクト**、**つなぎ手 A の功績の横取り**。

---

## 2. 用語（定例会固有）

| 用語 | 定義 |
|------|------|
| **定例会 / Meeting** | `meetings` の 1 行（第 N 回・`held_on`）。 |
| **議事録** | `meeting_minutes` 1 行（`body_markdown`）。meeting と 1:1。 |
| **MP / メインプレ** | 議事録内のメインプレゼン要点（通常 5 分×複数登壇者）。 |
| **主役メンバー（subject）** | 提案の中心となる登壇者（MP 登壇者等）。`subject_member_id`。 |
| **source_section** | 議事録のどの節から抽出したか（§5.2）。 |

---

## 3. ユーザー体験（製品既定）

### 3.1 入口 — Meetings

| 項目 | 既定 |
|------|------|
| 配置 A | **Meetings 一覧**の各行アクション（議事録 Chip・Drawer 導線と並列）。 |
| 配置 B | **議事録モーダル**（Phase 183）フッター — 「リファーラル提案」ボタン。 |
| ラベル | **「リファーラル」** または **「リファーラル提案」**（121 側と表記統一）。 |
| 有効条件 | **`has_minutes = true`** かつ **`body_markdown` が空でない**。 |
| 権限 | 当該 workspace の **owner スコープ**（Meetings / introductions API と整合。SPEC-010 導入後はログインユーザー owner）。 |

### 3.2 提案モーダル

**ヘッダー例:**

- 定例会: **第 {number} 回** · `{held_on}` · `{name}`  
- 議事録: 「全文を見る」（既存 `MarkdownView` / 議事録モーダル再利用）  
- MP 登壇者一覧（front matter または概要表から — あれば）

**本文:**

1. **提案一覧** — `source_section` · `subject` 氏名でグループ化または Chip 表示可。  
2. 各提案行: COMMON §4 ＋ §5.2（本書）。  
3. 行アクション: **採用して保存** / **却下** / **あとで**。

**フッター:**

- **再生成** — 最新 `body_markdown` で新 run（COMMON §3）。  
- **過去の提案** — 同一 `meeting_id` の run 切替。

### 3.3 採用フロー

COMMON §3 に同じ。追加:

- **保存して紹介に登録** 時、`introductions.meeting_id` = 当該 `meetings.id` を **必須セット**。  
- `introduced_at` 初期値 = `meetings.held_on`（なければ `session_date` from front matter）。

---

## 4. 時間軸と再生成

[REFERRAL_SUGGESTION_COMMON.md](REFERRAL_SUGGESTION_COMMON.md) §3 を適用。定例会固有:

| 項目 | 説明 |
|------|------|
| 入力列 | `meeting_minutes.body_markdown` |
| digest 列名 | **`body_digest`**（run テーブル） |
| 更新トリガー | `dragonfly:import-chapter-minutes` 再実行（同一 `meeting_id` 上書き） |
| stale バッジ | Meetings 一覧 `referral_suggestion_stale`（GET meetings 拡張） |

---

## 5. 提案の中身

### 5.1 生成方式（P1 既定）

| 段階 | 方式 |
|------|------|
| **P1** | **ユーザー AI（BYO key）**。入力: `body_markdown` 全文 ＋ **当回 `participants`（メンバー id・氏名・カテゴリ・type）** ＋ workspace メンバー名簿サマリ。出力: §5.3 JSON。 |
| **P1 フォールバック** | AI OFF → 「AI 設定が必要」。 |
| **P2** | 下記 **構造化節のルール前処理** を AI 入力に併用（または AI なし部分的候補）。 |

**P2 ルール前処理の主対象（議事録 md の実例に基づく）:**

| 節パターン（見出し） | source_section | 抽出内容 |
|----------------------|----------------|----------|
| `メインプレゼン` / `メインプレゼン要点` / `メインプレゼンテーション` | `main_presentation` | 登壇者 H3 + `紹介希望先` / `求めている紹介先` リスト |
| `ウィークリープレゼン` | `weekly_presentation` | 同上（1 分版） |
| `ビジター` / `ビジター・ゲスト` | `visitor_intro` | ビジター行 — **members 未登録は label のみ** |
| `シェアストーリー` | `share_story` | 登壇者の紹介ニーズ・入り口戦略 |
| `教育コーナー` / `ネットワーキング学習` | `education` | 「紹介しやすい人」等の一般論 — **subject は null 可** |
| 概要表の `メインプレゼン` 行 | `main_presentation` | front matter / §1 表の登壇者名（ヒント） |

**除外（P1）:** `リファラル発表` / 週次件数表 — 既報告の集計。提案生成プロンプトでは **低優先または除外**。

### 5.2 direction（定例会）

| 値 | 説明 |
|----|------|
| **subject_seeks_intros** | 登壇者（subject）が紹介してほしい相手像・業種（MP の「紹介希望先」が典型） |
| **owner_introduces_to_subject** | owner が subject に **顧客・協力者** を紹介する候補 |
| **owner_introduces_subject** | owner が subject を **自分のネットワーク** に紹介する候補 |
| **mutual** | 双方向 |
| **unclear** | 判定不能 |

121 の `owner_to_target` 等とは **別列挙**（ソース SPEC で変換しない。UI ラベルは定例会用）。

### 5.3 AI 出力 JSON（サーバ検証用スキーマ案）

```json
{
  "suggestions": [
    {
      "source_section": "main_presentation",
      "subject_member_id": 88,
      "direction": "subject_seeks_intros",
      "summary": "田渕氏へ高級宿・超高級住宅向け設計会社の紹介",
      "rationale": "§9 メインプレ要点・田渕恭平「紹介希望先」リスト",
      "quality_notes": [],
      "suggested_from_member_id": 37,
      "suggested_to_member_id": null,
      "suggested_to_label": "一泊20万円以上の高級宿・ホテルの設計会社",
      "confidence": "high"
    }
  ]
}
```

- `subject_member_id`: `participants` / 名簿突合。未登録ビジターは **null**（氏名は `rationale` / `suggested_to_label` に残す）。  
- `suggested_from_member_id`: 通常 **owner**（つなぎ役）または **subject**（subject が誰かを紹介する場合）。

---

## 6. 保存 — 製品既定

COMMON §3 ＋ 定例会 FK:

| 状態 | DB |
|------|-----|
| 生成直後 | `meeting_referral_suggestion_runs` ＋ `meeting_referral_suggestions`（`pending`） |
| 採用 / 紹介登録 | COMMON と同じ。`meeting_id` 冗長 FK を suggestion 行にも保持 |

---

## 7. つなぎ履歴

### 7.1 リンク

| リンク | 用途 |
|--------|------|
| `meeting_referral_suggestions.introduction_id` → `introductions.id` | 提案 → 確定紹介 |
| `meeting_referral_suggestions.meeting_id` | どの定例会由来か |
| `meeting_referral_suggestion_runs.body_digest` | どの議事録版か |
| `introductions.meeting_id` | 紹介行から定例会へ逆参照 |

### 7.2 一覧・レポート（将来）

- Meetings モーダル: 採用済み提案を「この回でつないだ紹介」として表示。  
- introductions 一覧: **source: chapter_meeting** フィルタ（P2）。  
- ダッシュボード: 「定例会 MP から登録した紹介（今月）」KPI（P2）。

---

## 8. データモデル（実装 Phase）

[DATA_MODEL.md](DATA_MODEL.md) §4.20。概要:

### 8.1 `meeting_referral_suggestion_runs`

| カラム | 説明 |
|--------|------|
| id | PK |
| meeting_id | FK → meetings |
| meeting_minute_id | FK → meeting_minutes（冗長・監査） |
| owner_member_id | 記録者 |
| workspace_id | コンテキスト |
| body_digest | 生成時 `body_markdown` のハッシュ |
| body_char_count | 文字数 |
| generator, model, raw_response | AI 監査（121 run と同型） |
| created_at | |

### 8.2 `meeting_referral_suggestions`

| カラム | 説明 |
|--------|------|
| id | PK |
| run_id | FK → runs |
| meeting_id | 冗長 FK |
| source_section | string |
| subject_member_id | nullable FK → members |
| direction, summary, rationale, quality_notes | text |
| suggested_from_member_id, suggested_to_member_id | nullable FK |
| suggested_to_label, confidence, status | |
| introduction_id | nullable FK → introductions |
| accepted_at, dismissed_at, edited_snapshot | |
| timestamps | |

**インデックス:** `(meeting_id, created_at)`, `(run_id)`, `(subject_member_id)`, `(introduction_id)`, `(status)`.

---

## 9. API 概要（実装 Phase）

| メソッド | パス | 説明 |
|----------|------|------|
| POST | `/api/meetings/{id}/referral-suggestions/generate` | 新 run ＋ suggestions |
| GET | `/api/meetings/{id}/referral-suggestions` | run 一覧（`run_id` 可） |
| PATCH | `/api/meeting-referral-suggestions/{id}` | status / 編集 |
| POST | `/api/meeting-referral-suggestions/{id}/register-introduction` | introductions ＋ `meeting_id` |

---

## 10. UI 実装メモ

| コンポーネント | 役割 |
|----------------|------|
| Meetings 一覧行 | 「リファーラル」ボタン |
| 議事録 Dialog フッター | 同上（議事録閲覧直後の導線） |
| `MeetingReferralSuggestionDialog.jsx`（新規） | モーダル本体 |
| 既存 `MarkdownView` | 議事録参照 |

**モック比較:** [MOCK_UI_VERIFICATION.md](MOCK_UI_VERIFICATION.md) — Meetings 行アクションは FIT_AND_GAP_MEETINGS を更新。

---

## 11. プライバシー・AI

- `body_markdown` 全文を **ユーザーの AI プロバイダ**へ送る（BYO）。  
- 定例会議事録には **他メンバー・ビジターの事業内容**が含まれる — NCAS 全文は送らない（名簿・participants サマリのみ）。  
- `raw_response` は owner スコープのみ。

---

## 12. 実装フェーズ案

| Phase | 内容 | process Phase |
|-------|------|---------------|
| **A（要件）** | 本 SPEC・COMMON・DATA_MODEL §4.20・Registry — **docs ✅** | — |
| **B（MVP）** | migration・generate/get/patch API・Meetings ボタン＋モーダル・AI | **190** API → **191** UI |
| **C** | register-introduction・stale バッジ・過去 run | **192** |
| **D** | introductions 定例会由来フィルタ・KPI | **193** |
| **E** | MP 節ルール前処理・ビジター名突合 | **194** |

ロードマップ: [REFERRAL_SUGGESTION_PHASE_ROADMAP.md](../process/phases/REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

121 MVP（SPEC-015 Phase B）と **同じ implement Phase で並行**（COMMON §9）。

---

## 13. 関連 SSOT

| Spec | 関係 |
|------|------|
| SPEC-014 | 入力 `meeting_minutes`・import コマンド |
| SPEC-015 | 121 側の姉妹 SPEC |
| SPEC-009 | 採用後の `introductions` |
| SPEC-013 | BYO AI |
| MEETING_DOMAIN_IA | Meeting ハブ・議事録 IA |
| FIT_AND_GAP_MARKDOWN_VIEWER | GFM 表付き議事録表示 |

---

## 14. 未決（Open Questions）

| # | 論点 | 暫定 |
|---|------|------|
| 1 | subject が participants にいない MP 登壇者 | `subject_member_id` null ＋ rationale に氏名。P2 で fuzzy 突合 |
| 2 | 1 回の定例会で run を owner 共有するか | **owner ごと**に run（121 と同型。owner 視点の提案） |
| 3 | ビジター向け提案の introductions 登録 | `to_member_id` が member のときのみワンクリック（P1） |
| 4 | 議事録モーダルのみ vs 一覧のみ入口 | **両方**（§3.1） |

---

## 15. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-06-04 22:14 JST | §1.0 COMMON §0.8（きっかけ作り・Givers Gain・二経路）。非目的に直接コンタクト・横取り。 |
| 2026-06-04 12:54 JST | 初版。定例会議事録（MP・ウィークリー・ビジター等）からのリファーラル提案を SPEC-016 として要件化。COMMON・DATA_MODEL §4.20 連携。 |
