# 1 to 1 Create 画面 UX 改善 — 要件整理（SSOT）

**作成日:** 2026-03-23  
**ステータス:** 要件整理（**実装は未着手**）  
**種別:** UX / 画面要件 SSOT（implement Phase の PLAN 入力用）

**関連:** [DATA_MODEL.md](DATA_MODEL.md) §4.12（`one_to_ones`）、[FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §6（ONETOONES-P3）、`www/resources/js/admin/pages/OneToOnesCreate.jsx`・`OneToOnesFormParts.jsx`

---

## 1. 背景・目的

管理画面の **1 to 1 登録**（`/admin#/one-to-ones/create`）において、次の体験課題がある。

1. **相手（target）を選んだだけでは**、その人の文脈（所属・役職・連絡先など）が見えず、登録前の確認がしづらい。
2. **予定日時・開始日時・終了日時**を別々に入力するのが負担。運用上は「いつから」「どれくらい」が分かれば足りる場面が多い。
3. **例会（`meeting_id`）は任意**だが、**数値 ID のみ**の入力では、どの例会か判断できず実質不可能に近い。

本ドキュメントは、上記を満たす **製品要件** と **現状実装との差分**・**決めるべき論点**を整理する。

---

## 2. 現状実装（調査時点）

| 領域 | 実装 |
|------|------|
| 相手 | `OwnerScopedTargetSelect`：`GET /api/dragonfly/members?owner_member_id=` の **Select**（表示は `#番号 名前` のみ）。選択後の追加情報なし。 |
| 日時 | `DateTimeInput` ×3：`scheduled_at` / `started_at` / `ended_at`。いずれも任意入力。 |
| 例会 | `NumberInput`：`meeting_id`（ラベル「Meeting ID（任意）」）。一覧・検索なし。 |
| API | `POST /api/one-to-ones`（`StoreOneToOneRequest`）：上記フィールドをそのまま受け付け。 |

**補足:** クイック作成 Dialog（一覧）や Edit 画面は別コンポーネントだが、**Create と同様の課題を共有**する。実装 Phase では **Create を優先**し、Edit / Dialog は **同方針で追随**することを推奨する。

---

## 3. 要件（機能別）

### 3.1 相手選択時に相手の情報を見られること

**ゴール:** `target_member_id` 確定後（または選択中のホバー等）、**登録判断に足るサマリ**が画面上で確認できる。

**表示したい情報の候補（優先度は実装 Phase で確定）:**

| 優先 | 内容 | データソース案 |
|------|------|----------------|
| 高 | 氏名・会内番号（`display_no`） | 既存 members 一覧 API と同じ |
| 高 | カテゴリ・役職・会社名など、一覧で既に使っている属性 | `GET /api/dragonfly/members/{id}`（`show`）の応答フィールド |
| 中 | 直近の関係サマリ（同室回数・最終接触・1to1 回数等） | `summary_lite` 等が show に含まれるなら表示。含まれない場合は **別 API 追加要否**を Phase で判断 |

**UI 案:**

- 相手 `Select` の直下（または横）に **読み取り専用パネル**（Typography / Card）で表示。
- 未選択時は非表示またはプレースホルダ。
- 相手変更時に **再取得**（キャッシュはセッション内で可）。

**非目標（本要件では必須としない）:**

- メンバー全文検索の高度化（別 Phase）。
- 相手の編集画面への遷移（あれば「詳細を開く」リンク程度は任意）。

---

### 3.2 予定日時＋所要時間で終了予定時刻まで入ること

**ゴール:** ユーザーは **予定の開始日時を 1 回**入れ、**30 / 60 / 90 分**などの所要時間を選ぶと、**終了予定の日時**が自動で埋まる。手入力の負担を減らす。

**フィールド対応（論点込みのたたき台）:**

| DB/API フィールド | 想定する意味（改善後） |
|---------------------|-------------------------|
| `scheduled_at` | **予定開始**（ユーザーが入力する主たる日時）。 |
| `ended_at` | **予定終了**＝`scheduled_at` + 選択した所要時間（分）。**クライアントまたはサーバで算出**して保存。 |
| `started_at` | **実績の開始**。**予定登録フローでは入力させない**（空のまま）か、**折りたたみ「実績を入力」**に退避。 |

**所要時間の UI:**

- プリセット：**30 / 60 / 90 分**を最低限（チップ・トグル・Select いずれか）。
- **任意分数**（例: 15 分刻み、自由入力）を Phase で追加するかは **要否判断**。

**ステータスとの関係:**

- `status = planned` のときは **上記「予定開始＋所要→終了予定」**を主導線とする。
- `completed` で実績の `started_at` / `ended_at` を別途厳密に入れたい場合は、**編集画面**や **二段フォーム**で扱うか、本要件のスコープ外として切り分ける（**要決定**）。

**バリデーション:**

- `ended_at` > `scheduled_at` を満たすこと（同一分は不可など細部は Phase で定義）。
- サーバ側 `StoreOneToOneRequest` / `UpdateOneToOneRequest` との **整合**（フロントのみ自動埋めでもサーバは nullable のまま許容できるか）。

---

### 3.3 例会（Meeting）は ID 直打ちではなく選べること

**ゴール:** **任意**の例会紐付けについて、**番号・開催日・名称**が分かる形で選べる。数値 ID のみの入力はやめる（または上級者向けに非表示）。

**UI 案:**

- `GET /api/meetings`（既存 `dataProvider` の meetings 一覧）から **Autocomplete または Select**。
- 各行ラベル例：`第{number}回` / `{held_on}` / `{name}`（既存一覧・Drawer と同系の表記に合わせる）。
- **未選択**＝ `meeting_id` null を維持。
- Owner / workspace で絞る必要があるかは **API の仕様確認**（現行 `GET /api/meetings` が全件か、workspace スコープか）。

**検索:** 件数が多い環境では **番号・日付での絞り込み**を検討（別タスク化可）。

---

## 4. 非機能・整合性

| 項目 | 内容 |
|------|------|
| **モック** | `religo-admin-mock-v2` の 1to1 追加は「関連例会（任意）」として **select 想定**。改善後は **Partial Fit の解消**に寄与。差分は [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §6 を更新。 |
| **テーマ** | [ADMIN_UI_THEME_SSOT.md](ADMIN_UI_THEME_SSOT.md) に沿ったコンポーネント（Chip、Autocomplete、spacing）。 |
| **API 変更** | 必須ではない。日時は既存の `scheduled_at` / `ended_at` に **計算結果を載せる**だけで足りる可能性が高い。メンバー表示は **既存 `show`** で足りるか確認。足りなければ **クエリパラメータ拡張**や **軽量 DTO** を Phase で設計。 |
| **Edit / 一覧クイック作成** | 同じコンポーネント化（共有フォームパーツ）を推奨し、**挙動の一貫性**を保つ。 |

---

## 5. 未決定事項（実装 Phase で PLAN に落とす）

1. **相手サマリの必須フィールド**（show API のどのキーまで表示するか、ローディング・エラー表示）。
2. **`started_at` を Create で非表示にするか**、実施済み登録時のみ出すか。
3. **所要時間のプリセット以外**（カスタム分）を MVP に含めるか。
4. **例会一覧のスコープ**（workspace / 全件）と、パフォーマンス（ページング）。
5. **タイムゾーン**（`app.timezone` 基準で統一は既存どおりか明示）。

---

## 6. 実装完了の判断（DoD 案）

- [ ] Create で相手選択後、**意図したサマリ**が表示される（仕様で定義した項目が埋まっている）。
- [ ] **予定開始＋所要時間**で `ended_at`（終了予定）が設定され、**3 つの日時をすべて手で触らなくてよい**デフォルト動線がある。
- [ ] **例会は一覧から選択**でき、ID 直打ちに依存しない（上級者向け ID 入力を残すかは製品判断）。
- [ ] `POST /api/one-to-ones` が **既存契約を壊さず**動く（必要なら Request の docblock・SSOT 更新）。
- [ ] `npm run build` 成功・関連 Feature テスト・手動で Create 一通り。

---

## 7. 参照（コード）

- `www/resources/js/admin/pages/OneToOnesCreate.jsx`
- `www/resources/js/admin/pages/OneToOnesFormParts.jsx`（`OwnerScopedTargetSelect`）
- `www/app/Http/Requests/Religo/StoreOneToOneRequest.php`
- `GET /api/dragonfly/members/{id}` — `DragonFlyMemberController::show`
- `GET /api/meetings` — 例会一覧（dataProvider `meetings`）
