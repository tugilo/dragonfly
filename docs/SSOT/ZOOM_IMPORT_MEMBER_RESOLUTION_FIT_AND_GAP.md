# Zoom 取り込み — 未登録相手の新規メンバー作成 & 過去履歴取り込み Fit & Gap

**関連 SSOT:** [ZOOM_ONETOONE_SYNC_REQUIREMENTS.md](ZOOM_ONETOONE_SYNC_REQUIREMENTS.md)（SPEC-012）、[MEMBERS_DEDUPLICATION_RUNBOOK.md](MEMBERS_DEDUPLICATION_RUNBOOK.md)（SPEC-008）、[ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md)（SPEC-006）
**作成:** 2026-05-30 18:14 JST
**位置づけ:** Zoom 取り込みで **相手が `members` 未登録のとき新規作成して 1to1 化する**フロー、および **過去履歴の取り込み**に関する現状・課題・対応案の整理。実装前の合意形成用（docs のみ）。

---

## 1. 背景（実機調査・本番 religo_app）

ユーザー操作で「Zoom から取得（過去30日／今後14日）」したところ、**画面に未来の予定しか見えない**との指摘。実機調査で原因を特定した。

| 調査項目 | 結果 |
|----------|------|
| Zoom API `scheduled` | **117 件** 返却（未来＋過去の未失効分） |
| Zoom API `previous_meetings` | **35 件** 返却（過去も取得できている：古屋・神保・野口・御手洗・西岡・権堂 等） |
| `zoom_meeting_imports` 保存 | total **38**（scheduled **7** / past **31**） |
| 過去 31 件の `status` | **すべて `held`（保留）** |

### 1.1 「未来しか出ない」の真因
- **過去は取得・保存できている**（fetch 問題ではない）。
- 過去 1to1 の **相手が `members` 未登録**のため、一括登録時に `ZoomImportApplyService` が `matched_member_id === null` → **`held`（保留）**にした（仕様どおりの安全動作）。
- 一覧は **`start_time` 降順**。未来（6月）が上・過去（5月）が下に並ぶため、画面上部では未来のみ見えていた。
- **結論:** 「過去が取れない」ではなく **「未登録相手 → 保留」** が本質。新規メンバー作成フローで解消する。

---

## 2. 現状（As-Is）

### 2.1 相手の解決手段
| 手段 | 現状 |
|------|------|
| 既存 `members` から選ぶ | ✅ 取り込み画面の相手プルダウン（Autocomplete）で可能 |
| **その場で新規 `members` 作成** | ❌ **導線なし**（Members 画面で別途作成 → 戻って選択するしかない） |
| 保留のまま残す | ✅ `held`（target 未確定で 1to1 化しない） |

### 2.2 過去取り込み
| 項目 | 現状 |
|------|------|
| 取得元 | `GET /users/me/meetings?type=previous_meetings`（自分がホストした過去会議） |
| 期間 | UI「過去（日）」既定 30・`syncPast` が `now-pastDays 〜 now` で絞る |
| 取得可否 | **可**（実機 35 件）。ただし相手ホスト分は出ないことがある（SPEC-012 §10 既知） |
| 表示 | 一覧に出るが、未登録相手は `held` で下方に並ぶ |

### 2.3 既存の参照実装（流用可能）
- CSV 取込の **`MeetingCsvImportController::createResolutionMember`**：`name`(必須)・`name_kana`・`type`(regular/visitor/guest/proxy) で `Member::create` する前例あり。
- `Member` は **`name` ＋ `type` だけで作成可能**（`workspace_id`・`category_id`・`display_no` 等は nullable）。
- 重複統合は **`MemberMergeService`（SPEC-008）**。

---

## 3. ギャップ（Gap）

| # | ギャップ | 影響 |
|---|----------|------|
| G1 | 取り込み画面に**新規メンバー作成**の導線が無い | 未登録相手（ビジター/他チャプターが大半）が全部 `held` になり 1to1 化できない |
| G2 | `held` 行の**視認性/再開導線**が弱い | 保留が下方に埋もれ「取得できていない」と誤認 |
| G3 | 過去の**相手特定**（氏名のみ・email 欠落）で自動マッチ率が低い | 新規作成 or 手動紐付けの手間 |
| G4 | 新規作成時の**同名重複ガード**が無いと重複 members が増える | 後で SPEC-008 マージが必要に |
| G5 | 相手名の自動推定が**姓名スペースで切れる**（「吉田 匠真」→「匠真」） | 自動マッチ・初期値の精度低下 |

---

## 4. 要件（To-Be）

| # | 要件 | 区分 |
|---|------|------|
| R1 | 取り込み画面の未登録相手行から**その場で `members` 新規作成 → 自動紐付け** | Must |
| R2 | 新規作成時、**氏名は Zoom 件名からの推定値を初期値**（編集可） | Should |
| R3 | 作成フォーム：**氏名(必須)・ふりがな・種別・所属チャプター・カテゴリ(任意)** | Must |
| R4 | **同名 `members` が存在する場合は候補提示**し「既存を使う/新規作成」を選ばせる（重複防止・SPEC-008） | Must |
| R5 | 作成後その行を `matched` にし、**一括登録で 1to1 化**できる | Must |
| R6 | `held`/過去行の**視認性**改善（保留フィルタ・件数表示・並び/ハイライト） | Should |
| R7 | 相手名推定を**姓＋名対応**に改善（G5） | Should |
| R8 | アクセスは `auth:sanctum`＋owner 一致（SPEC-012 と整合）。新規作成も認証ユーザーのみ | Must |

### 4.1 非目標
- members の自動作成（人の明示操作のみ）。
- 過去会議の相手ホスト分の自動取得（Zoom API 制約。手動 1to1 で補完）。
- 既存重複の自動マージ（SPEC-008 の手動運用に委ねる）。

---

## 5. 対応案

### 5.1 新規メンバー作成（G1/R1〜R5）

| 案 | 内容 | 評価 |
|----|------|------|
| **A. 取り込み画面にインライン「新規作成」ダイアログ**（推奨） | 相手列に「新規作成」→ ダイアログ（氏名初期値・種別・チャプター・同名チェック）→ 作成して即紐付け | UX 最良・1画面完結。実装中。 |
| B. Members 画面へ遷移して作成 → 戻る | 既存機能で可だが往復が手間 | 既存のみで0実装だが UX 劣る |
| C. apply 時に「未登録は自動で member 作成」 | ワンクリックだが**重複・誤作成リスク大** | 非推奨（R4 と相反） |

**推奨: 案A。** 新規 API `POST /api/zoom/imports/{import}/create-member`（`name`・`name_kana`・`type`・`workspace_id`・`category_id`）→ `Member::create` → staging 行の `matched_member_id` 更新・`match_status=matched`。作成前に同名検索し候補を返す（R4）。

### 5.2 過去履歴の取り込み（G2/G3/R6）
- **取得自体は現状で可**（実機確認済み）。追加の API 変更は当面不要。
- UI 改善：**「保留のみ」フィルタ**・保留件数表示・`held` 行の再選択導線（既に選択可だが見えにくい）。
- さらに遡るニーズが出たら「過去（日）」上限を緩和（Zoom 保持期間・API 上限まで）。相手ホスト分は手動 1to1 で補完する旨を画面に明記。

### 5.3 相手名推定の改善（G5/R7）
- `ZoomOneToOneDetector::guessCounterpartName` を**全角/半角スペースを含む姓名**に対応（「吉田 匠真」→「吉田 匠真」を1名として抽出）。会社名プレフィックス（「合同会社TF 古屋周治さん」→「古屋周治」）の除去も検討。

---

## 6. データ・セキュリティ

- 新規 `members` 作成は既存 `Member` を流用（スキーマ変更なし）。
- 種別の既定・所属チャプターの扱いは**実装 Phase で確定**（下記 Open Questions）。
- 認証・owner スコープは SPEC-012/Phase 154 と同じ（`auth:sanctum`）。

---

## 7. Open Questions（実装前に確定）

1. 新規作成時の**種別の既定**は？（他チャプター/ビジターが多い想定 → `guest` 既定が妥当か、`member` か）
2. **所属チャプター（workspace_id）**は未指定(null)可とするか、自分の所属を既定にするか。
3. **過去の遡り期間**の上限（現状 UI 上限・Zoom 保持期間との兼ね合い）。
4. 会社名付き件名からの**氏名抽出ルール**の範囲（どこまで自動で削るか）。

---

## 8. 推奨スコープ（次フェーズ案）

- **Phase（実装）:** 案A（新規メンバー作成ダイアログ＋API＋同名ガード・R1〜R5/R8）＋ R7（相手名推定改善）。
- **続けて（任意）:** R6（保留フィルタ/視認性）。
- 過去取得の API 変更は**現状不要**（取得できているため）。

---

## 9. 実装（Phase 157・案A 採用）

UX 改善要望（タップで候補即表示・未登録はその場で新規登録）を含めて案A を実装した。

| 区分 | 内容 |
|------|------|
| API | `POST /api/zoom/imports/{import}/create-member`（`auth:sanctum`＋owner 一致）。同名は force=false で重複候補を返し作成しない（R4）。作成後 staging を `matched`・`selected` に。 |
| Request | `CreateZoomImportMemberRequest`（name 必須・type〔member/active/inactive/visitor/guest〕・workspace_id・force） |
| 既定 | 種別 = **guest**（他チャプター/来訪想定・編集可）、所属チャプター = 未設定可（任意選択） |
| UI | 相手セルをボタン化 → **`CounterpartPickerDialog`**：開くと推定名で候補を即フィルタ表示・タップで選択／「＋ 新規登録」で氏名・種別・チャプター入力・同名警告で既存選択も可。 |
| 一覧 | 高さをウィンドウ追従（`calc(100vh-300px)`）・「全 N 件」表示で保留の過去行に気づける（G2 緩和）。 |
| テスト | `ZoomImportApplyServiceTest::test_create_member_links_and_blocks_duplicate`。全体 421 green。 |

**未実装（任意・将来）:** G5 相手名推定の姓名/会社名対応、R6 保留専用フィルタ。

## 10. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-05-30 18:14 JST | 初版。実機調査（過去は取得済み・未登録相手で held）と、新規メンバー作成フロー・過去取り込みの Fit & Gap・対応案 A/B/C・Open Questions を整理。 |
| 2026-05-30 18:40 JST | 案A 実装（Phase 157）。create-member API＋相手選択ダイアログ（候補即表示・新規登録・重複ガード）。Open Questions: 種別既定=guest・所属チャプター任意で確定。 |
