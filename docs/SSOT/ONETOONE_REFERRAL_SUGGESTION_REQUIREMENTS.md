# 1 to 1 実施後リファーラル提案 — SSOT

**Spec ID:** SPEC-015（[SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md) 参照）  
**ステータス:** active（要件確定・**実装未着手**）  
**作成:** 2026-06-04 12:43 JST  
**最終更新:** 2026-06-04 12:54 JST  
**共通:** [REFERRAL_SUGGESTION_COMMON.md](REFERRAL_SUGGESTION_COMMON.md)（機能族全体）  
**姉妹 Spec:** [CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md](CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md)（SPEC-016・定例会 MP 等）  
**前提:** [PROJECT_NAMING.md](../PROJECT_NAMING.md)、[REFERRAL_RECORDING_REQUIREMENTS.md](REFERRAL_RECORDING_REQUIREMENTS.md)（SPEC-009）、[ONETOONE_PREP_PROFILE_REQUIREMENTS.md](ONETOONE_PREP_PROFILE_REQUIREMENTS.md)（SPEC-013）、[DATA_MODEL.md](DATA_MODEL.md)

---

## 1. 目的

**121（1 to 1）の実施結果**（主に `one_to_ones.notes` の議事録 Markdown）から、**外部リファーラルとして記録しうる紹介候補**を抽出し、利用者に**提案**する。利用者が確認・編集したうえで、既存の **`introductions`（SPEC-009）** に接続できるようにする。

### 1.1 解く課題

| 課題 | 本機能の答え |
|------|----------------|
| 議事録に「紹介合意」が書いてあるが、記録画面まで行かない | **1 to 1 一覧から「リファーラル」ボタン**で提案モーダルを開き、下書きまで一気通貫 |
| 121 は増え続け、**同じ行の notes も後から更新**される | **生成のたびにスナップショット（実行履歴）**を残し、「いつ・どの notes に基づいた提案か」を追える |
| 「誰と誰をつないだか」の**履歴**が欲しい | 提案の採用時に **`introductions` へリンク**し、121 起点の紹介も追跡可能にする |

### 1.2 非目的（本 SPEC ではやらない）

- **自動で** `introductions` を作成する（必ず人の確認・明示操作）。  
- BNI 公式の「質の高いリファーラル」判定の自動化（システムは**候補と根拠**まで）。  
- **内部リファーラル（TYFCB）** の自動提案（P2 以降の拡張候補。P1 は外部のみ）。  
- Introduction Hint（Board）の置き換え（Hint は BO 同席ベースの横断発想。本機能族は **接触議事録文脈** — COMMON §8）。  
- **定例会議事録**からの提案 — **SPEC-016** を正とする（本書は 121 のみ）。

---

## 2. 用語

| 用語 | 定義 |
|------|------|
| **121 / 1 to 1** | `one_to_ones` の 1 行（1 回の予定・実施）。 |
| **リファーラル提案** | AI またはルールが議事録から抽出した「紹介候補」1 件。人が採用・却下・保留できる。 |
| **提案実行（run）** | ある時点の `notes`（および参照メンバー一覧）を入力に、提案一覧を**生成した 1 回の処理**。再生成のたびに新しい run が増える。 |
| **採用（accept）** | 提案を承認し、内容を編集可能な状態で**保存**する。任意で `introductions` 行を作成しリンクする。 |
| **つなぎ履歴** | 確定した `introductions`（＋任意で「121 のどの run から生まれたか」）による、**誰→誰**の記録。 |

---

## 3. ユーザー体験（製品既定）

### 3.1 入口 — 1 to 1 一覧

| 項目 | 既定 |
|------|------|
| 配置 | **1 to 1 一覧**の各行アクション（既存「メモ」「キャンセル」等と並列）。 |
| ラベル | **「リファーラル」**（またはアイコン＋ツールチップ）。 |
| 有効条件 | **`status = completed`** かつ **`notes` が空でない**行のみ有効。それ以外は disabled＋理由ツールチップ（例: 「実施後にメモを登録すると利用できます」）。 |
| 権限 | 当該行の **`owner_member_id` がログインユーザーの owner と一致**（既存 1to1 API と同じ）。 |

### 3.2 提案モーダル

ボタン押下で **Dialog（フル幅に近い large）** を開く。

**ヘッダー例:**

- 相手: `{target 氏名}` · カテゴリ · チャプター  
- 121 日時: `started_at` / `scheduled_at`  
- 元メモ: 「議事録を見る」（既存 Markdown ビューア／`MarkdownReadablePanel` 再利用）

**本文:**

1. **提案一覧**（カードまたはテーブル、最大表示件数は生成結果に従う。UI 上は折りたたみ可）。  
2. 各提案行の表示項目（下記 §5.2）。  
3. 行アクション: **採用して保存** / **却下** / **あとで**（保留）。

**フッター:**

- **「再生成」** — 最新 `notes` で新 run を作成（§4.2）。  
- **「過去の提案」** — 同一 `one_to_one_id` の run 一覧をタブまたはセレクトで切替（§4.3）。

### 3.3 採用フロー

1. 利用者が提案行を **採用**。  
2. モーダル内で **from / to / 概要 / 日付 / メモ** を編集（メンバーは Autocomplete、未登録相手はテキスト補足は P2）。  
3. **保存のみ** — 提案行を `accepted` とし、121 とのリンクを保持（§6）。  
4. **保存して紹介に登録** — 上記に加え `POST /api/introductions` 相当で行を作成し、`introduction_id` を提案行に記録。

いずれも **確認ダイアログ**を挟む（誤登録防止）。

---

## 4. 時間軸と再生成（製品既定）

121 は今後も増え、**同一 `one_to_ones` 行の `notes` も更新されうる**（Zoom 要約追記、`import-1to1-notes`、手編集）。そのため「その時出した候補」を曖昧に上書きしない。

### 4.1 原則

| 原則 | 説明 |
|------|------|
| **上書きしない** | 新しい生成は常に **新しい run** として保存する。 |
| **入力の指紋** | 各 run に **`notes_digest`**（例: SHA-256 of normalized notes）と **`notes_char_count`** を保存し、「どの版の議事録か」を後から判別する。 |
| **最新 run の強調** | モーダル既定表示は **最新 run**。過去 run は履歴から参照可能。 |
| **古い run の扱い** | 過去 run 内の `pending` 提案は残す。利用者が明示 **却下** しない限り削除しない（監査・振り返り）。 |

### 4.2 再生成のトリガー

- モーダル内 **「再生成」** ボタン。  
- （将来）`notes` 保存後に「リファーラル提案を更新しますか？」トースト — P2。

再生成時:

- `notes` が前回 run と **digest 同一**なら、API は **409 または警告**（無駄な AI コール抑制）。利用者が「それでも生成」で上書き run は作らず、既存 run を返すか、明示確認後に duplicate run を許可するかは実装 Phase で決定（**既定: 同一 digest では新 run を作らず既存最新 run を返す**）。

### 4.3 議事録更新後の見え方

`notes` が更新され digest が変わった場合:

- 一覧の行に **「議事録更新あり・提案未再生成」** バッジ（最新 run の digest ≠ 現在 notes の digest）。  
- モーダルを開くと、上部に **再生成を推奨**する Alert。

---

## 5. 提案の中身

### 5.1 生成方式（P1 既定）

| 段階 | 方式 |
|------|------|
| **P1** | **ユーザー AI（BYO key）** — [ONETOONE_PREP_PROFILE_REQUIREMENTS.md](ONETOONE_PREP_PROFILE_REQUIREMENTS.md) と同様の `user_ai_credentials`。入力: `notes` 全文＋相手メンバー概要＋**同一 workspace のメンバー名簿（氏名・カテゴリ・id）**のサマリ。出力: 構造化 JSON（§5.3）。 |
| **P1 フォールバック** | AI OFF 時はモーダルで「AI 設定が必要」と表示。ルールベースのみは P2。 |
| **P2** | 議事録内の「紹介（次廣→）」表の **正規表現＋メンバー突合**を AI 前処理に併用。 |

実施後 Zoom 文字起こし直結は [ONETOONE_PREP §12.6](ONETOONE_PREP_PROFILE_REQUIREMENTS.md) と合流（`mode=post_meeting_referral` 相当）。本 SPEC は **notes が既に DB にある**前提で開始する。

### 5.2 提案 1 件の表示・編集フィールド

| フィールド | 説明 |
|------------|------|
| **direction** | `owner_to_target`（自分→相手向けに紹介する相手先候補）/ `target_to_owner` / `mutual` / `unclear` |
| **summary** | 紹介の要約（議事録ベース・1〜2 文） |
| **rationale** | 根拠（議事録のどの合意・発言に基づくか） |
| **quality_notes** | 注意（例: NCAS 上は不適切だが 121 内合意あり） |
| **suggested_from_member_id** | 紹介元（通常 owner または target） |
| **suggested_to_member_id** | 紹介先（チャプター内メンバー。未確定は null） |
| **suggested_to_label** | メンバー未突合時の自由テキスト（業種・像） |
| **confidence** | `high` / `medium` / `low` |
| **status** | `pending` / `accepted` / `dismissed` / `deferred` |

### 5.3 AI 出力 JSON（サーバ検証用スキーマ案）

```json
{
  "suggestions": [
    {
      "direction": "owner_to_target",
      "summary": "静岡の建設・製造業向けに業務改善を紹介",
      "rationale": "議事録『次廣→相手』表の建設・製造行",
      "quality_notes": [],
      "suggested_from_member_id": 1,
      "suggested_to_member_id": 45,
      "suggested_to_label": null,
      "confidence": "medium"
    }
  ]
}
```

サーバ側で **存在する member_id のみ**採用、同一カテゴリ紹介は **警告フラグ**（Introduction Hint と同趣旨・強制除外はしない）。

---

## 6. 保存するかどうか — 製品既定

| 状態 | DB | 説明 |
|------|-----|------|
| 生成直後 | run ＋ suggestion 行（すべて `pending`） | **生成した時点で run は必ず保存**（AI コスト・監査のため）。 |
| 却下 | `dismissed` | 保存する（「見たが採用しない」履歴）。 |
| あとで | `deferred` | 保存する。 |
| 採用 | `accepted` | 編集後フィールドをスナップショット。`introduction_id` は null 可。 |
| 紹介登録 | `accepted` ＋ `introduction_id` | **つなぎ履歴**の正は `introductions`。提案行は「121 経由」のメタデータを保持。 |

**自動削除:** 行わない（`one_to_ones` と同様、関係履歴として保持）。

---

## 7. つなぎ履歴（誰と誰を繋いだか）

### 7.1 正（SSOT）

確定した **外部リファーラル**の正は引き続き **`introductions`**（SPEC-009）。  
本機能は **121 から生まれた紹介**であることを次で表現する。

| リンク | 用途 |
|--------|------|
| `one_to_one_referral_suggestions.introduction_id` → `introductions.id` | どの提案がどの紹介行になったか |
| `one_to_one_referral_suggestions.one_to_one_id` | どの 121 セッション由来か |
| `one_to_one_referral_suggestion_runs.id` | どの生成タイミング・どの notes 版か |

### 7.2 一覧・レポート（将来）

- **1 to 1 詳細 / モーダル:** 採用済み・紹介登録済みの提案を「実施したつなぎ」として表示。  
- **リファーラル一覧（未実装 UI）:** `introductions` に **source: one_to_one** フィルタ（P2・列追加または JOIN）。  
- **ダッシュボード:** 「121 から登録した紹介（今月）」KPI（P2）。

### 7.3 `introductions` へのマッピング（採用時）

| 提案 | introductions |
|------|----------------|
| `suggested_from_member_id` | `from_member_id` |
| `suggested_to_member_id` | `to_member_id` |
| `owner_member_id` | ログインユーザーの owner（記録者） |
| `summary` + `rationale` | `note` に結合（テンプレートは実装 Phase） |
| 121 日付 | `introduced_at` の初期値（編集可） |
| — | `referral_kind = external`（固定） |

**第三者コネクタ**（A を B に紹介し、owner がつないぎ役）の表現は、既存 `introductions` の from/to/owner セマンティクスに合わせ実装 Phase で UI ラベルを定義する。

---

## 8. データモデル（実装 Phase で migration）

[DATA_MODEL.md](DATA_MODEL.md) §4.19 に詳細。概要:

### 8.1 `one_to_one_referral_suggestion_runs`

| カラム | 説明 |
|--------|------|
| id | PK |
| one_to_one_id | FK → one_to_ones |
| owner_member_id | 記録者 |
| workspace_id | コンテキスト |
| notes_digest | 生成時 notes のハッシュ |
| notes_char_count | 文字数 |
| generator | `ai_openai` 等 |
| model | 使用モデル（nullable） |
| raw_response | AI 生 JSON（監査・デバッグ、text/json） |
| created_at | 生成日時 |

### 8.2 `one_to_one_referral_suggestions`

| カラム | 説明 |
|--------|------|
| id | PK |
| run_id | FK → runs |
| one_to_one_id | 冗長 FK（一覧用インデックス） |
| direction, summary, rationale, quality_notes | text |
| suggested_from_member_id, suggested_to_member_id | nullable FK → members |
| suggested_to_label | nullable string |
| confidence | string |
| status | enum 文字列 |
| introduction_id | nullable FK → introductions |
| accepted_at, dismissed_at | nullable datetime |
| edited_snapshot | json nullable（採用時の編集内容） |
| timestamps | |

**インデックス:** `(one_to_one_id, created_at)`, `(run_id)`, `(introduction_id)`, `(status)`.

---

## 9. API 概要（実装 Phase）

| メソッド | パス | 説明 |
|----------|------|------|
| POST | `/api/one-to-ones/{id}/referral-suggestions/generate` | 新 run 生成＋提案行作成。同一 digest は §4.2。 |
| GET | `/api/one-to-ones/{id}/referral-suggestions` | run 一覧＋各 run の suggestions（クエリ `run_id` 可）。 |
| PATCH | `/api/one-to-one-referral-suggestions/{id}` | status 更新・編集スナップショット。 |
| POST | `/api/one-to-one-referral-suggestions/{id}/register-introduction` | `introductions` 作成＋リンク。 |

すべて **owner スコープ**。AI 呼び出しは **サーバ内サービス**（キーはユーザー credential）。

---

## 10. UI 実装メモ（React Admin）

| コンポーネント | 役割 |
|----------------|------|
| `OneToOnesList.jsx` 行アクション | 「リファーラル」ボタン追加 |
| `OneToOneReferralSuggestionDialog.jsx`（新規） | モーダル本体 |
| 既存 `MarkdownReadablePanel` | notes 参照 |
| 既存 introductions フォーム部品 | 採用時の from/to 編集に再利用（あれば） |

**バッジ:** 一覧行で `notes_digest` ≠ 最新 run の digest のとき **要再生成**表示（GET 一覧 API に `referral_suggestion_stale` フラグを載せると N+1 を避けやすい）。

---

## 11. プライバシー・AI

- `notes` 全文は **ユーザーの AI プロバイダ**へ送る（SPEC-013 と同じ BYO 方針）。  
- `raw_response` は **本人 owner の行のみ**閲覧（SPEC-009・SPEC-010 と整合）。  
- 他メンバーの NCAS 本文は送らない（名簿は氏名・カテゴリ・id のみ）。

---

## 12. 実装フェーズ案

| Phase | 内容 | 種別 | process Phase |
|-------|------|------|---------------|
| **A（要件）** | 本 SPEC・COMMON・DATA_MODEL §4.19・Registry | docs ✅ | — |
| **B（MVP）** | migration・generate/get/patch API・一覧ボタン＋モーダル・AI 生成 | implement | **190** API → **191** UI |
| **C** | register-introduction・一覧 stale バッジ・過去 run UI | implement | **192** |
| **D** | introductions 一覧の 121 由来フィルタ・ダッシュボード KPI | implement | **193** |
| **E** | 内部リファーラル候補・ルール前処理・notes 保存後トースト | implement / docs | **194**（ルール） |

ロードマップ: [REFERRAL_SUGGESTION_PHASE_ROADMAP.md](../process/phases/REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

---

## 13. 関連 SSOT

| Spec | 関係 |
|------|------|
| REFERRAL_SUGGESTION_COMMON | run・digest・introductions マッピング等の共通 |
| SPEC-016 | 定例会議事録（MP 等）側の姉妹 SPEC |
| SPEC-009 | 採用後の正は `introductions` / `internal_referrals` |
| SPEC-013 | AI・BYO key・実施後モード拡張（§12.6） |
| SPEC-012 | Zoom 要約 → notes 更新 → 本機能の入力が厚くなる |
| INTRODUCTION_HINT | 横断的ペア発想。本機能族は接触議事録で補完 |
| FIT_AND_GAP_MARKDOWN_VIEWER | 議事録表示の再利用 |

---

## 14. 未決（Open Questions）

| # | 論点 | 暫定 |
|---|------|------|
| 1 | 同一 digest で再生成ボタンを押したとき | 既存最新 run を返す（§4.2） |
| 2 | 相手が visitor で紹介先がチャプター外のみのとき | `suggested_to_label` のみ。`introductions` は to が member のときのみワンクリック登録（P1） |
| 3 | 1 提案から複数 introductions | P1 は 1:1。複数紹介は提案を分割して生成 |
| 4 | run / suggestion の物理削除 | 採用しない（§6） |

---

## 15. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-06-04 12:54 JST | COMMON・SPEC-016 連携。非目的に定例会を明記。関連 SSOT 更新。 |
| 2026-06-04 12:43 JST | 初版。一覧リファーラルボタン・提案モーダル・run 保存・つなぎ履歴（introductions リンク）を製品既定として整理。 |
