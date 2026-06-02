# PHASE_164_member_consultations_folder WORKLOG

## 判断ログ

### 相談メモの置き場

`docs/meetings/1to1/` は相手との関係履歴・会話履歴を蓄積する場所であり、相談ごとの調査や対応案が増えると目的が混ざる。`docs/proposals/` は共有資料・提案書の置き場で、相談直後の未確定な検討ログには重い。

そのため、正式提案前の相談・調査・検討を扱う中間置き場として `docs/consultations/` を新設することにした。

### README の設計

README は単なるフォルダ説明ではなく、実際に相談メモを増やすときに迷わないよう、以下を含めた。

- 置くもの・置かないもの
- 1to1 / proposals / SSOT との役割分担
- `consultation_<person_slug>_<topic_slug>.md` の命名規約
- 相談内容、調査・検討、対応案、次アクションを整理する推奨フォーマット
- 日時記録や推測の扱いなどの運用ルール

### SSOT 判断

今回の変更は docs の情報整理であり、Religo の仕様・DB・画面・API の要件を追加するものではない。そのため Related SSOT は N/A とし、SSOT_REGISTRY への追加は不要と判断した。

