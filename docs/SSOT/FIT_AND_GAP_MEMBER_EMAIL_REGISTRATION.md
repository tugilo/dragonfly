# Fit & Gap — メンバーのメールアドレス登録機能

**作成:** 2026-06-27 12:55 JST  
**状態:** active（調査結果の正）  
**関連 SSOT:** SPEC-010（AUTH_LOGIN_AND_OWNER_BINDING）、SPEC-011（AUTH_REGISTRATION_EMAIL）、[TEST_USER_ONBOARDING_FLOW.md](TEST_USER_ONBOARDING_FLOW.md)、[ONBOARDING_AND_ACCOUNT_PROVISIONING.md](ONBOARDING_AND_ACCOUNT_PROVISIONING.md)  
**目的:** テストユーザー追加に必要な「管理者がメンバーごとに email を登録する機能」が実装済みか、層別に検証する

---

## 1. 結論

**メールアドレス登録機能は実装済み。** UI・データプロバイダ・API・バリデーション・テストの全層が揃っており、`chapter_admin` が Members 編集画面から登録できる。新規実装は不要。

唯一の Gap は **Members 一覧/詳細ドロワーからの直接編集導線がない**（編集画面まで遷移が必要）という UX 上の軽微な点のみ。機能要件としては充足。

---

## 2. 検証範囲（全層）

```
[管理画面 UI]  MemberEdit.jsx（email 入力欄）
      │ react-admin update('members')
      ▼
[DataProvider]  dragonflyDataProvider.update → PUT /api/dragonfly/members/{id}
      │
      ▼
[ルート]  routes/api.php（religo.chapter_admin 配下）
      │
      ▼
[コントローラ]  DragonFlyMemberController::update（email 反映・バリデーション）
      │
      ▼
[DB]  members.email
```

---

## 3. 層別 Fit & Gap

| # | 層 | 期待 | 実装 | 判定 | 参照 |
|---|----|------|------|------|------|
| 1 | UI 入力欄 | email を入力・保存できる欄 | `MemberEdit.jsx` `TextInput source="email"`（ラベル「メール（連絡先）」） | **Fit** | `www/resources/js/admin/pages/MemberEdit.jsx` L32-37 |
| 2 | UI 権限分離 | 一般 member には編集画面を出さない | `app.jsx` `edit={isAdmin ? MemberEdit : undefined}` | **Fit** | `www/resources/js/admin/app.jsx` L74 |
| 3 | 編集導線 | 一覧→詳細→編集で到達 | Members 一覧 → 詳細（Show）→ `EditButton` | **Fit** | `MemberShow.jsx` L211-216（`MemberShowActions`） |
| 4 | DataProvider | update が PUT /members/{id} を呼ぶ | `update('members')` → `PUT /api/dragonfly/members/{id}`（`params.data` 全体送信） | **Fit** | `dataProvider.js` L251-257 |
| 5 | ルート権限 | 編集系は admin 限定 | `Route::middleware('religo.chapter_admin')` 配下に `PUT /dragonfly/members/{id}` | **Fit** | `routes/api.php` L289-290 |
| 6 | API 反映 | email を保存し返す | `DragonFlyMemberController::update` が `email` を反映・レスポンスに含む | **Fit** | `DragonFlyMemberController.php` L233-239 |
| 7 | バリデーション | 形式・重複チェック | `email:rfc` + 同一 workspace 内 `unique`（自分は除外） | **Fit** | 同 L276-293 `nullableMemberEmailRules` |
| 8 | 一覧取得 | email を返す | index の select に `email` を含む | **Fit** | 同 L49 |
| 9 | テスト | 設定・重複・別WS・index | `DragonFlyMemberEmailTest`（4 ケース） | **Fit** | `tests/Feature/Api/DragonFlyMemberEmailTest.php` |
| 10 | 一覧/ドロワー編集 | その場で email 編集 | ドロワーは Nキャス URL のみ。email は編集画面のみ | **Gap（軽微）** | `MembersList.jsx` L1147-1169 |

---

## 4. 実装詳細

### 4.1 UI（MemberEdit）

```33:37:www/resources/js/admin/pages/MemberEdit.jsx
                <TextInput
                    source="email"
                    label="メール（連絡先）"
                    fullWidth
                    helperText="ログイン・招待用。チャプター内で重複できません（SPEC-010）。未使用なら空欄。"
```

- `chapter_admin` のみ Member 編集画面（`MemberEdit`）が描画される（`app.jsx`）。
- 一般 member はそもそも編集画面に遷移できない（Resource の `edit` が `undefined`）。

### 4.2 DataProvider（members.update）

```251:257:www/resources/js/admin/dataProvider.js
        if (resource === 'members') {
            const data = await request(`/api/dragonfly/members/${params.id}`, {
                method: 'PUT',
                body: JSON.stringify(params.data),
            });
            return { data };
        }
```

- フォームの全フィールド（`email` を含む）を `PUT /api/dragonfly/members/{id}` に送信。

### 4.3 API（DragonFlyMemberController::update）

```233:239:www/app/Http/Controllers/Api/DragonFlyMemberController.php
        if (array_key_exists('email', $request->all())) {
            $request->validate([
                'email' => self::nullableMemberEmailRules($member),
            ]);
            $raw = $request->input('email');
            $member->email = ($raw !== null && $raw !== '') ? (string) $raw : null;
        }
```

- `email` が来たときのみ反映。空文字は `null` に正規化。

```276:293:www/app/Http/Controllers/Api/DragonFlyMemberController.php
    private static function nullableMemberEmailRules(Member $member): array
    {
        return [
            'nullable',
            'string',
            'max:255',
            'email:rfc',
            Rule::unique('members', 'email')
                ->ignore($member->id)
                ->where(function ($query) use ($member) {
                    if ($member->workspace_id === null) {
                        $query->whereNull('workspace_id');
                    } else {
                        $query->where('workspace_id', $member->workspace_id);
                    }
                }),
        ];
    }
```

- 同一チャプター（workspace）内での重複を禁止。別チャプターでは同一 email を許容。

### 4.4 ルート（admin 限定）

```289:290:www/routes/api.php
    Route::middleware('religo.chapter_admin')->group(function () {
        Route::put('/dragonfly/members/{id}', [DragonFlyMemberController::class, 'update'])->whereNumber('id');
```

### 4.5 テスト

`DragonFlyMemberEmailTest`（`chapter_admin` で実行）:

- `test_put_sets_and_returns_email` — 設定・返却
- `test_put_rejects_duplicate_email_in_same_workspace` — 同一WS重複 422
- `test_put_allows_same_email_in_different_workspace` — 別WS許容
- `test_index_includes_email_in_select` — 一覧で email 返却

---

## 5. Gap と推奨対応

| Gap | 内容 | 影響 | 推奨 | 優先度 |
|-----|------|------|------|--------|
| G1 | Members 一覧/詳細ドロワーから email を直接編集できない（編集画面まで遷移が必要） | テスト配布で複数名 email を入力する際、画面遷移が多くやや手間 | ドロワーに email インライン編集を追加（`putDragonflyMember` 既存・Nキャス URL と同型で実装可） | Could |
| G2 | email 一括登録（CSV 等）がない | 大量整備時に 1 名ずつ手入力 | 将来 CSV インポートに email 列を追加（既存 CSV 基盤あり） | Could |
| G3 | email 登録から登録案内メール送付までが手動 | 招待リンク方式ではない | 自己登録で代替（SPEC-011）。招待リンクは将来 | Could |

いずれも **MVP・テスト配布には不要**。少人数（5〜10 名）なら現状の編集画面で十分。

---

## 6. テスト配布での実務手順（確認済み）

1. `chapter_admin`（次廣）でログイン
2. **👥 Members** → 対象メンバー → **詳細** → **編集**
3. **メール（連絡先）** に入力 → 保存（同一チャプター重複不可）
4. 以降は [TEST_USER_ONBOARDING_FLOW.md](TEST_USER_ONBOARDING_FLOW.md) の自己登録フローへ

---

## 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-06-27 12:55 | 初版。email 登録機能を UI/DataProvider/API/バリデーション/テストの全層で検証。Fit 多数・Gap は一覧ドロワー編集のみ（軽微） |
