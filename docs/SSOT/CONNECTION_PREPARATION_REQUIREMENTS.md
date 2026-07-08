# つなぐ準備（紹介文コピペ）— SSOT

**Spec ID:** SPEC-022（[SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md) 参照）  
**ステータス:** active（Phase 274 実装済み — 2026-07-08）  
**作成:** 2026-07-08 07:57 JST  
**前提:** [REFERRAL_SUGGESTION_COMMON.md](REFERRAL_SUGGESTION_COMMON.md)（§0.8 つなぎ手経由）、[ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md](ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md)（SPEC-015）、[CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md](CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md)（SPEC-016）、[REFERRAL_RECORDING_REQUIREMENTS.md](REFERRAL_RECORDING_REQUIREMENTS.md)（SPEC-009）

---

## 1. 目的

リファーラル提案（121 / 定例会入口）で列挙された**各候補**について、利用者が **LINE / Messenger へコピペできる紹介文案**を、履歴（121 議事録・名簿・提案根拠）から生成できるようにする。

**解く課題:**

| 課題 | 本機能の答え |
|------|----------------|
| 候補は出るが、毎回文案をゼロから書く | 候補行ごとに **「紹介文を作成」** → モーダルで文案生成 |
| グループ作成前に了承が必要 | **了承依頼文**を個別にコピー |
| グループ初回投稿が手作業 | **相互紹介 + 接点**の統合投稿文をコピー |
| 提案に `member_id` が無い | **案2:** モーダル内で A/B を手動指定して生成 |

**非目的（本 SPEC / MVP）:**

- LINE / Messenger **グループの自動作成**（API 連携）
- 了承依頼の **プッシュ通知・自動送信**
- 文案・了承状態の **DB 永続化**（MVP は都度生成 + 手動チェックのみ）
- B（contact）への **直接コンタクト導線**（COMMON §0.8 非目的の継続）

**運用参照（手動実例）:** [`meetings/1to1/1to1_ito_takao_phoenix_jsp.md`](../meetings/1to1/1to1_ito_takao_phoenix_jsp.md)（Messenger 了承 → グループ → 相互紹介）、[`meetings/1to1/1to1_mitarai_fudotech.md`](../meetings/1to1/1to1_mitarai_fudotech.md)（了承 → 3名グループ可否確認）

---

## 2. 用語

| 用語 | 定義 |
|------|------|
| **つなぐ準備** | グループ作成・初回投稿の**前**に、了承依頼と紹介文の下書きを整える一連の操作。 |
| **提案候補（suggestion）** | `one_to_one_referral_suggestions` / `meeting_referral_suggestions` の 1 行。きっかけ・根拠の正。 |
| **パーティ A / B** | 利用者がモーダルで指定する「つなぐ 2 者」。提案メタから**初期値**を入れ、**上書き可**（製品既定・案2）。 |
| **文案ブロック（block）** | コピー単位の 1 テキスト（了承依頼 A 向け、グループ投稿 等）。 |
| **つなぎ手（owner）** | ログインユーザー。文案を生成し、外部チャネルで送信する人。 |

---

## 3. ユーザー体験（製品既定）

### 3.1 入口

| 項目 | 既定 |
|------|------|
| 親画面 | 121 / 定例会の **リファーラル提案モーダル**（既存 `ReferralSuggestionDialogCore`） |
| 配置 | **提案一覧の各行**に独立ボタン **「紹介文を作成」** |
| ラベル代替 | 「つなぐ準備」はツールチップまたはサブテキストで可 |
| 有効条件 | 提案行が存在すれば有効（`pending` / `deferred` / `accepted` 問わず文案再表示可）。`introduction_id` 登録済みでも **文案再表示**は可 |
| 権限 | 当該提案 run の owner と一致（既存リファーラル API と同じ） |

### 3.2 子モーダル（候補 1 件 = 1 モーダル）

親 Dialog の上に **large フル幅**の子 Dialog を重ねる。

**ヘッダー例:**

- きっかけ: `{suggestion.summary}`
- 種別 Chip: `{direction}` / `{corpus_source}`
- 根拠: `rationale` または `evidence_lines`（折りたたみ可）

**本文 — パーティ指定（案2・必須）:**

| フィールド | UI | ルール |
|------------|-----|--------|
| **パーティ A** | Members Autocomplete | 章内 `members.id`。提案から初期値。空でも生成ボタンは disabled まで待たず、**A 必須** |
| **パーティ B** | Autocomplete **または** 自由テキスト | `party_b_member_id` と `party_b_label` は排他。どちらか一方必須 |
| **チャネル** | 任意 Select（既定 `messenger`） | 文案の文体ヒント（`line` / `messenger` / `email`）。MVP は表示のみでも可 |

**初期値マッピング（提案 → A/B）:**

| 提案 `direction` / フィールド | A 初期値 | B 初期値 |
|------------------------------|----------|----------|
| `subject_should_meet` | `subject_member_id` または 121 の target | `suggested_to_member_id` |
| `via_connector` | owner（依頼者） | `suggested_from_member_id`（つなぎ手）— 依頼文中心。双方メンバー指定時のみ相互紹介タブも |
| `owner_to_target` 等 + `suggested_to_member_id` | owner | `suggested_to_member_id` |
| `suggested_to_label` のみ | owner | テキスト欄に `suggested_to_label` |
| `suggested_contact_label`（via_connector） | connector | テキスト欄に contact ラベル |
| 未特定 | 空 | 空（ユーザーが両方指定） |

**生成後 — 文案タブ:**

| block key | ラベル | 出す条件 |
|-----------|--------|----------|
| `consent_a` | 了承依頼（A 向け） | A がメンバーとして特定されている |
| `consent_b` | 了承依頼（B 向け） | B がメンバーまたはテキストで特定 |
| `intro_a_to_b` | A 向け: B の紹介（グループ用） | A・B 双方特定 |
| `intro_b_to_a` | B 向け: A の紹介（グループ用） | A・B 双方特定 |
| `group_opening` | グループ初回投稿（統合） | A・B 双方特定 |
| `connector_request` | つなぎ手への紹介依頼 | `via_connector` または B が社外ラベルのみ |

各ブロック: multiline 表示 + **「コピー」**ボタン + クリップボード成功トースト。

**了承（MVP）:**

- □ A 了承済み / □ B 了承済み — **クライアント state のみ**（リロードで消えてよい）
- 任意メモ 1 行（local state）

**フッター:**

- `閉じる`
- `文案を再生成`（同一パーティ指定で API 再呼び出し）
- 既存 `RegisterReferralIntroductionDialog` への導線（「採用して登録…」）— 任意

### 3.3 既存行アクションとの関係

| 既存 | Phase 274 後 |
|------|----------------|
| `1 to 1 を作成（つなぐ）` | 維持。子モーダル内に「1 to 1 を作成」リンクを置いてもよい（P2） |
| `〇〇さんに紹介をお願い` | **「紹介文を作成」に機能統合**（`connector_request` タブ）。遷移ボタンは削除または outlined に降格 |
| `採用して登録` | 維持 |

---

## 4. 文案の内容要件

### 4.1 文体（BNI / tugilo 運用）

[Intro Living Document §8.7](../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) および 1to1 議事録の Messenger たたき台に準拠:

- **短く**（LINE/Messenger で読める。目安 400〜800 字/ブロック）
- 含める要素: **なぜ繋ぐか** / **相手の強み（1〜2文）** / **話してほしい接点**
- 固有名詞・他社事例は **議事録・了承文脈がある範囲**。不明時は「〇〇さん（カテゴリ）」程度に留める
- 敬体。グループ初回は「お二人にお繋ぎします」型の挨拶から入る

### 4.2 了承依頼（個別 DM）

**A 向け例（構造）:**

> {A さん名}、お疲れさまです。  
> {B の一行要約} という方がおり、{接点の理由} なので、もしよろしければお繋ぎしたいと思っています。  
> グループを作成してよろしいでしょうか？

**B 向け**も同型（A の要約に差し替え）。

### 4.3 グループ初回投稿（統合）

**構造:**

1. 挨拶（つなぎ手名）
2. B について（A 向けに読む紹介）
3. A について（B 向けに読む紹介）
4. なぜ繋いだか・最初に話してほしいこと
5. 締め（「まずは情報交換から」等）

---

## 5. API（製品既定）

### 5.1 エンドポイント

| Method | Path |
|--------|------|
| `POST` | `/api/one-to-one-referral-suggestions/{suggestion}/generate-connect-copy` |
| `POST` | `/api/meeting-referral-suggestions/{suggestion}/generate-connect-copy` |

**認可:** `auth:sanctum` + 提案の `owner_member_id` がログインユーザーと一致（既存 referral suggestion と同じ）。

### 5.2 Request body

```json
{
  "party_a_member_id": 37,
  "party_b_member_id": 45,
  "party_b_label": null,
  "channel_hint": "messenger"
}
```

| フィールド | 必須 | 説明 |
|------------|------|------|
| `party_a_member_id` | **必須** | パーティ A（章内メンバー） |
| `party_b_member_id` | 条件 | B がメンバーのとき。`party_b_label` と排他 |
| `party_b_label` | 条件 | B が未登録・社外のときの表示名 + 業種像（1 行） |
| `channel_hint` | 任意 | `messenger` \| `line` \| `email`（プロンプト文体のみ） |

**バリデーション:**

- `party_a_member_id` は同一 workspace の有効 `members.id`
- `party_b_member_id` 指定時も同一 workspace（クロスチャプターは P2）
- A = B は 422

### 5.3 Response body

```json
{
  "suggestion_id": 12,
  "party_a_member_id": 37,
  "party_b_member_id": 45,
  "party_b_label": null,
  "blocks": [
    { "key": "consent_a", "label": "了承依頼（A向け）", "text": "..." },
    { "key": "consent_b", "label": "了承依頼（B向け）", "text": "..." },
    { "key": "group_opening", "label": "グループ初回投稿", "text": "..." }
  ],
  "meta": {
    "model": "gpt-4o-mini",
    "source_o2o_ids": [82, 91],
    "generated_at": "2026-07-08T07:57:00+09:00"
  }
}
```

**永続化:** MVP では **レスポンスのみ**（DB テーブル追加なし）。同一セッション中の React state キャッシュは可。

### 5.4 生成入力（サーバ側コーパス）

| ソース | 用途 |
|--------|------|
| 当該 `suggestion`（summary, rationale, evidence_lines, direction） | きっかけ・接点 |
| 当該 121 `notes` または定例会 `body_markdown` | 親 run の議事録 |
| A・B 各自との `one_to_ones.notes`（owner が関与する completed 行） | 相互紹介の材料 |
| `members`（氏名・カテゴリ・会社） | 紹介文の骨格 |
| 横断コーパス（Phase 195・同意済み） | 根拠補強（任意・既存 `ReferralRelationshipContextBuilder` 再利用） |

**AI:** BYO key 必須（[ONETOONE_PREP_PROFILE_REQUIREMENTS.md](ONETOONE_PREP_PROFILE_REQUIREMENTS.md) と同様）。未設定時 422 + UI で設定画面へ誘導。

---

## 6. UI コンポーネント（実装 Scope 参照）

| ファイル（案） | 役割 |
|----------------|------|
| `ReferralConnectCopyDialog.jsx` | 子モーダル本体 |
| `ReferralSuggestionList.jsx` | 行ボタン追加 |
| `referralSuggestionApi.js` | `generateConnectCopy` API クライアント |

**モック比較:** 管理画面モックに本機能の専用画面はない。既存リファーラル提案モーダルの延長として実装。比較は [MOCK_UI_VERIFICATION.md](MOCK_UI_VERIFICATION.md) の O 系（1to1 行アクション）を参考に、差分は Phase 274 REPORT で `FIT_AND_GAP` 追記可。

---

## 7. `introductions` との関係

- 文案生成は **`introductions` を自動作成しない**（COMMON §0 人の確認必須）
- グループ投稿・了承完了後、利用者が既存 **「採用して登録」** で SPEC-009 に記録
- 相互接続（A↔B を owner が仲介）の `introductions` マッピングは **Phase 274 WORKLOG で確定**（MVP 案: owner 記録者として 1 件、`note` に双方情報）

---

## 8. フェーズ分割

| Phase | 内容 |
|-------|------|
| **274（本 SPEC）** | SPEC-022 + 行ボタン + 子モーダル + generate-connect-copy API + コピー UX |
| P2 | 文案 DB 保存・了承日時監査・`introductions` フィルタ連携（Phase 193） |
| P2 | LINE / Messenger 深連携 |

---

## 9. DoD（Phase 274 implement）

- [ ] 提案各行に「紹介文を作成」ボタン
- [ ] 子モーダルで A/B 手動指定（案2）+ 提案からの初期値
- [ ] `party_b_label` のみでも生成可能
- [ ] 文案ブロック + クリップボードコピー + トースト
- [ ] 121・定例会の両 suggestion 種別で API 動作
- [ ] Feature test（認可・バリデーション・AI モック）
- [ ] `npm run build` + `php artisan test`
- [ ] INDEX / SSOT_REGISTRY / COMMON 参照 / PHASE_REGISTRY / progress 同期

---

## 10. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-07-08 07:57 JST | 初版。案2（A/B 手動指定）確定。MVP コピペ文案・API・UX を定義。 |
