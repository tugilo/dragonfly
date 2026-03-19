# Phase M7-C4.5-REQUIREMENTS: participants 差分更新 + members 更新 + Role History 連携 要件整理 — WORKLOG

**Phase ID:** M7-C4.5-REQUIREMENTS

---

## 現状の participants / members / role history の確認

- **participants:** meeting_id + member_id UNIQUE。ApplyMeetingCsvImportService は全削除ののち CSV 行から member 解決 or 新規作成し Participant::create。category / role / introducer / attendant は未更新（名前・かな・type は新規作成時のみ）。
- **members:** name, name_kana, category_id, type, display_no, introducer_member_id, attendant_member_id。役職は持たず、member_roles が正。
- **member_roles:** member_id, role_id, term_start, term_end。現在役職は term_end IS NULL かつ term_start <= 今日 の行から導出。Member::currentRole() で取得。
- **ImportParticipantsCsvCommand:** type + display_no をキーに Member::updateOrCreate。name, name_kana, category_id, introducer_member_id, attendant_member_id を更新。syncCurrentRole で「term_end 未設定をすべて today で閉じ、CSV の役職で新規 member_role を term_start=today で開始」。毎週実行すると同じ役職でも週ごとにレコードが増える設計。

## 毎週名簿から更新したい項目の整理

- **participants:** 追加・更新は CSV を正とする。削除は削除候補とし BO ありは削除しない（M7-C4 方針）。
- **members:** 名前・よみがなは更新候補として反映可。カテゴリーは変更時 warning を出し確認のうえ更新。役職は member_roles で管理するため、毎週の自動上書きは推奨しない。紹介者・アテンドは participant 単位で設定し、members のデフォルトは第一歩では触れない。
- **Role History:** 毎週名簿からは「役割変更候補」の表示のみ。確定は人が行う。同じ役職継続の場合は履歴を増やさない。

## カテゴリー変更と役割履歴の論点

- **カテゴリー:** 変わることがある。既存値と異なる場合は「カテゴリー変更候補」として warning を出し、categories マスタ照合のうえ確認してから members.category_id を更新。変更履歴は第一歩では持たない。
- **役割:** 半年に一度変わる。member_roles の term_start / term_end で管理。毎週 CSV で term_start=today の新規 insert をすると履歴が細切れになるため、自動更新せず、差分検知→候補表示→人が確定、とする。

## 比較した更新方針

- **participants:** 差分更新（追加・更新・削除候補、BO ありは削除しない）で確定（M7-C4 推奨）。
- **members 基本情報:** 同一「CSV 反映」で「member 更新候補」を適用。名前・かな・カテゴリーをプレビューで確認し一括反映。
- **Role History:** 同一反映では更新しない。別ステップまたは「Role History を更新する」チェックを付けた場合のみ member_roles を更新。第一歩では候補表示のみ。

## 判断理由

- 安全性を最優先するため、Role History の自動更新は行わない。履歴の意味（半年交代・同じ役職継続では増やさない）を守るには、人が確認してから term_end 設定・新規 insert を行う方が安全。
- members の名前・かな・カテゴリーは「表記修正・最新化」として許容範囲が広いため、プレビューで確認のうえ同一反映で更新してよい。
- participants は M7-C4 の結論に従い、差分更新と BO 保護を両立する。

## まとめ

- 要件整理本体（MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md）に、反映対象 3 層・members 更新項目の分類・カテゴリー変更・役割/Role History・差分更新との関係・UI/UX・データ・フェーズ案 M1〜M6・推奨方針・今後の確認事項を記載した。
- 実装は行っていない。次に進む場合は M1（participants 差分更新）から。
