# PHASE CONN-PARTICIPANTS-ALIGN-P0 — REPORT（調査・実装前）

| 項目 | 内容 |
|------|------|
| **Phase ID** | CONN-PARTICIPANTS-ALIGN-P0 |
| **種別** | docs（**コード変更なし**） |
| **Related SSOT** | SPEC-007 — [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) |

---

## 1. 現状挙動（コード根拠）

### 1.1 BO 保存時の participant 自動生成

**箇所 A — レガシー BO1/BO2（meeting_id 直結ルーム）**

- `App\Services\Religo\MeetingBreakoutService::updateBreakouts`  
  - `Participant::firstWhere(['meeting_id' => $meeting->id, 'member_id' => $memberId])` が **null** のとき、`Participant::create(['meeting_id', 'member_id', 'type' => 'regular'])` を実行する（L88–104）。  
- 入口: `PUT /api/meetings/{meetingId}/breakouts` — `App\Http\Controllers\Religo\MeetingBreakoutController::update` → 上記サービス。  
- リクエスト検証: `App\Http\Requests\Religo\UpdateMeetingBreakoutsRequest` — `member_ids.*` は `exists:members,id` のみ（**participant 存在は不要**）。

**箇所 B — 複数 Round（breakout_rounds 配下）**

- `App\Services\Religo\MeetingBreakoutRoundsService::updateBreakoutRounds`  
  - 各 round の各 `member_id` について同様に `firstWhere` → なければ `Participant::create(..., 'type' => 'regular')`（L127–143）。  
- 入口: `PUT /api/meetings/{meetingId}/breakout-rounds` — `MeetingBreakoutRoundsController`。

**UI（Connections）**

- `www/resources/js/admin/pages/DragonFlyBoard.jsx`  
  - `saveRounds` が `putMeetingBreakouts(selectedMeetingId, payload)` を呼ぶ（`putMeetingBreakouts` → `PUT /api/meetings/${meetingId}/breakouts`）。  
  - **Round API は未使用**（取得も `getMeetingBreakouts` = `GET .../breakouts` のみ）。

### 1.2 Connections 左ペインが「全 members」になる箇所

- `DragonFlyBoard.jsx` の `refetchMembers`（`useCallback`）が  
  `GET /api/dragonfly/members?owner_member_id=${ownerMemberId}&with_summary=1` を呼び、`setMembers` にそのまま格納する（L246–250）。  
- `useEffect` で `selectedMeetingId` 変更時に **メンバー一覧を再取得していない**（会議選択は `getMeetingBreakouts` のみトリガ）。  
- `App\Http\Controllers\Api\DragonFlyMemberController::index` は `Member::query()` 起点で、`meeting_id` による **participant 絞り込みは無い**（検索・フラグ・ソートのみ）。

### 1.3 BO 保存時の absent / proxy

**GET（表示）**

- `MeetingBreakoutService::getBreakouts` / `MeetingBreakoutRoundsService::getBreakoutRounds`  
  - ルームの `participants()` リレーションに対し `->whereNotIn('type', ['absent', 'proxy'])` して `member_id` を取得（例: `MeetingBreakoutService` L32–35）。  
  - つまり **absent/proxy の participant は BO の member_ids に載らない**。

**PUT（保存）**

- 上記両サービスとも、既存 `participant` があり **`type` が `absent` または `proxy`** の場合は `ValidationException`（422）で拒否（例: `MeetingBreakoutService` L92–97）。  
- **participant が存在しない** `member_id` は **create され `regular` になる**（上記 1.1）。欠席/代理の拒否は **「既存行が absent/proxy」のときのみ**。

### 1.4 CSV インポートでの members 解決・upsert

**CLI — `App\Console\Commands\ImportParticipantsCsvCommand`**

- **Participant:** `Participant::updateOrCreate(['meeting_id', 'member_id'], ['type', 'introducer_member_id', 'attendant_member_id'])`（L90–100）。  
- **Member:** `resolveOrCreateMember` — **`where('type', $type)->where('name', $name)->first()`** があれば更新（`display_no`・カテゴリ等）、なければ `Member::create`（L370–408）。  
  - コメントに「席番だけを一意キーにしない」旨あり。**SSOT 3.3 の「(type, display_no) で upsert」表現と実装は一致しない**（意図的に氏名寄せ）。

**Meetings 経路 Apply — `App\Services\Religo\ApplyMeetingCsvImportService`**

- `MeetingCsvMemberResolver`: `meeting_csv_import_resolutions` または **`Member::where('name', CSV名)`**（同名複数時は先頭＋警告メタ）。  
- 既存が無く Apply が新規作成する場合のみ `Member::create`（`resolveOrCreateMember` L205–222）。`display_no` は null 可。

---

## 2. SSOT との一致点

- SPEC-007 **5.2**: 左ペインが `GET /api/dragonfly/members` で **会議に紐づけず**取得していること。  
- SPEC-007 **5.2**: `PUT .../breakouts` で participant 不在時に **`regular` で create** し得ること。  
- SPEC-007 **4.3**: GET で absent/proxy を BO の member_ids から除外し、PUT で absent/proxy を割当拒否すること。

---

## 3. SSOT とのギャップ

| 項目 | 内容 |
|------|------|
| **members キー（CSV CLI）** | SPEC-007 3.3 は「(type, display_no) で upsert」に読めるが、**CLI 実装は (type, name) 優先**（`resolveOrCreateMember`）。ドキュメント修正または SSOT の言い換えが必要。 |
| **参加者 API** | `MeetingAttendeesService` は `participants.type` を **`member` / `visitor` / `guest` のみ**分類。CSV が作る **`regular`・`proxy` はどの配列にも入らない**。Connections を「参加者だけ」に寄せる際、**この API をそのまま使うと欠落**する。 |
| **Round API** | SPEC-007 は主に `breakouts` を記述。`MeetingBreakoutRoundsService` にも **同一の auto-create** あり。Round 利用画面があれば **同じギャップ**が再現する。 |
| **推奨実装順** | SPEC-007 5.3 の表は「未参加者拒否」と「自動生成禁止」を別行にしている。実装上 **同一箇所（MeetingBreakout*Service）の分岐**で両方満たせるため、REPORT では **「2+4 をサービス1か所でまとめてよい」** と整理可能。 |

---

## 4. 変更が必要な最小実装単位（次 Phase 以降）

| 順序（推奨） | 最小単位 | 主な変更候補 |
|--------------|----------|----------------|
| 1 | **participant 自動 create 禁止** | `MeetingBreakoutService::updateBreakouts` / `MeetingBreakoutRoundsService::updateBreakoutRounds` の **else ブランチ削除**し、不在時は 422。併せて **Feature テスト**（`MeetingBreakoutsTest` / `MeetingBreakoutRoundsTest`）を期待値更新。 |
| 2 | **未参加者拒否** | 上と**同一**（不在＝422 なら UI からも未参加者は送れない想定）。`UpdateMeetingBreakoutsRequest` に追加ルールは**必須ではない**（サービス側で十分）。 |
| 3 | **Connections 左ペインを参加者限定** | `DragonFlyBoard.jsx`: `selectedMeetingId` 変更時に **`GET /api/dragonfly/meetings/{number}/attendees`** 等で `member_id` 集合を取得し、`members` をフィルタ、または **新 API**（`meeting_id` + summary）を追加。 **`MeetingAttendeesService` の type 分類**は `regular`/`proxy` 対応が前提。 |
| 4 | **members 重複統合** | 運用 SSOT + 既存 M9 resolution / 同名警告の延長。CLI と Apply の **解決キー差**に注意。 |

---

## 5. 影響範囲

- **BO 自動 create 廃止:** `PUT /api/meetings/{id}/breakouts` / `breakout-rounds` を利用する **全クライアント**（現状は `DragonFlyBoard` が主）。既存データで「participant 無しで BO だけあった」ケースは **マイグレーション上は participant が作られている**ため、保存再実行で 422 になる可能性は **手動で member_ids を入れていたが participant が無い**等のエッジのみ。  
- **左ペイン絞り込み:** `summary_lite` を維持するには **participant 集合に対する batch summary** または **API 拡張**が必要（`DragonFlyMemberController@index` に `meeting_id` オプション等）。  
- **テスト:** `MeetingBreakoutsTest` は現状 **participant 無しで PUT 成功**を前提にしている（setUp で participant 未作成）。禁止化時は **事前に Participant 作成**が必要。  
- **監査:** `BoAssignmentAuditLogWriter::logFromBreakoutsPayload` は PUT 成功後。422 ならログなし（現仕様どおり）。

---

## 6. 推奨実装順（ユーザー提示との対応）

1. **現状調査と SSOT 整合確認** — 本 Phase（完了）。  
2. **BO 保存時の participant 自動生成禁止** — `MeetingBreakoutService` / `MeetingBreakoutRoundsService`（**両方**）。  
3. **Connections 左ペイン参加者限定** — `DragonFlyBoard.jsx` + **参加者一覧のデータ源修正**（`MeetingAttendeesService` の `regular`/`proxy` 含める）。  
4. **未参加者を BO 保存時に拒否** — 2 と同時に満たす（422 メッセージを UI が表示できるか確認）。  
5. **members 重複統合ルール** — ドキュメント + 必要なら resolution UI / バッチ。  
6. **マージ補助・レポート** — 運用負荷に応じて。

---

## 7. 参照したテスト（抜粋）

- `tests/Feature/Religo/MeetingBreakoutsTest.php` — PUT/GET breakouts、G11 同一 member 両 BO、監査ログ。  
- `tests/Feature/Religo/MeetingBreakoutRoundsTest.php` — breakout-rounds PUT/GET。  
- （本調査では **auto-create の有無を直接アサートするテストは見当たらない** — 禁止化 Phase で追加推奨。）

---

## 8. Merge Evidence

- **対象ブランチ:** なし（docs のみ・merge 前提なし）。  
- **テスト:** スキップ（docs Phase）。

---

## 9. 次 Phase で触るべきファイル（優先順）

1. `www/app/Services/Religo/MeetingBreakoutService.php`  
2. `www/app/Services/Religo/MeetingBreakoutRoundsService.php`  
3. `www/tests/Feature/Religo/MeetingBreakoutsTest.php`（必要なら `MeetingBreakoutRoundsTest.php`）  
4. `www/resources/js/admin/pages/DragonFlyBoard.jsx`  
5. `www/app/Services/DragonFly/MeetingAttendeesService.php`（`regular` / `proxy` を参加者一覧に含める）  
6. `www/app/Http/Controllers/Api/DragonFlyMemberController.php`（会議付きフィルタを入れる場合）  
7. `docs/SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md`（CSV キー記述の整合）

---

## 10. scope / ssot / dod

| チェック | 結果 |
|----------|------|
| scope | OK（`www/` 変更なし） |
| ssot | **UPDATE RECOMMENDED**（SPEC-007 3.3 と CLI 実装の表現整合） |
| dod | OK（PLAN/WORKLOG/REPORT・レジストリ・INDEX・進捗） |
