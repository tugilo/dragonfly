# ビジター・ゲストの入会、代理出席、Connections の業務・データ方針

**プロダクト:** Religo  
**チャプター（利用文脈の例）:** DragonFly  
**リポジトリ内部名:** dragonfly  

**関連 SSOT:** [CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md](CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md)、[CONNECTIONS_INTELLIGENCE_SSOT.md](CONNECTIONS_INTELLIGENCE_SSOT.md)、[DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md](DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md)（SPEC-005）、[MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md](MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md)、[MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md)、[MEMBERS_DEDUPLICATION_RUNBOOK.md](MEMBERS_DEDUPLICATION_RUNBOOK.md)（SPEC-008・重複・マージ運用）  
**実装参照（例）:** `ImportParticipantsCsvCommand`（CSV 種別マップ）、`MeetingBreakoutService`（BO 保存）、`DragonFlyBoard.jsx`（Connections UI）、`DragonFlyMemberController@index`（メンバー一覧 API）

**状態:** active（業務方針・現行実装の整理。**Phase 0〜6** により Connections / `participants` / `members` の一連整備は完了。左ペインは **5.2**、BO クライアント側ガードは **5.5** を参照）

---

## 0. Phase 0〜6 による整備（到達点）

**Phase 0（前提 SSOT）:** 本書 **SPEC-007** の制定・統合。ビジター／ゲスト／代理・Connections と `participants` の業務・データ方針を単一の参照にまとめる。

そのうえで、**Connections / `participants` / `members` 整備**を **Phase 1〜6** で完了した。対応するリポジトリ Phase ID は次のとおり。

| 内部 Phase | 内容 | Phase ID（記録） |
|------------|------|------------------|
| **Phase 1** | 現状整合調査 | **CONN-PARTICIPANTS-ALIGN-P0** |
| **Phase 2** | BO 保存時 `participant` 必須化（自動生成禁止・422） | **CONN-BO-PARTICIPANT-REQUIRED-P1** |
| **Phase 3** | 左ペインを当該例会の meeting participants に限定 | **CONN-LEFT-PANE-MEETING-P1** |
| **Phase 4** | BO UX ガード整備（保存前・API 表示・BO1→BO2 等） | **CONN-BO-UX-GUARDS-P1** |
| **Phase 5** | `members` 重複の運用 Runbook 制定（**SPEC-008**） | **MEMBERS-DEDUP-RUNBOOK-P0** |
| **Phase 6** | 管理者向け member マージ補助実装 | **MEMBERS-MERGE-ASSIST-P1** |

**これにより次の状態になった（要約）:**

- **BO 対象**は、当該例会の**参加者（`participant` がある）メンバー**に揃え、UI もサーバ制約と一致する。  
- **`participant` は BO 保存で勝手に生成しない**（未参加者は 422・CSV／参加者登録側で事前作成）。  
- **Connections UI と保存制約**が一致（左ペイン・`bo_assignable`・クライアントガード・サーバ 422）。  
- **visitor / guest / member の分裂**に対し、**運用（Runbook・SPEC-008）**と**実装（マージ補助）**の両輪を用意した。

詳細は各節（§3〜§5）および [MEMBERS_DEDUPLICATION_RUNBOOK.md](MEMBERS_DEDUPLICATION_RUNBOOK.md)（SPEC-008）を参照。

---

## 1. 目的

次を **一つの文書** にまとめ、運用・実装・将来改善の議論の共通言語にする。

1. ビジター／ゲストが **メンバーに入会した**ときの `members` / `participants` の扱い  
2. **メンバーの代理出席**（BNI の代理出席者）のデータ上の意味と BO（ブレイクアウト）との関係  
3. **Connections**（会議選択＋BO 割当＋関係ログ）における **メンバー一覧と参加者（participants）** の関係 — **現状実装**と **あるとよい要件**

---

## 2. データモデルの前提（短縮）

| 層 | 役割 |
|----|------|
| `members` | 人物マスタ。`type`（例: `member` / `visitor` / `guest`）、`display_no`（名簿上の No・V1・G1 等）、氏名・カテゴリ等。 |
| `participants` | **ある定例会 1 回**における出席レコード。`meeting_id` + `member_id` で一意。`type` は **その回での立場**（例: `regular` / `visitor` / `guest` / `proxy`）。 |

- **その回でビジターとして出席した**履歴は、`participants.type = visitor` などで表現できる。  
- **`members.type` は「いまのマスタ上の区分」** を表す想定でよい（過去回の `participants.type` と必ずしも一致しない場合がある）。

---

## 3. ビジター・ゲストがメンバーに入会した場合

### 3.1 原則（推奨運用）

- **同一人物は `members.id` を 1 つに保つ。**  
  入会が決まったら、既存の **ビジター行またはゲスト行** を **更新**し、`type` を `member` にし、**正式なメンバー番号**を `display_no` に設定する（カテゴリ・表記ゆれもここで揃える）。

- **過去の定例会**は、既存の `participants` 行をそのまま残してよい。  
  - 当該回では `participants.type` が `visitor` / `guest` のままでも、**「その回はビジターとして出席した」という事実**として正しい。  
  - 画面上で「いまはメンバー」とだけ見せたい場合は、**表示ロジックで `members.type` を優先**する、または **入会日以降の回だけ**表記を変えるなど、**ルールを SSOT か画面仕様で固定**する。

### 3.2 避けたいこと

- **同じ人物に対して `members` を二重登録**しない（検索・紹介者 FK・Connections の相手選びで混乱する）。  
- CSV 再取込で **`(members.type, display_no)` が別組み合わせ**として別行が作られると、同一人物が二重になりうる。入会・名簿確定後は **手作業またはマージ手順**で **1 `member_id` に寄せる**運用を推奨する。

### 3.3 インポート実装との関係（参考）

- **定例会参加者 CSV（`ImportParticipantsCsvCommand`）** の `resolveOrCreateMember` は、コメントどおり **席番（`display_no`）単独を一意キーにしない**。既存行の検索は **`members.type` + `members.name` の完全一致**であり、一致すれば **`display_no` 等を更新**、なければ **新規作成**する。  
  - そのため **visitor/guest から member に区分が変わる**と、`type` が異なるため **別レコードとして新規作成されやすい**（同名でも）。  
- **Meeting CSV import（Apply 系）** や **PDF 候補の Apply** は別実装であり、**resolution / 氏名のみ**等、**経路ごとに合わせ方が異なる**（詳細は [MEMBERS_DEDUPLICATION_RUNBOOK.md](MEMBERS_DEDUPLICATION_RUNBOOK.md) §2）。  
- **意図:** 名簿上の表示番号は回によって変わりうる一方、**人物の同一性**は運用と（将来の）補助機能で担保する（本 SSOT 3.1・**SPEC-008**）。

### 3.4 重複・マージ運用（詳細は SPEC-008）

- **Runbook:** [MEMBERS_DEDUPLICATION_RUNBOOK.md](MEMBERS_DEDUPLICATION_RUNBOOK.md) — 重複発生条件、業務影響、**まず運用で防ぐ**手順、管理画面マージ補助・import 候補提示の**段階案**（大規模自動マージ・推測による同一人物判定は対象外）。  
- **最小マージ補助（実装）:** `RELIGO_MEMBER_MERGE_TOKEN` · `POST /api/admin/member-merge/*` · 管理画面 `/member-merge`（**MEMBERS-MERGE-ASSIST-P1**、Runbook §7.1）。  
- **Phase 記録:** MEMBERS-DEDUP-RUNBOOK-P0（docs 調査）／MEMBERS-MERGE-ASSIST-P1（実装）。

---

## 4. メンバーの代理出席

### 4.1 業務上の意味

- **欠席したメンバーに代わって出席する人物**（代理出席者）。BNI 名簿上はしばしば **ゲスト扱い**や別表記になることがある。

### 4.2 データ上の表現（現行・CSV 取込）

定例会参加者 CSV の **「代理出席」** は、実装上おおむね次の対応になる（CLI / Apply 系と整合）。

| CSV 種別 | `members.type` | `participants.type` |
|----------|------------------|---------------------|
| メンバー | `member` | `regular` |
| ビジター | `visitor` | `visitor` |
| ゲスト | `guest` | `guest` |
| **代理出席** | **`guest`** | **`proxy`** |

- 代理出席者は **マスタ上 `guest`**、当該回の参加区分は **`proxy`** として区別する。  
- **「代理の対象となる欠席メンバー」** を別カラムで保持するかは、CSV 仕様・画面拡張の対象（本書では **必須とはしない**）。必要なら別 SSOT で定義する。

### 4.3 BO（ブレイクアウト）割当との関係（現行実装）

- BO 割当の取得・保存では、**`participants.type` が `absent` または `proxy` の行は BO のメンバー一覧に含めない**（同室計算・保存制約の対象外）。  
- **BO 保存 API**（`MeetingBreakoutService::updateBreakouts`）では、指定した `member_id` に対応する `participant` が **欠席／代理** の場合は **エラー**とし、**割当に含められない**。

**含意:** 代理出席者（`participants.type = proxy`）は **BO の「通常の同室メンバー」集計から除外**される。運用上、代理の方を BO に入れたい場合は **データ設計・仕様の追加検討**が必要（現状は上記制約に従う）。

---

## 5. Connections の要件と「参加者のみ表示」について

### 5.1 画面の役割（整理）

Connections（`DragonFlyBoard`）は、概ね次を満たすことを目的とする（詳細は [CONNECTIONS_INTELLIGENCE_SSOT.md](CONNECTIONS_INTELLIGENCE_SSOT.md) 等）。

- 定例会を選び、**BO 割当**を編集し、**関係ログ**（メモ・1to1 等）へ繋ぐ。  
- 左ペインでは **メンバー候補**を検索し、BO へ割り当てる。

### 5.2 現行実装（事実）

1. **左ペイン（Connections）**は、例会を選択しているとき **`GET /api/dragonfly/members?meeting_id={選択中の meeting.id}&owner_member_id=…&with_summary=1`** で取得する（**CONN-LEFT-PANE-MEETING-P1**）。**当該例会に `participants` 行があり、かつ `participants.type` が `absent` でない人物**のみが返る。欠席者は左ペインに出ない。API は各行に **`participant_type`**（当該例会の出席区分）と **`bo_assignable`**（`proxy` のとき `false`、それ以外は `true`）を付与する。  
   - **例会未選択時**は一覧を空にし、画面上に案内文を出す。  
   - **代理（proxy）**は一覧に含める（区別のため `participant_type`・UI の「代理」チップ・BO 割当 UI 無効）。  
2. **BO 保存**（`PUT /api/meetings/{id}/breakouts` および `PUT .../breakout-rounds`）では、ペイロードの各 `member_id` について **当該例会に `participants` 行が存在すること**が必須。**存在しない `member_id` は 422 で拒否**し、**BO 保存時に `participants` を自動作成しない**（**CONN-BO-PARTICIPANT-REQUIRED-P1**）。`participants` は CSV 取込・参加者登録フローなどで事前に作成する。

### 5.3 要件としての整理（ギャップ追跡用）

| トピック | 推奨する業務要件（検討・採用時） | 現行とのギャップ |
|----------|----------------------------------|------------------|
| 左ペイン | **選択中の定例会に `participant` がある人物だけ**（欠席除く・代理は区別）。 | **実装済み**（`meeting_id` クエリ・API 側で絞り込み）。 |
| BO 保存 | **未参加者の `member_id` を拒否**し、CSV／Meetings 側で先に参加者登録させる運用にする。 | **実装済み（422）**。 |
| Dashboard など | **次の 1to1 候補**から `guest` / `visitor` を除く（SPEC-005）。 | Connections 左ペインとは別要件。 |

### 5.4 表示対象と BO 割当可能の対応（整理）

| participants.type（当該例会） | 左ペイン | BO 割当（UI） | BO 保存（API） |
|------------------------------|----------|---------------|----------------|
| regular / visitor / guest 等（欠席・代理以外） | 表示 | 可（`bo_assignable: true`） | サーバが許可する区分のみ |
| absent | **非表示** | — | 422 |
| proxy | 表示（「代理」表示） | **不可**（`bo_assignable: false`） | 422 |

### 5.5 クライアント側の UX ガード（Connections / DragonFlyBoard）

**目的:** 保存 API を叩く前に、ユーザーが **なぜ割当できないか** を理解できるようにする。サーバ（**5.2** の 422）は最終防衛線として不変。

| レイヤ | 内容 |
|--------|------|
| 操作時 | `toggleRoundMember` / `assignMemberToRoom` / Autocomplete で **割当不可の追加** を拒否し、Snackbar で理由を表示。左ペイン BO メニューは `bo_assignable: false` の **「に追加」** を disabled。 |
| 保存直前 | 全 `member_ids` を `members`（`meeting_id` スコープ）と照合し、問題があれば **PUT しない**（Alert + Snackbar）。 |
| BO1→BO2 コピー | `bo_assignable` に基づき **割当可能 ID のみ** BO2 に複製。除外があれば Snackbar。 |
| API エラー | 422 応答に接頭辞を付けて **Alert** に表示（本文はサーバの `errors.rooms` を継続利用）。 |

実装参照: `www/resources/js/admin/utils/boAssignmentGuards.js`、`DragonFlyBoard.jsx`（**CONN-BO-UX-GUARDS-P1**）。

---

## 6. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-03-31 12:00 JST | 初版。ビジター・ゲスト入会、代理出席、Connections と participants の関係を統合。 |
| 2026-03-31 12:00 JST | 5.2: BO 保存時の participant 自動作成を廃止（実装: CONN-BO-PARTICIPANT-REQUIRED-P1）。 |
| 2026-03-31 12:00 JST | 5.2–5.4: Connections 左ペインを `GET /api/dragonfly/members?meeting_id=` で参加者に限定（CONN-LEFT-PANE-MEETING-P1）。 |
| 2026-03-31 12:00 JST | 5.5: BO 割当のクライアント側ガード（保存前・API 422 表示・BO1→BO2 フィルタ）を追記（CONN-BO-UX-GUARDS-P1）。 |
| 2026-03-31 12:00 JST | 3.3: `ImportParticipantsCsvCommand` の合わせキーを `(type, name)` に修正記載。3.4・SPEC-008 Runbook へリンク（MEMBERS-DEDUP-RUNBOOK-P0）。 |
| 2026-04-20 22:18 JST | 変更履歴の日付に時刻を含める運用を `docs/process/README.md` に明文化。3.4 にマージ補助実装（MEMBERS-MERGE-ASSIST-P1）を反映。 |
| 2026-04-20 22:26 JST | **§0 新設:** SPEC-007 を Phase 0、Connections / participants / members 整備を Phase 1〜6 として整理し到達状態を記載。 |
