# Phase G11: DragonFly breakout duplicate member support — WORKLOG

| Phase ID | G11 |
|----------|-----|
| 作業日 | 2026-03-11 |

---

## 方針

- 仕様: cross-BO は同一 member 可。同一 BO 内は重複防止。コピーは A（BO2 を BO1 で完全上書き）。
- UI: assignedInRound を「その room の member_ids のみ」で除外に変更。saveRounds の cross-BO エラー削除。payload は per-room で member_ids を dedupe。
- Backend: updateBreakouts の cross-BO 重複 throw を削除。per-room で member_ids を unique 化して処理。
- コピーボタン: BO2 ブロック上に「BO1 を BO2 にコピー」を配置し、roundsEdit の rooms[1] を rooms[0] のコピーで上書き。

---

## Task 別メモ

- Task1: DragonFlyBoard 957行目 assignedInRound = 全 rooms の flatMap。640–642 saveRounds で allIds の unique チェック。MeetingBreakoutService 67–76 で同様に throw。
- Task2: UI で options={members.filter(x => !(room.member_ids ?? []).includes(x.id))}。saveRounds で cross-BO チェック削除、rooms.map(r => ({ ...r, member_ids: [...new Set(r.member_ids ?? [])] })) で dedupe。Backend で cross-BO チェック削除、per-room で array_values(array_unique(...)) で member_ids を正規化。
- Task3: BO2 用の Box 内に Button「BO1 を BO2 にコピー」を追加。onClick で setRoundsEdit(prev => { const r0 = prev[0]; const rooms = [...(r0?.rooms ?? [])]; const bo1 = rooms.find(r => r.room_label === 'BO1'); const bo2Copy = bo1 ? { room_label: 'BO2', notes: bo1.notes ?? '', member_ids: [...(bo1.member_ids ?? [])] }; const nextRooms = rooms.filter(r => r.room_label !== 'BO2').concat(bo2Copy); return [{ ...r0, rooms: nextRooms }]; })。
- Task4–7: 確認・test・REPORT。
- Task5: 手動確認は実施可能な範囲で記載。regression は既存のメモ・member 選択を触らないことで担保。
