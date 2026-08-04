# Phase 296 WORKLOG — 松下靖 第1回121 Zoom要約反映

tool: cursor

## Task1: 重複防止・DB

- `target_member_id=239`（松下靖）の Zoom 取込行は `#126` のみ（`scheduled_at=2026-07-30 11:00`・`zoom_meeting_id=87200793481`・planned）。
- 同日同相手の他行なし。二重作成せず `#126` を正とする。
- `#126` を **completed**（started_at / ended_at = 11:00–12:00 予定枠）へ更新。終了時刻の厳密値は Zoom メタ TODO。

## Task2: 校正と議事録

- 浜松チャプター→**浜松やらまいか**、名前.com→**お名前.com**、スレッズ→**Threads**、原田氏→**原田 里織**。
- 「ルーランク」は **ブルーランプ（要確認）** として保留。
- 事前台本は付録へ圧縮。サマリー／第1回履歴／累積インサイト／アクション／会後お礼（案A/B）を実施後形式へ置換。
- 協業分業・補助金案件意向（未確定）・AIアバター・サイネージ・お盆明け再1to1を固定。

## Task3: import・ドキュメント同期

- `dragonfly:import-1to1-notes --only-ids=126`（notes 411→2442 chars）。
- INDEX / progress / PHASE_REGISTRY / Phase 296 三ファイルを同期。
