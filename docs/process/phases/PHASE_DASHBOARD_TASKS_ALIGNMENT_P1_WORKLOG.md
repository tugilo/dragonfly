# PHASE: DASHBOARD-TASKS-ALIGNMENT-P1 — WORKLOG

## 判断ログ

### Dashboard の役割

- **定義:** **現状把握**（KPI）と **次アクション決定**（Tasks）のホーム。Activity は **直近の事実の時系列**、Leads は **1 to 1 候補の補助**。詳細編集は各画面。  
- **根拠:** ユーザー指示の方針B（一覧ではなく「次に何を見る/やるか」）。`DASHBOARD_DATA_SSOT.md` **§0** に表形式で記載。`DASHBOARD_FIT_AND_GAP.md` **§1.1** でモックとの関係（レイアウト SSOT vs 役割の実装 SSOT）を分離。

### Tasks を「今日」ではなく「優先アクション」にしたか

- **はい。** UI 見出台を「優先アクション（Tasks）」に変更し、キャプションで「厳密には今日の ToDo ではない」と明記。  
- **案B（今日だけに絞る実装）**は、stale・例会フォローの価値が落ちるため不採用（PLAN に理由記載）。

### meeting_memo_pending の扱い

- **API kind を `meeting_follow_up` に変更**（破壊的変更だがクライアントは当該 SPA のみで grep 済み）。  
- **ロジックは変更せず**（次回/直近 `meetings` の誘導）。**タイトル**を「メモ未整理」から「次回・直近のフォロー」に変更し、意味と実装を一致。  
- **メモ未整理の DB 判定**は将来案として分析書に残し、本 Phase では見送り。

### stale「メモ追加」の disabled

- **SSOT を実装に寄せた:** 2 件目も `disabled: false`（従来からコードは false。SSOT の「disabled 意図」条文を削除し、**有効 deep link を正**と明記）。

### workspace

- **Tasks では引き続き `null`（owner 全体）。** REPORT に「将来 workspace を渡す場合は別 Phase で API+SSOT 同時」と記載。

### 実装のその他

- **one_to_one_planned** の meta: `format('本日 H:i')` は非当日でも「本日」が付く誤りがあり得たため、**本日 / n/j H:i / 日時未設定** に整理（`buildPlannedOneToOneTaskMeta`）。

### merge 時の競合

- **（merge 実行後に WORKLOG 追記）**

---

## メンテナンス

- merge 完了後、下記を追記すること: merge 競合の有無、`git merge` の結果。
