# Phase DF-BOARD-01: DragonFlyBoard MVP WORKLOG

## 実装ステップと内容

### Step 0: PLAN 作成

- `docs/process/phases/PHASE_DF_BOARD_01_MVP_PLAN.md` を作成。

### Step 1: members API 追加（既存を壊さない）

- `DragonFlyMemberController::index` を追加。GET /api/dragonfly/members で members の id, display_no, name, name_kana, category を返す。
- `routes/api.php` に `Route::get('/dragonfly/members', ...)` を追加。

### Step 2: DragonFlyBoard.jsx 作成

- MUI Grid container。左: Autocomplete（options は GET /api/dragonfly/members で取得、option label は display_no + name 等）。
- 右: 選択した member の summary カード。target_member_id が決まったら GET /api/dragonfly/contacts/{id}/summary?owner_member_id=... で取得し表示。
- owner_member_id は暫定で state（初期値 1）または入力欄で変更可能にする。
- Summary カード内に interested / want_1on1 の MUI Switch または Toggle を配置。変更時に PUT /api/dragonfly/flags/{target_member_id} を呼び、成功したら summary を再取得。

### Step 3: flags 更新連動

- Toggle 変更 → PUT /flags（body: interested または want_1on1）。
- 成功後 → GET summary で再取得し state を更新。

### Step 4: Admin に Custom 登録

- Admin の customRoutes で /dragonfly-board を DragonFlyBoard にマッピング。または Resource ではなく Custom の MenuItem で Board を表示し、クリックで DragonFlyBoard を表示する。

### Step 5: テスト・REPORT・1 commit

- summary 表示、interested ON/OFF 即反映、console error なしを確認。
- REPORT 作成、1 commit。
