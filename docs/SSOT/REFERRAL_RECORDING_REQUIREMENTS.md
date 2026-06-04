# リファーラル記録（外部・内部）要件 — SSOT

**Spec ID:** SPEC-009（[SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md) 参照）  
**ステータス:** active（製品既定: 2026-05-18 Phase 122。DB/API/UI 実装は別 Phase）  
**作成:** 2026-05-18 07:16 JST  
**最終更新:** 2026-05-18 07:25 JST  
**前提:** [PROJECT_NAMING.md](../PROJECT_NAMING.md)（Religo＝プロダクト、DragonFly＝チャプター）、[DATA_MODEL.md](DATA_MODEL.md)（`introductions`・`internal_referrals`）

---

## 1. 目的

Religo の利用者が、BNI 活動における **リファーラル（紹介の実績）** を記録・参照できるようにするための **製品要件** を置く。

- **週次・月次の振り返り**で「つないだ紹介」と「チャプター内で成立したビジネス」を分けて扱えること。
- 将来、ダッシュボード・Connections・レポートで **外部リファーラル件数・内部リファーラル件数（または金額サマリ）** を表示できる足場になること。

API・UI の詳細は実装 Phase で本書および `DATA_MODEL.md` に従う。

---

## 2. 用語

| 用語 | 定義 |
|------|------|
| **リファーラル** | 紹介ネットワーク上の「紹介によって起きた成果」を記録する単位。Religo では最低限 **外部** と **内部** の二種を区別する。 |
| **外部リファーラル（External）** | **人や組織のつなぎ**としての紹介。例: メンバー A の顧客・知人 B を、メンバー C に引き合わせた（A→B を C に紹介、またはオーナーが B と C をつないだ）。**ビジネスがクローズしたかは必須ではない**（紹介のアクション時点で記録してよい）。 |
| **内部リファーラル（Internal）** | **チャプター（workspace）内のメンバー**に対する **サービス・商品の購入・契約など、クローズしたビジネス**の記録。BNI の **TYFCB（Thank You For Closed Business）** に相当する扱いとする。例: メンバー D の税理士サービスを契約した、メンバー E から備品を購入した。 |

**注意:** BNI 公式用語・章での運用ルールが優先する。Religo のラベル（外部／内部）は **アプリ内の分類**であり、章の報告フォーマットと 1:1 で一致させる必要はないが、**運用時に説明可能であること**をゴールとする。

---

## 3. 記録者（オーナー）視点

- 各リファーラル行は **`owner_member_id`（記録しているメンバー）** を持つ。
- **外部（`introductions`）:** オーナーは **紹介行の当事者**（from / to / connector 相当）として既存スキーマに収まる。**最小要件:** `owner_member_id` は「この紹介を記録・追跡する利用者」の軸（現行どおり）。
- **内部（`internal_referrals`） — 製品既定（Phase 122）:**
  - **買い手・売り手は両方 `members` に存在する行**とする（非メンバーからの購買は **P1 では構造化しない**。必要なら `contact_memos` 等の自由記述に委ねる）。
  - **`owner_member_id` は `buyer_member_id` または `seller_member_id` のいずれかと同一**とする（「第三者が他人の取引だけを代理記録」はスコープ外）。
  - **同一取引の二重登録**（買い手・売り手が同じ内容を両方登録）は **排除しない**（運用上はどちらか一方推奨）。将来ユニーク制約を検討可能。

---

## 4. 外部リファーラル — 求める情報（要件レベル）

| 項目 | 必須 / 任意 | 説明 |
|------|-------------|------|
| 種別 | 必須 | `introductions.referral_kind` は **`external`**（既定。既存行の解釈も外部）。 |
| つなぎの事実 | 必須 | 誰と誰を（または誰を誰に）つないだかを説明できること。相手が `members` にいない場合は **氏名・会社名等のテキスト**でよい（構造化は Future）。 |
| 日付 | 推奨 | 紹介日など。`created_at` を第一安定ソースとし得る。 |
| 関連メンバー | 条件付き | チャプター内メンバーについては `members.id` への参照が **できればよい**（ゲスト・未登録はテキストで補足）。 |
| メモ | 任意 | 業種・ニーズ・フォロー状況など。 |
| 例会 | 任意 | `meeting_id` で紐づけ可能（現行どおり）。 |

**現行データモデル:** [DATA_MODEL.md](DATA_MODEL.md) セクション 4.13 `introductions`。

---

## 5. 内部リファーラル — 求める情報（要件レベル）

| 項目 | 必須 / 任意 | 説明 |
|------|-------------|------|
| テーブル | — | **`internal_referrals` のみ**（`introductions` へ内部を格納しない）。 |
| 記録者 | 必須 | `owner_member_id`（買い手または売り手と同一）。 |
| 売り手 | 必須 | `seller_member_id` → `members.id` |
| 買い手 | 必須 | `buyer_member_id` → `members.id` |
| 概要 | 必須 | `summary`（何を購入・契約したか）。 |
| 成立日 | 推奨 | `closed_on`（date、nullable 可・UI で推奨） |
| 金額 | 任意 | `amount_yen`（**整数・税込・ユーザー申告**、nullable）。 |
| メモ | 任意 | `notes` |

**データモデル詳細:** [DATA_MODEL.md](DATA_MODEL.md) セクション 4.14。

---

## 6. 表示・集計（製品レベルの期待）

- **一覧:** 外部／内部でフィルタできること（将来）。  
- **ダッシュボード（現行）:** KPI 「**リファーラル件数（今月）**」は **紹介メモ（`contact_memos.memo_type = introduction`）の件数**（[DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md) の `monthly_intro_memo_count`）。**`introductions` / `internal_referrals` 連動は実装 Phase 後に拡張。**  
- **ダッシュボード（将来）:** `introductions` / `internal_referrals` に基づく **外部・内部の分解 KPI**。  
- **派生指標:** `introduction_count` / `last_introduction` / `last_contact_at` は **introductions のみ**（内部テーブルは含めない）。**Introduction Hint** にも **内部リファーラルを含めない**（Phase 122 既定）。

---

## 7. 権限・プライバシー — 製品既定（Phase 122）

- **内部リファーラルの API（当面）:** **CRUD は `owner_member_id` = ログインユーザーの `owner_member_id` の行に限定**する。他メンバー一覧で金額を晒す **TYFCB オープンボード**は別 Phase。
- **金額:** 入力は任意。表示対象は上記と同じく **本人オーナー行からのみ**開始する。
- **編集権限:** 原則 **記録者（owner）のみ**。
- **認証導入後:** 「ログインユーザーに紐づく `owner_member_id`」の解決と API 全体の整合は **SPEC-010**（[AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md](AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md)）を正とする。

---

## 8. 非目標（当面）

- 章の公式報告フォームとの自動連携。  
- 外部 CRM との同期。  
- 紹介の「パイプライン段階」（見込み・商談・失注）の詳細ステートマシン。

---

## 9. 製品既定（Phase 122 で確定した回答）

以下は [Phase 122 WORKLOG](../process/phases/PHASE_122_REFERRAL_SPEC009_DATAMODEL_WORKLOG.md) に沿って確定した。

| # | 論点 | 既定 |
|---|------|------|
| 1 | 内部の買い手 | **メンバー行を必須**（`buyer_member_id`）。非メンバー購買は構造化しない。 |
| 2 | 金額 | **任意**。`amount_yen`・整数円・税込申告。**閲覧は当面 owner 行のみ**から開始。 |
| 3 | 既存 `introductions` | **すべて外部**とみなす。列 `referral_kind` default **`external`**。内部は別テーブルのみ。 |
| 4 | `last_contact_at` / Introduction Hint | **内部リファーラルは含めない**。 |

---

## 10. 実装後続（別 Phase）

- **Phase 123 で実施済み:** `introductions.referral_kind`、`internal_referrals` テーブル、`GET|POST|PATCH` API（owner スコープ）、`MemberMergeService` への参照更新、Feature テスト。
- **未着手:** 管理画面 UI（一覧・フォーム）、Dashboard KPI と `introductions` / 内部件数の連動、workspace 全体 TYFCB ボード・閲覧ポリシー拡張。
- **121 起点の提案（SPEC-015）:** [ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md](ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md) — 1 to 1 一覧の「リファーラル」ボタンから提案モーダル。採用時に `introductions` へリンクし、どの 121・どの議事録版から生まれたかを `one_to_one_referral_suggestion_*` で保持（実装 Phase B 以降）。
- **定例会起点の提案（SPEC-016）:** [CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md](CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md) — Meetings から MP 等を素材に提案。採用時 `introductions.meeting_id` をセット。`meeting_referral_suggestion_*` で run 保持。共通: [REFERRAL_SUGGESTION_COMMON.md](REFERRAL_SUGGESTION_COMMON.md)。

---

## 11. 関連ドキュメント

- [DATA_MODEL.md](DATA_MODEL.md) — `introductions`、`internal_referrals`、派生指標  
- [CONNECTIONS_REQUIREMENTS.md](CONNECTIONS_REQUIREMENTS.md) — Relationship Log との表示統合の検討余地  
- [DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md) — KPI 定義の将来更新  
- [INTRODUCTION_HINT_SSOT.md](INTRODUCTION_HINT_SSOT.md) — Hint に内部を含めない
