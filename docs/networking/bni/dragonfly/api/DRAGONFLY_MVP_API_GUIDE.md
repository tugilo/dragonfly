# DragonFly MVP API ガイド

## 概要

- **対象 meeting:** 199（第199回定例会 / 2026-03-03）
- **実装コミットID:** 98cbb9c4590922668c66733d88d8e9f31ecc7196
- **データ投入コミットID:** ca500e6f33330bb688512c9c665afd21a4900896

---

## エンドポイント一覧

| Method | Endpoint | 説明 | 期待レスポンス |
|--------|----------|------|----------------|
| GET | `/api/dragonfly/meetings/{number}/attendees` | 指定回の参加者一覧（区分別） | 200: meeting + attendees.member / visitor / guest |
| GET | `/api/dragonfly/meetings/{number}/breakout-roommates/{participant_id}` | 指定参加者の同室者一覧（自分以外） | 200: data 配列（participant_id + member） |
| PUT | `/api/dragonfly/meetings/{number}/breakout-memos` | 同室者へのメモを upsert | 200: data（id, meeting_id, participant_id, target_participant_id, breakout_room_id, body, created_at, updated_at） |
| GET | `/api/dragonfly/meetings/{number}/breakout-memos?participant_id={id}` | 指定参加者が書いたメモ一覧 | 200: data 配列 |

- `{number}` は meeting の回数（例: 199）。数値のみ。
- `{participant_id}` は participants.id（数値）。

---

## curl 例（meeting=199）

### 参加者一覧

```bash
curl -s "http://localhost:81/api/dragonfly/meetings/199/attendees"
```

### 同室者一覧（participant_id=1）

```bash
curl -s "http://localhost:81/api/dragonfly/meetings/199/breakout-roommates/1"
```

### メモ upsert

```bash
curl -s -X PUT "http://localhost:81/api/dragonfly/meetings/199/breakout-memos" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"participant_id":1,"target_participant_id":2,"body":"名刺交換済み。次回1to1提案。","breakout_room_id":null}'
```

### メモ一覧（participant_id=1 が書いたメモ）

```bash
curl -s "http://localhost:81/api/dragonfly/meetings/199/breakout-memos?participant_id=1"
```

---

## レスポンス例（簡略）

### GET /attendees（200）

```json
{
  "meeting": {
    "number": 199,
    "held_on": "2026-03-03",
    "name": "第199回定例会"
  },
  "attendees": {
    "member": [
      {
        "participant_id": 1,
        "type": "member",
        "member": {
          "id": 1,
          "display_no": "1",
          "name": "平岡 国彦",
          "name_kana": "ひらおか くにひこ",
          "category": "建設・不動産",
          "role_notes": null
        },
        "introducer": null,
        "attendant": null,
        "breakout_room_labels": ["A"]
      }
    ],
    "visitor": [],
    "guest": []
  }
}
```

### GET /breakout-roommates/{participant_id}（200）

```json
{
  "data": [
    {
      "participant_id": 2,
      "member": {
        "id": 2,
        "display_no": "2",
        "name": "増本 重孝",
        "name_kana": "ますもと しげたか",
        "category": "建設・不動産"
      }
    }
  ]
}
```

### PUT /breakout-memos（200）

```json
{
  "data": {
    "id": 1,
    "meeting_id": 1,
    "participant_id": 1,
    "target_participant_id": 2,
    "breakout_room_id": 1,
    "body": "名刺交換済み。次回1to1提案。",
    "created_at": "2026-03-03T00:34:37+00:00",
    "updated_at": "2026-03-03T00:34:37+00:00"
  }
}
```

### GET /breakout-memos?participant_id=1（200）

```json
{
  "data": [
    {
      "id": 1,
      "participant_id": 1,
      "target_participant_id": 2,
      "target_member": {
        "id": 2,
        "display_no": "2",
        "name": "増本 重孝"
      },
      "breakout_room_id": 1,
      "body": "名刺交換済み。次回1to1提案。",
      "created_at": "2026-03-03T00:34:37+00:00",
      "updated_at": "2026-03-03T00:34:37+00:00"
    }
  ]
}
```

---

## エラー仕様

| 条件 | HTTP ステータス | 内容 |
|------|-----------------|------|
| meeting が存在しない（number に該当なし） | 404 | `{"message": "Meeting not found."}` |
| participant が存在しない（roommates で指定した participant_id が該当なし） | 404 | `{"message": "Participant not found."}` |
| GET /breakout-memos で participant_id クエリ未指定 | 422 | `{"message": "participant_id is required."}` |
| PUT /breakout-memos のバリデーションエラー（participant_id / target_participant_id 必須違反など） | 422 | Laravel 標準の validation エラー応答 |
