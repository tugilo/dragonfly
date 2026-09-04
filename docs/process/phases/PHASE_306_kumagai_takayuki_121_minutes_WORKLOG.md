# Phase 306 WORKLOG

tool: cursor

## 判断メモ

- **年号:** 要約「2024年6月末・約2ヶ月」は実施日 2026-09-04 と矛盾する。約2ヶ月なら **2026年6月末**。2024 は ASR の年号取り違えとして校正。
- **小永→小中:** 「使って学ぶAI」は小中貴晃さんの紹介言葉。社外CTO的は次廣側の言い方として残す。
- **羽賀→芳賀:** 章内の「はが」誤変換が多い。芳賀崇利さんの本業はものづくり／Tシャツで AI 専業ではないため、121実施と「AI関連」は要確認のまま残す。
- **堀切:** 九州・非エンジニア・24時間 HP・Antigravity は堀切孝則（Link／Abundance）の話。金額は要約「月5万円」、堀切121では制作5万・月5千。両方を注記。
- **入会:** 票④ NO を消さず、第1回後の「前向きに検討」を上書きとして書く。事前の「クローズしない」は守った記録にする。
- **既存行:** `#152` のみ更新。熊谷龍笙 `#79` / `members.id=132` と混ぜない。
- **終了時刻:** カレンダーは 12:00。実終了の根拠が無いので予定枠＋TODO。
- **db-push:** ユーザー明示。615 passed のあと `db-export` → `db-push TARGET=prod`。backup `backups/prod_20260904_141522.sql`。

## 取込

- `#152` planned → completed（started/ended = 11:00–12:00 予定枠）
- `dragonfly:import-1to1-notes docs/meetings/1to1/1to1_kumagai_takayuki_enfusia.md --only-ids=152` → `[update] #152 第1回 notes 0 → 3068 chars`

## 参照した Spec

- SPEC-013: 1to1 原稿のローカル md 運用
- SPEC-012 / 1to1-dedup: Zoom 取込済み id を正とする
- SPEC-019: `### 【第N回】` と `one_to_ones.id` の対応
