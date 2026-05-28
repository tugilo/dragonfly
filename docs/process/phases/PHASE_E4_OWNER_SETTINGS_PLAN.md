# PHASE E-4 Owner 設定 — PLAN

**Phase:** E-4（Owner 設定の永続化）  
**目的:** owner_member_id をユーザーごとに選択・保存できるようにし、Dashboard API が owner_member_id 未指定でも動く状態にする。

**SSOT:** docs/SSOT/DASHBOARD_DATA_SSOT.md（owner 決定順は E-4 で更新）

---

## 1. 目的

- **owner_member_id を user 設定として保存**し、Dashboard API のデフォルト owner を user 設定から決める。
- クエリで owner_member_id を渡さなくても、ログインユーザー（または「現在のユーザー」）の owner_member_id を使って Dashboard が動作するようにする。

---

## 2. 禁止事項（絶対遵守）

- **新規基盤を作らない:** ApiResponse / DTO / BaseController / 独自例外 / 独自 middleware / 独自 apiClient 禁止。
- **既存の“正”に完全準拠:** dataProvider.js と同様に fetch + API_BASE='' + Accept: application/json。レスポンスは response()->json($data) の直返し（envelope 禁止）。テストは tests/Feature/Religo/*, RefreshDatabase, getJson 等の既存流儀。
- **変更は Owner 設定に必要な最小範囲のみ。**

---

## 3. 変更範囲（候補）

| 対象 | 内容 |
|------|------|
| **migration** | users に owner_member_id（nullable, unsignedBigInteger）を追加。既存が FK を張らないなら張らない。 |
| **User モデル** | fillable/guarded の既存流儀に従い owner_member_id を更新可能に。casts 等は必要最小限。 |
| **UsersController** | 既存があればそこに owner 更新を追加。無ければ最小で PATCH /api/users/me 等を追加。 |
| **DashboardController / DashboardService** | owner 決定ロジックを「query > user.owner_member_id > 422」に統一。 |
| **Dashboard.jsx** | owner 未設定時は初回設定UI、設定済み時は右上 Owner セレクタ（変更時自動保存）。 |
| **tests** | tests/Feature/Religo/ に owner 設定・Dashboard 既定化のテストを追加/更新。 |
| **docs/SSOT** | DASHBOARD_DATA_SSOT.md の暫定1を解消し、決定順を固定。 |

---

## 4. UI 方針

- **owner 未設定時:** Dashboard 内で「初回オーナー設定」UI を表示（画面上部・ヘッダー下）。Select（members）を出し、選択したら PATCH で保存。保存成功後に stats/tasks/activity を再取得。**別ページは作らない。**
- **owner 設定済み時:** ヘッダー右側に小さな Owner セレクタを表示（控えめ）。変更時に即保存し、保存後に再取得。**ボタンは増やさない（自動保存）。**

---

## 5. API 方針

### 5.1 Dashboard（GET /api/dashboard/*）

- **owner の決定順:**  
  1. リクエストに `owner_member_id` があればそれを使用（互換維持）。  
  2. 無ければ **user.owner_member_id** を使用（新たな正）。  
  3. それも無い（null）場合: **422 Unprocessable Entity** で `message` を返し、初回設定に誘導する。  
  （フォールバックで暫定 1 を使う方針は今回は採用しない。）

### 5.2 Owner 更新 API

- **既存に users 更新 API がある場合:** その PATCH に owner_member_id 更新を追加（Dashboard 専用 API は作らない）。
- **無い場合:** 最小追加。例: **PATCH /api/users/me**  
  - request: `owner_member_id` required, integer, exists:members,id  
  - response: 更新後の user の必要最小限（例: `{ "owner_member_id": 1 }` を直返し）。  
  - 404/422 は既存流儀（`['message'=>...]`、validation errors）。

### 5.3 members 一覧（Owner 選択用）

- **既存 GET /api/dragonfly/members を使用。** パラメータなしまたは owner_member_id 任意で id, name が取れれば足りる。Dashboard 専用エンドポイントは作らない。

---

## 6. テスト観点

- **user.owner_member_id が設定済みのとき:** GET /api/dashboard/stats が query なしで 200 を返す。
- **owner_member_id が未設定（user に null）のとき:** GET /api/dashboard/stats が 422 を返す（message で誘導）。
- **owner 更新 API:** 正しい member_id で 200 となり DB が更新される。
- **不正な owner_member_id（存在しない id 等）:** 422。
- 認証が無い構成の場合は、既存テスト流儀に合わせて「現在ユーザー」の扱い（例: 固定 user id 1）を踏まえて実装する。

---

## 7. DoD（Definition of Done）

- owner_member_id をユーザー設定として保存できる。
- Dashboard API は owner_member_id 未指定でも動く（user.owner_member_id を使用）。
- owner 未設定時は初回設定 UI に誘導できる（422 + message）。
- Dashboard UI で owner を変更でき、保存後に再取得される。
- 既存の正（fetch / 直 json / テスト流儀）に準拠し、新規基盤を作っていない。
- php artisan test / npm run build がすべて通る。
- SSOT（DASHBOARD_DATA_SSOT）が暫定1を脱し、正の決定順が固定されている。

---

## 8. Phase 分割

| Phase | 内容 | push |
|-------|------|------|
| **E-4a** | Docs（本 PLAN + WORKLOG + REPORT） | 1 |
| **E-4b** | Impl（migration, User, API, Dashboard, UI, tests） | 1 |
| **E-4c** | Close（SSOT 更新 + REPORT 証跡確定） | 1 |

各 Phase で `php artisan test` および `npm run build` を実行し、最後に `git diff --name-only` で意図しない変更がないことを確認する。
