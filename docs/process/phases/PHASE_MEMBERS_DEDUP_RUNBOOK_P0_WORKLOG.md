# PHASE MEMBERS-DEDUP-RUNBOOK-P0 — WORKLOG

## 判断

- **SSOT 3.3 の旧記述**「`(type, display_no)` で upsert」は **`ImportParticipantsCsvCommand::resolveOrCreateMember` の実装と不一致**だった。実装は **`where('type', $type)->where('name', $name)`** による検索であり、**type が変わると別レコード**になりやすい — 本文をコードに合わせて修正した。  
- **Apply 系**（`MeetingCsvMemberResolver` / `ApplyParticipantCandidatesService`）は **氏名中心**の経路があり、**CLI と同じ挙動にならない** — 重複・誤結合の両方のリスクとして Runbook §2 に表で固定した。  
- ユーザー指示どおり **推測による自動同一人物判定は採用しない**。将来案は **候補提示・人手確定**が前提。  
- **本番直接 UPDATE は Runbook で禁止**し、マージは「勝ち ID への FK 付け替え」概念のみ（実装は別 Phase）。

## 実施内容

- `MEMBERS_DEDUPLICATION_RUNBOOK.md` 新規（SPEC-008）。  
- SPEC-007 に 3.4 と関連リンク、3.3 修正、変更履歴。  
- SSOT_REGISTRY / INDEX / PHASE_REGISTRY / dragonfly_progress 更新。
