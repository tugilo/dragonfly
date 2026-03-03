# DragonFly ReactAdmin 構成設計 v1（SSOT）

**目的:** DragonFly SPA（ReactAdmin + MUI）の画面構成・Resource・Custom Page・DataProvider・状態管理を SSOT として定義する。実装時に迷わない粒度で記載する。  
**参照:** [DRAGONFLY_SPA_REQUIREMENTS_V1.md](../../requirements/dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md)、[DRAGONFLY_DATA_MODEL_V1.md](DRAGONFLY_DATA_MODEL_V1.md)、[DRAGONFLY_API_DESIGN_V1.md](DRAGONFLY_API_DESIGN_V1.md)  
**作成日:** 2026-03-03

---

## 0. 基本構成

- **ReactAdmin** を利用する。  
  List / Create / Edit は Resource ベース、メインの「会議中ボード」は **Custom Page** で実現する。

- **通常 Resource と Custom Page を併用**  
  - Resource: 1on1 セッション一覧・作成・編集、将来は contact events の読み取り専用など。  
  - Custom Page: DragonFlyBoard（3 ペインのメイン画面）。  
  - ルーティングは ReactAdmin の Resource と Custom Route で混在させる。

---

## 1. Resources

| Resource | 説明 | 画面 |
|----------|------|------|
| **oneOnOneSessions** | 1on1 の予定・実施履歴 | list / create / edit。フィルタで owner_member_id・target_member_id・status を指定可能にするとよい。 |
| **contactEvents**（将来） | 理由ログ・関係ログの閲覧 | 読み取り専用の list / show。MVP では省略可。 |

**データソース:** API の GET/POST/PUT `/api/dragonfly/one-on-one` に対応。ReactAdmin の dataProvider で getList / getOne / create / update を実装する。

---

## 2. Custom Page: DragonFlyBoard

**ルート例:** `/dragonfly-board` または `/dragonfly`（既存 MVP の URL と衝突しないよう設定）。

**役割:** 要件の「3 ペイン構成」を実現するメイン画面。会議の参加者一覧・Session1/Session2 の選抜・人物カード（フラグ・メモ・履歴・1on1）を 1 画面で扱う。

### 2.1 3 ペイン構成

| ペイン | 内容 | 主な UI 要素 |
|--------|------|----------------|
| **左** | メンバー検索 ＋ 一覧 | **Autocomplete** または検索フィールド ＋ **List**（または仮想リスト）。参加者（既存 API の attendees）を表示。タップで「選抜」に追加。 |
| **中** | Session1 / Session2 選抜ボード | **タブ**（Session1 / Session2 / All）。選抜されたメンバーを **Chip** で表示。Chip の削除で同室者から外す。保存は既存 API（breakout-assignments）を利用。 |
| **右** | 人物カード | 左または中のメンバーを選択すると表示。**flags トグル**（気になる / 1on1 したい）、**reason 入力**、**履歴表示**（contact history）、**1on1 セクション**（予定 / 実施履歴 / 次アクション）。 |

### 2.2 人物カードの内訳

- **フラグ**  
  interested / want_1on1 のトグル。トグル時に reason を任意入力できる UI（モーダルまたはインライン）。保存は PUT /api/dragonfly/flags/{target_member_id}。整合ルールにより API 側で contact_events に 1 件追加される。

- **理由・履歴**  
  GET /api/dragonfly/contacts/{target_member_id}/history で取得し、直近 N 件を表示。必要なら GET /api/dragonfly/contacts/{target_member_id}/summary の latest_interested_reason / latest_1on1_reason を表示。

- **1on1 セクション**  
  - 予定: status=planned の一覧。予定日＋一言メモ（agenda）の最小入力で追加可能。  
  - 実施履歴: status=done の一覧。日時・memo・next_action を表示。  
  - 次アクション: 直近の next_action を表示・編集。  
  - データ: GET /api/dragonfly/one-on-one?target_member_id=...、POST/PUT で作成・更新。

---

## 3. DataProvider 想定

SPA が利用する API と DataProvider の対応を整理する。ReactAdmin の dataProvider は「Resource 名 → HTTP メソッド」のマッピングに加え、**カスタムメソッド**（getFlags, getContactHistory, getOneOnOneList, getContactSummary 等）を用意する想定。

| データ種別 | API | 用途 |
|------------|-----|------|
| **flags** | GET /api/dragonfly/flags | 人物カード・一覧でのフラグ表示。PUT で更新。 |
| **contacts history** | GET /api/dragonfly/contacts/{id}/history | 人物カードの履歴タブ／リスト。 |
| **one-on-one** | GET/POST/PUT /api/dragonfly/one-on-one | 1on1 Resource と人物カード内 1on1 セクション。 |
| **summary** | GET /api/dragonfly/contacts/{id}/summary | 人物カード表示時の一括取得（同室回数・メモ・フラグ・理由・1on1 サマリ）。 |

既存 API（参加者一覧・同室者・breakout メモ）は既存の dataProvider または別の fetch でそのまま利用する。

---

## 4. 状態管理

- **React Query（TanStack Query）ベース**  
  サーバー状態は React Query で保持。キャッシュキーは owner_member_id、target_member_id、meeting number 等を組み合わせて一意にする。

- **楽観更新（optimistic update）**  
  フラグのトグルや 1on1 の追加・更新では、成功を待たずに UI を先に更新し、失敗時にはロールバックする。スピード体感を損なわないため。

- **debounce 保存（500ms）**  
  メモや reason などのテキスト入力は、入力完了から 500ms 経過後に保存する。連続入力中にリクエストが多重に飛ばないようにする。

---

## 5. MVP 段階の割り切り

- **meeting 199 固定でも可**  
  まずは meeting number を 199 に固定し、参加者一覧・同室者・breakout メモは既存 API の 199 指定でよい。将来、meeting 選択 UI を付ける。

- **owner_member_id は手動選択で可（V1 決定: [D-01](../../decisions/dragonfly/DRAGONFLY_DECISIONS_V1.md)）**  
  ログイン未導入のため、画面のどこか（ヘッダーや設定）で「自分」に該当する参加者（participant）を選択し、その member_id を owner_member_id として全 API に渡す。選択結果は localStorage 等に保持してよい。

---

## 6. 未決事項

- **ReactAdmin のバージョンと Vite の統合**  
  Vite で React をビルドする場合、ReactAdmin の公式 Vite 対応状況に合わせて設定する。未導入のため、プロジェクト構成は実装フェーズで確定。

- **MUI のテーマ**  
  BNI のテンポに合わせた「スピード重視」の配色・タップ領域は MUI の theme で調整。具体的な色・余白は未決。

- **contactEvents Resource の優先度**  
  MVP では人物カード内の「履歴」表示だけで足りるか、一覧専用の contactEvents Resource を先行して作るかは未決。
