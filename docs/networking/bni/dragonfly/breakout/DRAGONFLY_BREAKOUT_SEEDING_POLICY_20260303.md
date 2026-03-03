# ブレイクアウト投入ポリシー（第199回 / 2026-03-03）

## 背景

- 元資料（`docs/networking/bni/dragonfly/participants/BNI_DragonFly_Breakout_20260303.md`）には、参加者ごとの「同室」チェックとメモ欄はあるが、**ブレイクアウトルームの正式な割り当て（誰がどのルーム A/B/C/D に入ったか）は記載されていない。**

---

## 現在の暫定割当ルール

- **display_no 順**に、参加者 63 名を 4 ルームへ均等に割り当てる。
- ルーム: **A, B, C, D**（`room_label`）。
- 割当:
  - **A:** display_no 1–16（16名）
  - **B:** display_no 17–32（16名）
  - **C:** display_no 33–48（16名）
  - **D:** display_no 49–63（15名：49–54, V1–V5, G1–G4）
- **Seeder:** `DragonFlyMeeting199BreakoutSeeder`（`php artisan db:seed --class=DragonFlyMeeting199BreakoutSeeder`）。
- participant の解決は **members.display_no** から meeting 199 の participants を特定して行う。名前による解決は行わない。

---

## 冪等性

- `breakout_rooms`: `updateOrCreate(['meeting_id', 'room_label'])` で作成・更新。
- `participant_breakout`: 各 participant に対して `breakoutRooms()->sync([$room->id])` で 1 ルームに紐付け。
- Seeder を複数回実行しても、重複や不整合が発生しないように実装されている。

---

## 将来の正式割当反映手順

正式なルーム割り当てデータが得られた場合の手順例（事実ベースの手順のみ記載）。

1. 新しい Seeder を作成する（例: `DragonFlyMeeting199BreakoutOfficialSeeder`）。
2. 既存の `participant_breakout` を削除する（または該当 meeting 分のみ削除）。
3. 正式データに基づき `breakout_rooms` / `participant_breakout` を再投入する。
4. コミットとドキュメントに「正式割当反映」である旨を記録する。
