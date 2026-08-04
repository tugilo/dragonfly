# Phase 298 WORKLOG — 浦野歓太 第1回121 Zoom要約反映

tool: cursor

## Task1: 重複防止・DB

- `members` に浦野歓太は未登録。`one_to_ones` の 2026-08-03 行も無し（Zoom取込なし）。
- guest `members.id=256`（浦野歓太／email・NCAS URL）を新規作成。
- `one_to_ones.id=133` を **manual / completed**（11:00–12:00 予定枠）で **1行のみ**作成。同 target の oto 件数は1。
- 以後 Zoom取込があっても新規行を増やさず `#133` に寄せる方針を文書に明記。

## Task2: 校正と議事録

- 株式会社NL → **株式会社Anywel**（NCAS／anywel.jp を正とする）。
- DNI → **BNI**、5月5日イベント → **2026-08-05 リージョンフォーラム**（出雲121と整合。別イベントなら TODO）。
- ドラゴンフライ → **DragonFly**、ワンツーワン等 → **1to1**。
- NCASのカテゴリー・連絡先・GAINS・理想顧客・Contact Circle をプロフィール節へ統合。
- 相互送客・案件ベース相談・ヒアリング項目共有・LINE補完関係を合意として固定。会後お礼案A/Bを追加。

## Task3: import・ドキュメント同期

- `dragonfly:import-1to1-notes --only-ids=133`
- INDEX / progress / PHASE_REGISTRY / Phase 298 三ファイルを同期。
