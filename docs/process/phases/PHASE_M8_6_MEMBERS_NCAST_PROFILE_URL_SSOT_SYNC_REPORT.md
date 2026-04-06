# M8.6: members.ncast_profile_url SSOT反映 — REPORT

**Phase ID:** M8.6  
**種別:** docs  
**完了日:** 2026-03-31  
**Related SSOT:** [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.2 members  

---

## 1. 実施内容サマリ

- **DATA_MODEL.md** の members 節にある **主要カラム** に、`ncast_profile_url`（nullable・文字列長 2048・Nキャスの自己紹介ページ URL）を追記した。
- 先行実装（migration・`DragonFlyMemberController`・管理 UI）と SSOT の記述を揃え、ドキュメント参照時の齟齬を解消した。
- PLAN / WORKLOG / 本 REPORT を作成し、`docs/INDEX.md` および `docs/process/PHASE_REGISTRY.md` を更新した。

## 2. 変更ファイル一覧

| ファイル |
|----------|
| [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md) |
| [docs/process/phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_PLAN.md](PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_PLAN.md) |
| [docs/process/phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_WORKLOG.md](PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_WORKLOG.md) |
| [docs/process/phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_REPORT.md](PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_REPORT.md) |
| [docs/INDEX.md](../../INDEX.md) |
| [docs/process/PHASE_REGISTRY.md](../PHASE_REGISTRY.md) |

**コード・テスト:** 変更なし（本 Phase のスコープ外）。

## 3. 仕様整合（実装との対応）

以下は SSOT 追記内容と、現行実装の対応関係である。

| 項目 | 内容 |
|------|------|
| **カラム** | `ncast_profile_url` |
| **型** | string(2048), nullable（DB・SSOT いずれも） |
| **意味** | 外部サービス「Nキャス」の自己紹介ページ URL |
| **API（一覧）** | `GET /api/dragonfly/members` の各要素に `ncast_profile_url` が含まれる（select 対象）。 |
| **API（更新）** | `PUT /api/dragonfly/members/{id}` で `ncast_profile_url` を更新可能。リクエストにキーが存在する場合に反映。 |
| **クリア** | `null` または空文字相当でクリア可能（実装は `exists('ncast_profile_url')` により JSON の `null` も検知）。 |
| **管理 UI** | Members 詳細ドロワー（Overview）で URL 入力・保存・別タブで開く。メンバー Show でリンク表示・Edit から編集可能（Religo 管理画面）。 |

## 4. Merge Evidence（仮）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （未 merge）docs のみのため、取り込み時に追記する。 |
| **source branch** | （任意）例: `feature/phase-m8-6-ncast-ssot` |
| **target branch** | develop |
| **phase id** | M8.6 |
| **phase type** | docs |
| **related ssot** | DATA_MODEL.md §4.2 |
| **test command** | 対象外（アプリコード変更なし） |
| **test result** | 影響なし |
| **changed files** | 本 REPORT §2 の一覧 |
| **scope check** | OK（docs のみ） |
| **ssot check** | OK（DATA_MODEL 追記） |
| **dod check** | OK |
