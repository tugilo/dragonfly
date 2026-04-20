# PHASE CONN-LEFT-PANE-MEETING-P1 — REPORT

## API で絞ったか / フロントで絞ったか

- **API（`GET /api/dragonfly/members?meeting_id=`）** で `whereHas(participants)`（当該 `meeting_id` かつ `type != absent`）を適用。レスに `participant_type` / `bo_assignable` を追加（`meeting_id` 指定時のみ）。
- **フロント**は `meeting_id` を付与して fetch し、未選択時は **リクエストせず空配列**。追加のクライアント側フィルタは不要。

## participant.type ごとの扱い

| type | 左ペイン | bo_assignable | 備考 |
|------|----------|---------------|------|
| absent | 出さない | — | `where('type','!=','absent')` |
| proxy | 出す | false | Chip「代理」、BO 用 `+`/Autocomplete 除外 |
| その他（regular, visitor, guest 等） | 出す | true | BO 操作可 |

## 今後の改善余地

- **`GET .../attendees`（`MeetingAttendeesService`）** は `regular`/`proxy` をバケットに含めていない既知ギャップ。左ペインは `members` API に一本化したため **本 Phase では未解消**。
- **他画面**が `meeting_id` を誤付与しないこと（現状 Connections のみ）。

## 保存側制約との整合

- 左ペインは **BO 保存が許可する参加者集合**（欠席除く・proxy は API が 422）の **部分集合**（proxy は表示するが UI で BO 操作不可）。不整合で 422 になりにくい。

## テスト

- `tests/Feature/Api/DragonFlyMembersMeetingScopeTest.php` — スコープ・`bo_assignable`・未指定時フィールドなし。
- `php artisan test` 352 passed（実施時点）。`npm run build` 成功。

## Merge Evidence

- ローカル実施。merge / push はリポジトリ運用に従うこと。
