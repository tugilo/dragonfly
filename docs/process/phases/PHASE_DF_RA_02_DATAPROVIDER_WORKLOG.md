# Phase DF-RA-02: DataProvider 最小実装 WORKLOG

## 実装ステップと内容

### Step 0: PLAN 作成

- `docs/process/phases/PHASE_DF_RA_02_DATAPROVIDER_PLAN.md` を作成。

### Step 1: WORKLOG 雛形

- 本ファイル `PHASE_DF_RA_02_DATAPROVIDER_WORKLOG.md` を作成。

### Step 2: dataProvider.js 実装

- **getList(resource, params)**  
  - resource === 'dragonflyFlags' のとき: `GET /api/dragonfly/flags?owner_member_id={params.filter?.owner_member_id || 1}` を fetch。  
  - 返却形式: `{ data: 配列, total: 件数 }`。API が配列をそのまま返すので、data にそのまま設定。
- **update(resource, params)**  
  - resource === 'dragonflyFlags' のとき: `PUT /api/dragonfly/flags/{params.id}` に body と `?owner_member_id=...` で fetch。  
  - 返却: `{ data: 更新後1件 }`。
- **getOne(resource, params)**  
  - resource === 'dragonflySummary' または custom のとき: `GET /api/dragonfly/contacts/{params.id}/summary?owner_member_id=...` を fetch。  
  - 返却: `{ data: summary オブジェクト }`。  
  - 注: ReactAdmin の getOne は resource 名で分岐する。summary 用に resource 名を 'dragonflySummary' 等にし、getOne のみ対応してもよい。
- その他メソッド（getMany, getManyReference, create, delete, deleteMany, updateMany）は未実装でよいか、ダミーで Promise を返す。
- fetch の base URL は相対パス（'' または '/api'）とし、Accept: application/json を付与。

### Step 3: Admin に Resource 仮登録

- `app.jsx` で dataProvider を上記 dataProvider.js の実装に差し替える。
- `<Resource name="dragonflyFlags" list={DummyList} />` を追加。DummyList は `() => { console.log('DummyList mounted'); return <div>Flags (check console)</div>; }` のようなコンポーネントでよい。
- 起動後、dragonflyFlags を開くと getList が呼ばれ、console に API レスポンスやログが出ることを確認。

### Step 4: 接続テスト

- npm run dev で起動し、/admin → dragonflyFlags を開く。
- Console で GET /api/dragonfly/flags の呼び出しとレスポンスを確認。

### Step 5: REPORT 作成・1 commit

- REPORT に変更ファイル・確認方法を記載。
- 1 commit: feat: Phase DF-RA-02 DragonFly DataProvider (getList/update/getOne)
