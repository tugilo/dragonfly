# Phase 323 WORKLOG — 1to1 の手動登録ルールを明確にし、`one_to_ones.id` を正とする

tool: cursor

---

## 2026-11-06 10:39 JST — 調査（読み取りのみ）

**判断:** ルールを書く前に「経路を問わず衝突しないか」をコードと DB で確かめる。ルールが守るべき範囲（コードで守られている所／運用で守る所）を分けるため。

確認したこと:

- `one_to_ones` のインデックス: 一意は `PRIMARY(id)` のみ。`zoom_meeting_id`・`zoom_meeting_uuid`・`(owner_member_id, target_member_id)` は一意でない。
- `zoom_meeting_imports`: `zoom_imports_user_uuid_unique (user_id, zoom_meeting_uuid)`。
- `ZoomImportApplyService`: 既存行の探索は UUID 一致 → 予定の会議 ID 一致（UUID 未設定の行のみ）→ 同じ owner＋相手＋同じ日（手動行も対象）。見つかれば新規作成せず紐づけ、空欄の実時刻・会議 ID・UUID だけ補う。`status` は変えない。
- `OneToOneController::store`／`OneToOneService::store`（手動登録）: 重複チェックなし。
- 議事録取込（`OneToOneNotesImportService`）: 既存 id の notes 更新のみ。回の見出しが無いファイルは「notes にファイル名を含む行」→ 本文の id の順で当てる。
- ローカル DB（2026-11-06）: 同じ owner＋相手＋同じ日（キャンセル除く）の重複 0 件、同じ UUID・同じ会議 ID の重複 0 件。取込候補には「予定」と「実施」が同じ会議 ID で2行ずつ並び、実施側の多くが `pending` のまま。

**結論:** `one_to_ones.id` は既に唯一の識別子として機能している。手動行を後から Zoom 取込が上書き・重複させることもない（同日判定）。弱いのは、手動登録側の重複チェックが無い点（G1）、相手 `members` 行の分裂（G2）、予定→実施の昇格が無い点（G3）など。いずれもコード変更が要るので本 Phase では記録に留める。

## 2026-11-06 10:42 JST — ルール改訂

**判断:** 「Zoom 取込済み id を正」から「`one_to_ones.id` を正、作り方は Zoom 取込か手動登録」に言い換える。「新規行を作らない」は「同じ日・同じ相手の行があれば作らない」に限定し、相手主催の回を保留にしないことを明記する。

- `docs/meetings/1to1/README.md`: §重複防止 → §登録経路と ID の正。2経路の表、相手主催 Zoom の見分け方（次廣の場合の目安）、手動登録前の3確認、後からの Zoom 取込の挙動、やめること。西原事例と統合手順は残した。
- `.cursor/rules/1to1-dedup.mdc`: 同じ構成に書き直し。補足資料がある相手は本編ファイル指定で取り込む旨も追加（G6 対策の運用）。
- `.claude/skills/import-religo/SKILL.md`・`.agents/skills/import-religo/SKILL.md`: 1to1 の重複防止節を同内容に差し替え（両スキルの他の差分には触れない）。
- `.cursorrules`: 1to1 の1行を、ID の正と2経路が分かる文に差し替え。
- `docs/meetings/1to1/_TEMPLATE.md`: 各回の基本情報に実施方法の選択肢と「Religo 1to1 レコード」行を追加。

## 2026-11-06 10:45 JST — SSOT 追記

- `docs/SSOT/DATA_MODEL.md` §4.12: 「ID の正」段落を追加。
- `docs/SSOT/ZOOM_IMPORT_DEDUP_REQUIREMENTS.md`: §11 登録経路と ID の正（方針・守られている5点・ギャップ G1〜G6）。変更履歴を §12 に繰り下げ。
- `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md` §6: 相手ホストの注記に手動登録への参照。

過去 Phase の文書にある「README §重複防止」の参照は当時の記録なので変更しない。既存議事録の「新規行禁止」表記の一括書き換えも対象外（PLAN どおり）。
