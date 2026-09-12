# WORKLOG: Phase 307 — ウィークリー稿のパターン切替と利用履歴

tool: cursor

## 判断

- SPEC-004 §3.2 の「複数バージョンは切替」を、週替わり A〜E に使う。
- 履歴は members JSON ではなく別テーブルにする。日付で「いつ使ったか」を残すため。
- 同一日同一パターンは upsert。誤クリック連打で行が増えない。
- `weekly_presentation_body` は選んだ本文へ同期する。Phase 119 の GET キーを壊さない。
- パターンが空なら UI を出さない。他メンバーの画面は変えない。
- db-export はしない。dirty な `dragonfly.sql` に混ぜない。

## 実装

- members に patterns JSON と active_id を足し、利用日は `member_weekly_presentation_usages` にした。日付で「いつ使ったか」を残すため。
- GET は既存 `weekly_presentation_body` を残しつつ patterns / active_id / usages を足した。Phase 119 のキーを壊さない。
- POST `/api/dashboard/weekly-presentation/select` は表示切替だけ。履歴は書かない。
- 利用記録は例会後の `POST /api/dashboard/weekly-presentation/use`。「この週に使った」を押したときだけ残す。プレビューで履歴が汚れない。
- SQLite では date キャストが `Y-m-d 00:00:00` になり `updateOrCreate` が既存行を見失った。`whereDate` で照合してから update / create した。
- 次廣（id=37）だけ A〜E をシード。他メンバーは patterns 空＝従来の1本文。
- Dashboard はパターンがあるときだけチップと「最近の利用」を出す。スタートダッシュタブは chips を出さない。
- `dragonfly.sql` は触らない。develop の別件 dirty と混ぜない。
