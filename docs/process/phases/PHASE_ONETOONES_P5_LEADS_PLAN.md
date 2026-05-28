# PLAN: ONETOONES-P5（導線設計 — Members / Dashboard 連携）

| 項目 | 内容 |
|------|------|
| Phase ID | **ONETOONES-P5** |
| 種別 | implement |
| Related SSOT | `docs/process/ONETOONES_P1_P4_SUMMARY.md`、`docs/SSOT/DATA_MODEL.md`（`one_to_ones`・`dragonfly_contact_flags`）、`docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` §4・§6 |
| 前提 | ONETOONES P1〜P4 完了。一覧・stats・memos・`/api/users/me` 安定。**データモデル・マイグレーションは原則変更しない**（UI / 導線・最小 API 追加） |
| ブランチ（想定） | `feature/phase-onetoones-p5-leads` |

---

## 1. ゴール（tugilo 要約）

**「次にやるべき 1 to 1 が自然に見える状態」**

「記録する仕組み」→ **「行動を生む仕組み」** への転換。  
**「誰と話すべきか」をシステムが手がかりとして示す**（AI・スコア化は P6 以降）。

---

## 2. 解決したい課題（現状）

- 1 to 1 は「探しに行くもの」になりがち
- 未実施の相手が埋もれる
- stats はあるが **次の行動** に直結しにくい

---

## 3. スコープ

### 対象

- Members 一覧（`MembersList.jsx`）・Member 詳細（`MemberShow.jsx`）
- Dashboard（`Dashboard.jsx`）
- 既存 `one-to-ones` / `dragonfly` API（**破壊的変更なし**、追記最小）

### 対象外

- AI 提案、メモスレッド化、権限・RBAC 本格化、モック完全一致

---

## 4. 機能要件

### F1: Members → 1 to 1 作成導線

- **場所:** `MembersList` の行アクション、および `MemberShow` ヘッダー付近。
- **ラベル例:** 「1to1 する」「ミーティング記録」など（短く・1 クリック）。
- **動作:** `OneToOnesCreate` へ遷移し、**`target_member_id` をクエリまたは state で初期値**。**`owner_member_id`** は `GET /api/users/me`（既存 `religoOwnerMemberId` 等）と整合。
- **実装注意:** react-admin の `Create` は `defaultValues` を URL クエリと組み合わせるか、専用ラッパーで `location.search` を読む。

### F2: Members にステータス表示（軽量）

各メンバー（一覧または詳細）に対し、**オーナー文脈**で:

| 表示 | 条件（案・要 PLAN 確定時に SSOT 化） |
|------|-------------------------------------|
| 未実施 | 当該 owner→target の **completed 相当の 1 to 1 が 0 件**（`status=completed` のみを「実施」とみなすか、P5 で固定） |
| 要対応 | 上記以外で **最終実施日が 30 日より前**（`app.timezone` 基準） |
| 実施済 | 直近に実施あり |

**データ:** 既存テーブルのみ。`last_one_to_one` 相当の算出は `DATA_MODEL` の派生指標と整合（`canceled` 除外ルール等は Index/Stats と揃える）。

### F3: Dashboard「次に 1 to 1 すべきメンバー」

- **新規セクション**（例: `NextOneToOnesPanel`）。
- **表示:** `target` 名、最終実施日、ステータス、**「作成」ボタン**（F1 と同じ遷移規約）。
- **並び（推奨）:**  
  1. 未実施  
  2. 要対応（古い順）  
  3. 実施済（折りたたみ or 末尾・省略可）

### F4: `want_1on1` 優先

- `dragonfly_contact_flags.want_1on1 = true` の行を **Dashboard リストで上位**、**バッジ**（例: ★）表示。
- Members 側でも Chip 等で併記可能（F2 と統合してよい）。

---

## 5. API 設計（案 A：最小追加・推奨）

**新規（例）**

```http
GET /api/dragonfly/members/one-to-one-status?owner_member_id={required}
```

**ルート順:** `GET …/members/one-to-one-status` を **`GET …/members/{id}` より上**に定義（Laravel の静的セグメント優先）。

**応答イメージ**

```json
[
  {
    "member_id": 1,
    "name": "xxx",
    "last_one_to_one_at": "2026-03-01",
    "status": "none|needs_action|ok",
    "want_1on1": true
  }
]
```

- **判定:**  
  - `completed` 件数 0 → `none`（未実施）  
  - それ以外で `last_at < now - 30 days` → `needs_action`  
  - それ以外 → `ok`  
  （`last_at` の定義は `OneToOneIndexService` / SSOT の「直近 1 to 1」に合わせる）

- **Members 一覧が既に owner 付きで取得している場合:** オーバーヘッド削減のため、**既存 index にオプション query** でフラットに足す案 B を WORKLOG で比較可（破壊なし必須）。

---

## 6. フロント実装タスク

| ファイル | 内容 |
|----------|------|
| `MembersList.jsx` | F1 ボタン、F2 / F4 Chip（データは API または既存 summary 拡張） |
| `MemberShow.jsx` | F1 ヘッダー、最終実施表示 |
| `Dashboard.jsx` | `NextOneToOnesPanel`（F3・F4） |

**UX 原則**

- 「考えなくても次が分かる」
- 1 クリックで行動、状態が一目で分かる
- 複雑フィルタ・重い遷移・モック完全再現はやらない

---

## 7. 実装順序（推奨）

1. **Step1:** `one-to-one-status` API（コントローラ・サービス・Feature テスト）
2. **Step2:** Dashboard `NextOneToOnesPanel`
3. **Step3:** Members 一覧に「1 to 1 作成」ボタン
4. **Step4:** ステータス / want バッジ表示の統合
5. **Step5:** 文言・閾値（30 日）・空状態の微調整

---

## 8. DoD（完了条件）

### 機能

- Members から 1 to 1 作成へ **`target` 初期付き**で辿れる
- Dashboard に「次に 1 to 1 すべきメンバー」リストがある
- `want_1on1` が**優先・視認**される

### 技術

- 既存 API の**後方互換**維持
- `php artisan test` 全通過、`npm run build` 成功

### ドキュメント

- 本 PLAN／`PHASE_ONETOONES_P5_LEADS_WORKLOG.md`／`PHASE_ONETOONES_P5_LEADS_REPORT.md`
- `PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md`
- 必要なら `FIT_AND_GAP` または `DATA_MODEL` に判定ルール 1 段落

---

## 9. 次 Phase（参考・未コミット）

- **P6:** AI 提案（「次に話すべき理由」）
- **P7:** 関係性スコアと営業・紹介導線

---

## 10. Cursor 向け短縮プロンプト（コピペ用）

```text
Phase ONETOONES-P5: Members/Dashboard から 1 to 1 行動導線。データモデル変更不要。
Implement GET /api/dragonfly/members/one-to-one-status?owner_member_id=（/{id} より上にルート）。
判定: 未実施 / 要対応(30日) / 実施済、want_1on1 付与。Dashboard NextOneToOnesPanel、MembersList/MemberShow に作成ボタン（OneToOnesCreate へ target 初期値）。
DoD: 既存API非破壊、php artisan test、npm run build、PLAN/WORKLOG/REPORT・REGISTRY・INDEX・progress 更新。
参照: docs/process/phases/PHASE_ONETOONES_P5_LEADS_PLAN.md
```
