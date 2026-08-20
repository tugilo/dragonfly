# PHASE_301_participants_pdf_csv_cursor_skill WORKLOG

tool: cursor

## 判断

- **Religo に LLM を載せない:** M7-P PDF パーサは CSV 精度に届かず、第218回は Cursor Grok の layout 抽出＋前回 CSV 差分で成立。製品化より **再現可能なスキル**を優先。
- **取込は既存 CLI のみ:** `ImportParticipantsCsvCommand` と Meetings CSV 反映（M7-C）を二重実装しない。
- **PDF→CSV は Grok/Composer:** OpenAI BYO key（SPEC-013）や Cursor SDK は本運用に使わない。

## 第218回 取込結果（2026-08-17）

```bash
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-participants-csv 218 \
  database/csv/religo_218_20260818_full.csv --held_on=2026-08-18
```

- 出力: `Imported 第218回 (id=34): 75 participants.`
- SPEC-007 確認: 横山　大樹・福島　和也・佐藤　久 は guest 行＋member 行の **二重**（入会想定）。マージは未実施。

## スキル設計

- 前週ビジター混在禁止を明文化（第217回 CSV の教訓）
- 取込はユーザー明示時のみ（`/import-religo` と役割分担）
- UTF-8 BOM・全角スペース・引用符ルールを SKILL に固定
