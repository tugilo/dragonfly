# PHASE06 Religo DragonFlyBoard からメモ追加 — PLAN

**Phase:** DragonFlyBoard からメモ追加 UI  
**作成日:** 2026-03-04  
**SSOT:** [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.8 contact_memos, §5 Derived Metrics

---

## 1. 狙い

- 選択中の target に対して「メモ追加」が UI でできる。
- 追加後に members 一覧の summary_lite（last_memo / last_contact_at 等）が更新される。
- API ルールに沿った memo_type の扱いが崩れない。

## 2. UI 追加箇所

- **コンポーネント:** `www/resources/js/admin/pages/DragonFlyBoard.jsx`
- **配置:** 右ペイン（選択中メンバーのカード内）に「メモ追加」ボタンを設置。クリックで簡易モーダル（またはインライン折りたたみフォーム）を表示。

## 3. 入力項目

| 項目 | 種別 | 必須 | 備考 |
|------|------|------|------|
| memo_type | 選択 | 任意（default: other） | other / meeting / one_to_one / introduction |
| body | テキストエリア | 必須 | 1〜2000 文字。未入力は送信不可（UI 側ガード） |
| meeting_id | 数値入力 | memo_type=meeting のとき必須 | 数値。API で 422 になるので UI で送信前チェック |
| one_to_one_id | 数値入力 | memo_type=one_to_one のとき必須 | 数値。同上 |

- **owner_member_id / target_member_id / workspace_id の取得元:**
  - **owner_member_id:** 既存の Board 状態 `ownerMemberId`（画面上部の Owner member ID 入力値）。
  - **target_member_id:** 選択中メンバー `targetMember.id`。未選択時は「メモ追加」を出さない／無効化。
  - **workspace_id:** メモ API は nullable 許容のため、送信しない（省略）でよい。将来 workspace 選択する場合はクエリで取得する拡張を検討。

## 4. 追加後の更新方針

1. **POST /api/contact-memos** を呼ぶ。body: `{ owner_member_id, target_member_id, memo_type?, body, meeting_id?, one_to_one_id? }`。
2. **成功時（201）:** members 一覧を再取得する。`GET /api/dragonfly/members?owner_member_id={owner}&with_summary=1` を再度実行し、`setMembers` で更新。これで選択中 target の summary_lite（last_memo, last_contact_at）が更新される（確実性優先）。
3. **失敗時（4xx）:** エラーメッセージをフォーム近くに表示（最小で OK）。既存の notify SSOT がなければ、インライン文言で「保存に失敗しました」等を表示。

## 5. バリデーション（UI 側）

- body が空 or 空白のみ → 送信ボタン無効または送信しない。
- memo_type=meeting のとき meeting_id 未入力 → 送信しない or 送信前に「meeting_id を入力してください」表示。
- memo_type=one_to_one のとき one_to_one_id 未入力 → 同様。

## 6. テスト

- **UI:** 自動テスト不要。手動スモークを WORKLOG に記録する。
  - memo_type=other で追加 → 一覧の last_memo が更新されること。
  - memo_type=meeting で meeting_id なし → UI で送信不可、または API で 422 が返りメッセージ表示されること。
  - memo_type=one_to_one で one_to_one_id なし → 同様。

## 7. DoD

- [ ] DragonFlyBoard に「メモ追加」UI（ボタン＋モーダル/フォーム）を追加
- [ ] memo_type / body / meeting_id / one_to_one_id の入力と送信前ガードを実装
- [ ] POST 成功後に members 再 fetch（with_summary=1）で summary_lite を更新
- [ ] WORKLOG に手動確認結果を記載
- [ ] PLAN / WORKLOG / REPORT 作成済み、1 コミットで push、develop へ merge（--no-ff）
