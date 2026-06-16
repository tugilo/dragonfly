# Phase 219: BO 3枠以上の保存 — WORKLOG

| Phase ID | 219 |
|----------|-----|
| 作業日 | 2026-06-16 08:51 JST |

## 判断

- **API 拡張を採用**（`breakout-rounds` への UI 移行はスコープ外）。DragonFlyBoard は既に `breakouts` を使用しているため、同エンドポイントで N 枠対応が最小差分。
- **GET** は DB 上の `BO\d+` ルームを番号順に返す。未作成例会は `rooms: []`（UI が「同室枠を追加」導線を持つ）。
- **PUT** は payload を正とし、管理対象 BO ルームのうち payload に無いものは **削除**（participant_breakout は cascade）。
- **バリデーション** は BO1 開始・連番・重複禁止・最大 20 枠。後方互換: BO1+BO2 の 2 枠ペイロードは従来どおり有効。
- **UI コピー** は `roomIndex >= 1` で直前 room を参照する共通関数に集約。割当ガードは既存 `filterBoAssignableMemberIds` を再利用。
