# PHASE MEMBERS-DEDUP-RUNBOOK-P0 — REPORT

## Phase 番号

**MEMBERS-DEDUP-RUNBOOK-P0**（docs・**実装なし**）

## 重複発生条件（要約）

- **CLI 参加者 CSV:** 既存検索が **`type` + `name`**。visitor/guest から **member に変わると一致しない**ため、**同名でも新規 `members` 行**が追加されやすい。  
- **表記ゆれ**で名前が一致しないと別行。  
- **Meeting CSV / PDF Apply** は **resolution・氏名先頭一致**等、**経路ごとに異なる**ため、CLI との **齟齬**が重複や誤結合の原因になりうる。  
- **過去 `participants`** は古い `member_id` を保持しうる（履歴としては正当だが、マスタが分岐すると画面で二重に見える）。

詳細は [MEMBERS_DEDUPLICATION_RUNBOOK.md](../../SSOT/MEMBERS_DEDUPLICATION_RUNBOOK.md) §2–3。

## 業務影響

- 検索・Connections・紹介/1to1/メモ/flags 等が **`member_id` 依存**のため、**履歴分断・同一人二行表示・集計ずれ**。  
- FK **restrict** により単純削除で片付かないケースあり — **付け替え前提**。

## 推奨運用（案 A）

- 名簿・入会確定時に **既存行を正として type/display_no を更新**する方針（SPEC-007 §3.1 と整合）。  
- CSV 投入前の **既存確認**、表記ルール、**本番直 SQL 禁止**。  
- 重複発見時は Runbook §6 の **概念手順**（勝ち ID・付け替え・検証）。

## 将来の補助機能案

- **案 B:** 管理画面で **2 ID 指定・影響件数表示・（将来）トランザクション付け替え**。  
- **案 C:** import 時 **候補提示のみ**・自動確定なし。

## 実装難易度別の選択肢

| 段階 | 内容 |
|------|------|
| 最小 | Runbook・入力規約・手動手順 |
| 標準 | 重複疑いの **一覧表示のみ** |
| 将来 | マージウィザード・監査ログ・候補 UI |

## 作成・更新したドキュメント

| ファイル | 内容 |
|----------|------|
| [MEMBERS_DEDUPLICATION_RUNBOOK.md](../../SSOT/MEMBERS_DEDUPLICATION_RUNBOOK.md) | SPEC-008 新規（Runbook・案 A/B/C） |
| [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) | §3.3 実装整合・§3.4・リンク |
| [SSOT_REGISTRY.md](../../02_specifications/SSOT_REGISTRY.md) | SPEC-008 登録 |
| [INDEX.md](../../INDEX.md) / [dragonfly_progress.md](../../dragonfly_progress.md) / [PHASE_REGISTRY.md](../PHASE_REGISTRY.md) | 索引・進捗・Phase 表 |

## 次に実装するなら何か

1. **標準（小さめ）:** 管理画面または read-only API で **`type` 違い同名**・**類似名**のリスト表示（マージはしない）。  
2. **案 B:** マージの **ドライラン**（影響行の SELECT のみ）→ レビュー後に apply。  
3. **案 C:** CSV 行と `members` の **候補提示**（人手で resolution に落とす — M9 系と統合検討）。

## Merge Evidence

- docs Phase。merge / push はリポジトリ運用に従うこと。
