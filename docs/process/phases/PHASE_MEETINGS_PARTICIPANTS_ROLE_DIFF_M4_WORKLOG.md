# Phase M7-M4: Role History 差分検知 — WORKLOG

## 判断・実装メモ

- **現在役職の定義:** `Member::currentRole()`（member_roles + term 条件）を正とし、CSV の「役職」列はプレビュー正規化キー `role`（MeetingCsvPreviewService の HEADER 既存）を利用。プレビューサービス本体は変更しない。
- **同一名の扱い:** CSV 上の役職名と現在役職名が **文字列一致** なら変更なし（`unchanged_role_count` のみ）。CLI の syncCurrentRole のような「毎週新規履歴行」は行わない方針と整合。
- **マスタ解決:** `Role::where('name', $csvText)->exists()` のみ。未登録役職名は `role_master_resolved: false` で changed / csv_only に載せ、ユーザーが roles を整備したうえで将来の反映 Phase を想定。
- **集約キー:** member_id。複数 CSV 行は最後に勝つ（member 差分と同様）。
- **UI:** member 差分ブロックに続けて「role差分を確認」。Drawer 閉鎖時に state リセットで他 Drawer と挙動を揃える。
- **テスト:** GET の前後で `MemberRole::count()` 不変を 1 ケースで確認し、読み取り専用を担保。
