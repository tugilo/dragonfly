# Phase Meetings Participants PDF Requirements — REPORT

**Phase:** Meetings 参加者PDF取込 要件整理  
**完了日:** 2026-03-17

---

## 作成したドキュメント一覧

| ファイル | 説明 |
|----------|------|
| docs/SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md | 要件整理たたき台（機能概要・背景・ユースケース・業務フロー A/B/C・画面・データ・Phase 案・リスク・推奨方針・確認事項） |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_PLAN.md | 背景・目的・調査対象・整理観点・成果物・DoD |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_WORKLOG.md | 既存 Meetings 確認・追加要件・検討した選択肢・判断理由・まとめ |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_REPORT.md | 本 REPORT |

---

## 要件整理の要約

- **目的:** 例会前日に送られるメンバー表 PDF を Meeting に登録し、参加者情報を Religo で管理できるようにする。可能なら PDF から参加者候補を抽出し、人の確認を経て participants に反映する。
- **前提にしないこと:** PDF 解析の 100% 正確性、完全自動登録。
- **業務フロー:** A（PDF 保存のみ）、B（解析→人が確認して登録）、C（自動寄せ）を比較し、**B 案**を推奨。
- **データ:** participants / members は既存のまま利用。PDF 原本・抽出テキスト・抽出結果を保持するため、`meeting_participant_imports` のような取込履歴テーブルを新設する案を記載。
- **Phase 分割:** P1（PDF 保存）→ P2（抽出表示）→ P3（確認・反映）→ P4（member 照合）→ P5（運用改善）。

---

## 推奨方針

- **第一歩:** P1（PDF を Meeting に紐づけて保存）を最初の実装 Phase とする。
- **その次:** B 案に沿って P2〜P4 を段階的に実装（抽出 → 候補表示 → 確認・修正 → 登録確定）。確定は必ず人が行い、自動で participants を上書きしない。
- **C 案・完全自動:** 第一歩では採用しない。将来、PDF 形式が安定し、運用で許容できる場合に検討。

---

## 次に進むなら何をやるか

1. **Product 側の確認:** 実際に届く PDF のサンプルを共有してもらい、レイアウト・表組み・区分の書き方を確認する。テキスト抽出のみで足りるか、OCR が必要かを見る。
2. **ストレージ・権限:** 原本 PDF の保存先（local / S3 等）と、保持期間・アクセス権限のポリシーを決める。
3. **導線の確定:** 「参加者取込」を一覧行アクションで開くか、Drawer 内ボタンか、別タブかを決める。
4. **Phase 番号の取得:** PHASE_REGISTRY で次番号を取得し、P1 実装の PLAN を作成する。P1 の DoD に「既存 Meetings 一覧・Drawer・メモ・BO の導線を壊さないこと」を含める。
5. **実装:** P1 から順に、PLAN → WORKLOG → REPORT と DevOS に従って実施する。

---

## 取り込み証跡（develop への merge 後）

本 Phase は **docs のみ** のため、実装の merge は行わない。develop に docs を commit する場合は、以下を記録する。

| 項目 | 内容 |
|------|------|
| **merge commit id** | （docs のみ commit 時は `git log -1 --format=%H develop` で取得） |
| **merge 元ブランチ名** | feature/phase-xxx-meetings-participants-pdf-requirements 等 |
| **変更ファイル一覧** | docs/SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md, docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_*.md, docs/INDEX.md, docs/process/PHASE_REGISTRY.md |
| **テスト結果** | スキップ（docs フェーズ） |
| **scope check** | OK（docs のみ変更） |
