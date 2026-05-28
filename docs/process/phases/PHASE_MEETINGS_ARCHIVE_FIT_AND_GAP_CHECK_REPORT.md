# PHASE_MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK — REPORT

**Phase ID:** MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK  
**種別:** docs  
**完了日:** 2026-03-19

---

## 調査結果サマリ

Meetings の **Archive（一覧から隠す・行と子データは保持）** は、**MEETINGS_DELETE_FIT_AND_GAP** で示された **物理削除の連鎖リスク**に対し、**「一覧から消したい」ニーズを履歴を壊さず満たす**手段として **有効な候補**である。  
現状 **SSOT・モック・API に Archive 概念はなく**、導入時は **index / stats /（要合意で）show** に **一貫した除外・包含ルール**が必要。特に **`stats.next_meeting`** はアーカイブ除外が **実質必須**。  
設計案は **`archived_at`（案 B）または +`archived_by`（案 C）** を第一候補とし、**softDeletes（案 D）** は語義・クエリ波及で **慎重に**。**案 F（Archive なし）** は「一覧から隠す」だけでは足りない場合がある。

## Fit

- **Delete 調査**と矛盾せず、**履歴重視の Religo** 方向性と整合しやすい。  
- 既存の **子データ多数**は、Archive なら **原則 FK 維持**で説明がつく。  
- モックに Archive がなくても **現状 UI と衝突しない**（将来追加は別 Phase）。

## Gap

- `DATA_MODEL.md` §4.6 に **アーカイブ状態・API・集計ルールが未記載**。  
- `MeetingController::index` / `stats` に **archive フィルタなし**（実装 Phase で全箇所の整理が必要）。  
- モック・`FIT_AND_GAP_MEETINGS` に **Archive 導線の正**がない。  
- **show をアーカイブでも返すか**、**復元の要否**、**権限**は **未確定（要合意）**。

## 推奨方針

1. **「一覧から見えなくしたいが履歴は残す」** が要件なら、**条件付き物理 Delete より先に Archive（案 B または C）を設計対象とする**。  
2. **既定:** 一覧・`next_meeting` は **未アーカイブのみ**。`total_meetings` 等は **ステークホルダーで定義**。  
3. **UI:** **「アーカイブ済みを表示」** 等のフィルタを **強く推奨**（隠した行への再アクセス）。  
4. **number:** アーカイブ行は **番号を占有**し続ける（再利用は **別操作・要合意**）。  
5. **案 D（softDeletes）** は「アーカイブ」と混同しやすいため **採用するなら命名・UX・global scope を SSOT で固定**。  
6. **案 F** は Archive **不要**と業務が決まった場合の枝。

## Archive の方が適切か、Delete の方が適切か

| 目的 | 適しやすい手段 |
|------|----------------|
| 一覧・ダッシュの運用から外すが **監査・子データは残す** | **Archive（＋必要なら show フィルタ）** |
| **DB からの完全除去**（法務・テストデータ等）が明確に必要 | **条件付き Delete**（Delete Phase の決定事項に従う） |

**排他ではない。** 運用は **Archive を主**、**Delete は狭い条件**が現実解になりやすい（**最終は要合意**）。

## 次に進むなら何をやるか

1. **docs:** §9（`MEETINGS_ARCHIVE_FIT_AND_GAP.md`）の **要合意**を埋める。  
2. **docs:** `DATA_MODEL.md` §4.6 に **archive 状態と index/stats/show の規則**を追記。  
3. **implement:** migration + Model + `MeetingController` scope + Feature テスト。  
4. **implement:** `MeetingsList.jsx`（フィルタ・導線）+ `npm run build`。  
5. **implement（別 Phase）:** Delete は **Archive 方針と整合**した条件・権限で。

## 実装をまだやらない理由

- **「何を解決するか」「何を隠し何を集計から外すか」** が未合意のまま実装すると、`next_meeting`・総数・権限で **仕様の食い違い**が起きやすい。  
- 本 Phase の目的は **安全に設計できる条件の SSOT 化**であり、**スキーマ・API・UI は範囲外**。

## Merge Evidence（docs only）

| 項目 | 内容 |
|------|------|
| phase id | MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK |
| phase type | docs |
| merge commit id | **該当なし**（docs のみ・ブランチ merge は別運用） |
| test command | **スキップ**（コード変更なし） |
| changed files | `docs/SSOT/MEETINGS_ARCHIVE_FIT_AND_GAP.md`（新規）、`docs/process/phases/PHASE_MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK_{PLAN,WORKLOG,REPORT}.md`（新規）、`docs/INDEX.md`、`docs/process/PHASE_REGISTRY.md`、`docs/dragonfly_progress.md` |
| scope check | OK（docs のみ） |
| ssot check | OK（新規 SSOT 調査文書追加） |
| dod check | OK |
| **コード** | **本 Phase は `www/` を編集していない**（他作業の `www/` 変更が作業ツリーにあっても本 Phase 外） |

---

## 補足（2026-03-19）

`MEETINGS_ARCHIVE_FIT_AND_GAP.md` に **実装入力の固定**を追記した（docs のみ）。

- 初回スキーマは **`archived_at` のみ**（`archived_by` は後続検討）。  
- **`GET /api/meetings/{id}` は非破壊**（アーカイブ後も **200**）。  
- **`stats.next_meeting` は未アーカイブのみ**。  
- **unarchive は初回スコープ外**可。
