# Meetings Archive（非表示 / 論理無効化 / 履歴保持）— Fit & Gap / 方針整理

**Phase:** MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK（docs のみ・**実装なし**）  
**調査日:** 2026-03-19  
**ステータス:** 方針整理・実装前の合意事項用

**関連:** [DATA_MODEL.md](DATA_MODEL.md) §4.6、[MEETINGS_DELETE_FIT_AND_GAP.md](MEETINGS_DELETE_FIT_AND_GAP.md)（物理削除のリスク・案 D 言及）、[MEETINGS_CREATE_FIT_AND_GAP.md](MEETINGS_CREATE_FIT_AND_GAP.md)、[FIT_AND_GAP_MEETINGS.md](FIT_AND_GAP_MEETINGS.md)

---

## 補足前提（実装入力の固定）

以下は **2026-03-19 追記**の前提であり、初回 Archive 実装の **スキーマ最小化・挙動の固定**として扱う（調査 Phase 自体は引き続き docs のみ）。

| 項目 | 内容 |
|------|------|
| **スキーマ第一候補** | **`archived_at`（nullable datetime）のみ**。初回は **`is_archived` 専用列・`archived_by` を追加しない**。監査で実行者 ID が強く要る場合は **後続 Phase** で案 C（列追加）を検討。 |
| **`show`** | **`GET /api/meetings/{id}` は既存挙動を壊さない**。存在する meeting は **アーカイブ済みでも 200** とし、既存の JSON ペイロード契約を維持する（**404 による隠蔽は採用しない**）。 |
| **`stats.next_meeting`** | 対象は **`archived_at` IS NULL** の行に限定し、そのうえで **`held_on` が今日以降**の最小を採用（**未アーカイブのみ**）。 |
| **restore（unarchive）** | **初回実装では必須にしない**。片道アーカイブのみでよい。復元が業務で必要になったとき **別 Phase** で API・UI を追加。 |

---

## 1. 調査目的

- Meetings に **Archive（一覧から隠すが行と子データは保持）** が Religo の業務・プロダクトに適するかを整理する。  
- [MEETINGS_DELETE_FIT_AND_GAP.md](MEETINGS_DELETE_FIT_AND_GAP.md) で示した **物理削除の連鎖リスク**に対し、**Delete の代替または併用**として Archive がどこまで有効かを明文化する。  
- **実装は行わない**。「何を解決したいか」「何を残し・何を隠し・何を集計から外すか」を SSOT 化し、**次の docs / implement Phase の入力**とする。

---

## 2. 確認した資料・実装

### 2.1 SSOT / Docs

| 資料 | Archive 関連の記述 |
|------|-------------------|
| `DATA_MODEL.md` §4.6 | meetings のカラムは id / number / held_on / name。**archive 用カラムの記載なし**。 |
| `MEETINGS_DELETE_FIT_AND_GAP.md` | 無条件物理削除は非推奨。**案 D（削除禁止・アーカイブ/非表示）** を履歴重視シナリオで言及。 |
| `MEETINGS_CREATE_FIT_AND_GAP.md` | 作成・更新実装済み。削除・アーカイブ未着手。 |
| `FIT_AND_GAP_MEETINGS.md` / `FIT_AND_GAP_MOCK_VS_UI.md` | 一覧・統計・Drawer・メモ等。**Archive 導線・用語なし**。 |
| Delete / Create / Update Phase 文書 | delete は別 Phase。Archive は **本調査で初めて SSOT レベルで扱う**。 |

### 2.2 モック（`religo-admin-mock-v2.html` `#/meetings`）

- 統計カード・検索・フィルタ・例会一覧・詳細パネル。**「アーカイブ」「非表示」「無効」等の語・トグルはなし**（`archive` 文字列の grep も該当なし）。  
- **Fit:** 現 UI に Archive がなくてもモックと矛盾しない。  
- **Gap:** 将来モックに Archive を足すかは **未確定（要合意）**。

### 2.3 実装（読取のみ）

| 対象 | 現状 |
|------|------|
| `MeetingController::index` | `Meeting::query()` 全件ベースにフィルタ（q / has_memo / has_participant_pdf）。**archive 概念なし**。 |
| `MeetingController::stats` | `total_meetings` = `Meeting::count()`。`next_meeting` = **未来日の held_on 最小**の 1 件。`total_breakouts` = **`BreakoutRoom` 全件 count**（meeting スコープではない）。`meetings_with_memo` = meeting_id ありの distinct。**archive 除外ロジックなし**。 |
| `MeetingController::show` | id 指定で詳細。**存在すれば常に返す前提**。 |
| `MeetingsList.jsx` | メモ・PDF・編集等のフィルタ。**「アーカイブ表示」なし**。 |
| `meetings` migration | `number`, `held_on`, `name` のみ。**論理フラグなし**。 |
| `ImportParticipantsCsvCommand` | `number` で `firstOrCreate`。**アーカイブ行が存在すると番号が埋まり、再利用はされない**（物理削除とは異なる）。 |

---

## 3. Delete の代替として Archive を検討する理由

| 観点 | 整理 |
|------|------|
| 物理削除 | [MEETINGS_DELETE_FIT_AND_GAP.md](MEETINGS_DELETE_FIT_AND_GAP.md) のとおり、cascade で **参加・BO・PDF・CSV・apply ログ等が大量消失**し得る。 |
| ユーザー欲求の分解 | 「一覧から消したい」≠「DB から消したい」。後者だけを Delete で満たすと **履歴・監査・会の地図**と衝突しやすい。 |
| Archive の役割 | **行と FK は維持**しつつ、**既定の一覧・「次回例会」等の運用 UI から外す**余地を作る。Delete の **完全代替にはならない**（法務・テスト掃除等で物理削除が要る場合は **別ポリシー**）。 |

**結論（調査時点）:** Archive は **「履歴を残しつつ運用画面を薄くする」** 用途に適し、Delete 調査で挙がった **案 D の具体化**として検討価値が高い。**必須かどうかは業務要否の合意が必要（未確定）**。

---

## 4. モック / SSOT / 実装の現状（Fit / Gap）

| 観点 | Fit | Gap |
|------|-----|-----|
| モック | Archive なしでも既存導線と整合 | Archive UX の **正**がモックにない |
| SSOT | DATA_MODEL に meetings の意味は明確 | **アーカイブ状態の定義・API・集計ルールが未記載** |
| 実装 | シンプルな CRUD + フィルタ | index/stats が **全 meeting 対象**。Archive 導入時は **クエリ条件の一貫した追加**が必要 |

---

## 5. meetings と子データに対する Archive 影響（方針論）

**前提（推奨イメージ）:** Archive は **meetings 行を削除しない**。子テーブルの行も **原則削除しない**（物理 Delete と対比）。

| 子 / 周辺 | Archive 後も DB に残すか | 一覧に出すか | Drawer/詳細で参照か | stats に含めるか |
|-----------|---------------------------|---------------|---------------------|-------------------|
| participants | **残す**（推奨） | 行は一覧に出ないが **`show` は非破壊（補足前提）** のため **id 指定で参照可** | **Drawer は一覧経由が前提なら「アーカイブ表示」等が必要**（§6） | **要合意**（total 参加者数など未定義なら N/A） |
| breakout 系 | **残す** | 同上 | **`show` 経由で参照可**（補足前提） | `total_breakouts` は **全 BO か現役 meeting のみか要定義**（現状は全件） |
| contact_memos（例会） | **残す** | — | 可 | `meetings_with_memo` が **アーカイブ込みか除外か要合意** |
| meeting_participant_imports | **残す** | — | 可 | — |
| CSV imports / resolutions / apply_logs | **残す** | — | 可 | — |
| one_to_ones 等（meeting_id nullable） | **残す** | — | **要合意** | — |

**未確定:** 「アーカイブ済み例会を開ける導線」を **一覧に載せない**場合、**直接 URL / ID 入力 / 「アーカイブを表示」フィルタ**のいずれかがないと **Drawer 再表示が困難**。

---

## 6. 一覧・検索・統計・Drawer への影響

| 機能 | 影響の論点 |
|------|------------|
| **GET /api/meetings（一覧）** | 既定を **未アーカイブのみ**にするか、**全件＋フラグ**にするか。**要合意**。クエリパラメータ例: `include_archived=1`。 |
| **検索（q）** | アーカイブを **検索対象に含めるか**（管理者が過去回を探す）。**要合意**。 |
| **stats.total_meetings** | **現役のみ**か **全件**か。ダッシュの意味が変わる。**要合意**。 |
| **stats.next_meeting** | **確定（補足前提）:** `archived_at` IS NULL かつ `held_on >= today` の最小。**アーカイブ済み未来日は「次回」に出さない**。 |
| **stats.total_breakouts** | 現状は **グローバル BO 件数**。アーカイブ連動にするなら **「現役 meeting に属する BO」** への定義変更が必要。**要合意**。 |
| **stats.meetings_with_memo** | アーカイブ会のメモを **カウントに含めるか**。**要合意**。 |
| **GET /api/meetings/{id}（show）** | **確定（補足前提）:** **既存どおり存在すれば 200**（アーカイブでも **壊さない**）。404 隠蔽は **採用しない**。 |
| **Drawer** | 一覧経由で開けないなら、**フィルタでアーカイブ表示**または **編集済み id の保持**など UX が必要。 |

---

## 7. Archive 設計案 A〜F の比較

| 案 | 概要 | メリット | デメリット / クエリ影響 | 実装コスト | tugilo 現実解 |
|----|------|----------|-------------------------|------------|----------------|
| **A** | `is_archived` boolean | 単純・インデックスしやすい | 「いつ誰が」が取れない。`WHERE is_archived = 0` を各所に追加 | 低〜中（波及は query 数に依存） | 可。監査要件が弱い場合 |
| **B** | `archived_at` datetime nullable | null = 現役、非 null = アーカイブ。**時刻が取れる** | 各クエリに `whereNull('archived_at')` 等 | 中 | **推奨候補の第一**。**初回実装は本列のみ（補足前提）** |
| **C** | `archived_at` + `archived_by`（user/member id） | 監査・説明責任 | スキーマ + 認可とセット。NULL 運用ルール要 | 中〜高 | **初回スコープ外**。必要時は後続 Phase |
| **D** | Laravel `softDeletes` | 削除 API と統一イメージ・復元の型付き | **`deleted_at` は「削除」語と混同**しやすい。既存 `Meeting::query()` 全箇所で `withTrashed` / global scope の整理が必要 | 中〜高 | Archive より **物理削除寄りのニュアンス**になりがち。**要合意** |
| **E** | 別テーブル（例: meeting_states）で状態管理 | meetings を極力触らない | JOIN 増・一貫性維持が難しく **過剰**になりやすい | 高 | 現段階では **過剰になりやすい** |
| **F** | Archive はやらず **条件付き Delete のみ** | スキーマ増なし | 履歴喪失リスクは Delete 調査どおり。**「一覧から消す」だけは満たせない** | Delete 側に依存 | Archive 不要と決めた場合のみ |

---

## 8. 推奨方針（調査時点・実装前の提案）

**補足前提**（`archived_at` のみ・show 維持・`next_meeting` は未アーカイブのみ・restore は初回不要）で **以下の 1〜3 は固定**、4〜6 は従来どおり論点として残す。

1. **「一覧から見えなくしたいが履歴は残す」** が要件なら、**物理 Delete より Archive を優先して設計検討**する。  
2. **スキーマ（初回）:** **案 B のうち `archived_at` のみ**（**案 C の `archived_by` は初回スコープ外**）。**案 D（softDeletes）** は「アーカイブ」と言語・UX を混同しないよう **慎重に（要合意）**。  
3. **挙動（確定）:** **`stats.next_meeting` は未アーカイブのみ**。**`show` はアーカイブ後も既存契約を壊さない（200 維持）**。**restore は初回必須としない**。  
4. **UI:** **「アーカイブ済みを表示」トグル**またはフィルタを **推奨**（隠した行に再アクセスするため）。導線は **Drawer 内または行 Actions** が自然（モック追記前提）。  
5. **number:** アーカイブは **行を残す**ため **number は占有されたまま**。再利用したい場合は **別途 number 変更（PATCH）または物理削除**の議論に戻る。**欠番とアーカイブの違い**を運用で説明できるようにする（**要合意**）。  
6. **案 F の位置づけ:** Archive と Delete は **排他ではない**（アーカイブで足りないケースのみ条件付き Delete）。  

---

## 9. 実装する前に先に決めること

| # | 論点 | 状態 |
|---|------|------|
| 1 | Religo で **Archive が必須か**、PATCH 運用で足りるか | **要合意** |
| 2 | 一覧・stats（**`next_meeting` 除く**）の **除外ルール** | **`next_meeting` は確定**（補足前提）。`total_meetings` / `total_breakouts` / `meetings_with_memo` 等は **要合意** |
| 3 | **show** をアーカイブでも常に見せるか / 隠すか | **確定（補足前提）:** **常に 200・既存契約維持（壊さない）** |
| 4 | **復元（unarchive）** を必須にするか、片道のみか | **確定（補足前提）:** **初回は片道のみ可**（restore は後続 Phase で任意追加） |
| 5 | **案 B vs C vs D** の確定 | **確定（初回スコープ）:** **`archived_at` のみ（案 B 最小）**。案 C・D は **後続・要合意** |
| 6 | **権限**（誰が archive できるか）— 現状 API は auth 薄い | **要合意** |
| 7 | `DATA_MODEL` §4.6 への **Archive 定義の SSOT 追記** | **実装前に推奨**（補足前提を反映） |
| 8 | モック（`FIT_AND_GAP`）への **Archive 導線の記載** | UI Phase で推奨 |

---

## 10. 次 Phase 提案

| 順 | 内容 |
|----|------|
| 1 | **docs（短）:** §9 の残り（一覧・各 stats ・権限・Archive 採否）を埋める。**補足前提**は既に `next_meeting` / `show` / 初回スキーマ / restore を固定。 |
| 2 | **docs:** `DATA_MODEL.md` §4.6 に **`archived_at`・一覧/stats（`next_meeting` は未アーカイブのみ）・show 非破壊**を追記。 |
| 3 | **implement:** migration + `Meeting` cast + **MeetingController**（index/stats の scope、任意で PATCH archive）+ Feature テスト。 |
| 4 | **implement:** `MeetingsList.jsx`（フィルタ・トグル・Drawer 導線）+ `npm run build`。 |
| 5 | Delete implement Phase は **Archive 方針と整合**させる（空例会のみ物理削除等）。 |

---

**本ドキュメントは調査・方針整理のみ。コード・マイグレーション・API の変更は行っていない。**
