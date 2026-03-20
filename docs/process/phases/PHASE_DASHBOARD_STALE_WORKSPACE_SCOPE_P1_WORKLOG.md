# PHASE: DASHBOARD-STALE-WORKSPACE-SCOPE-P1 — WORKLOG

## 調査: `getSummaryLiteBatch` の第 3 引数

- **`null`:** memos / o2o / flags は **workspace 列で絞らない**（`useWorkspace = false`）。  
- **非 null:** `where('workspace_id', $id)` **厳密一致**（`Schema::hasColumn` 確認のうえ）。**`workspace_id IS NULL` の行は last_contact に載らない**。  
- **`batchLastContactAt` の同席部分:** `participant_breakout` 経路は **常に workspace 非スコープ**。

## stale の役割定義（採用: 案A）

- **Dashboard は個人の演繹の入口**かつ **BNI チャプター運用 UI** だが、**stale の数え上げは「owner が追うべき他全メンバー」に対する last_contact** とした（実装どおり言語化）。

## 案B を今回採用しなかった理由

1. **peer 境界:** `members.workspace_id` 未導入（DATA_MODEL は将来）。  
2. **NULL 行:** 厳密 `workspace_id = X` は DATA_MODEL の単一 WS 時の NULL 許容と矛盾し、偽陽性 stale。  
3. **半端な last_contact:** 同席は全会議・memos だけ WS 絞りになる。  
4. **API:** フロントに `workspace_id` クエリを増やさない方針と、サーバだけ差し込んでも説明がつきにくい。

## 実装

- **見送り。** `ReligoActorContext` から `workspace_id` を `getSummaryLiteBatch` に渡す変更は **行わない**。

## merge 競合

- **（merge 後に追記）**
