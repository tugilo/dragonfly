# PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK — REPORT

**Phase ID:** MEETINGS_DELETE_FIT_AND_GAP_CHECK  
**種別:** docs  
**ステータス:** completed  
**日付:** 2026-03-19

---

## 調査結果サマリ

Meetings の **DELETE API/UI は未実装**。モック・FIT_AND_GAP にも **例会削除の要件は見当たらない**。一方 DB では `meeting_id` に **cascadeOnDelete** が付いた子が多く、**物理削除すると参加・BO・PDF・CSV・監査ログまで連鎖削除**される。`contact_memos` 等は **nullOnDelete** で **本文残存・参照だけ外れる**。業務上は **編集で足りる場面**と **履歴抹消欲求**の切り分けが **未確定（要合意）**。削除を実装する前に **許可条件・メモ・ファイルストレージ・number 再利用・権限**を決め、`DATA_MODEL` に SSOT 化するのが望ましい。

## 作成・更新したドキュメント

| ファイル | 役割 |
|----------|------|
| `docs/SSOT/MEETINGS_DELETE_FIT_AND_GAP.md` | Fit/Gap、子一覧、案 A〜E、推奨、実装前の決定事項、次 Phase |
| `docs/process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_PLAN.md` | PLAN |
| `docs/process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_WORKLOG.md` | WORKLOG |
| 本 REPORT | 要約・DoD・Merge Evidence |
| `docs/INDEX.md` | SSOT・Phase へのリンク追加 |
| `docs/process/PHASE_REGISTRY.md` | 本 Phase 登録 |
| `docs/dragonfly_progress.md` | 1 行追記 |

## Fit

- **実装に DELETE がない**ため、現状ユーザーが誤って例会行を消せない。  
- **モックとも矛盾しない**（削除なし）。  
- **DATA_MODEL** に FK の cascade/null が既に記載されており、調査の根拠になった。

## Gap

- **削除ポリシー・許可条件・UI 導線**が SSOT にない。  
- **アプリで DELETE を追加すると DB cascade と組み合わさり**、説明なしでは **過大なデータ喪失**になり得る。  
- **PDF ファイル実体**の扱いは migration からは断定不可（要確認）。  
- **number 再利用**の運用が未記載。

## 推奨方針（要約）

- **無条件 DELETE（案 B）を一般 UI に載せない。**  
- 削除が必要なら **案 A または E（条件付き）** ＋ 確認 UI ＋ **DATA_MODEL への SSOT 追記**を先に行う。  
- 履歴重視なら **案 D（非表示/アーカイブ）または C（論理削除）** を別途設計。  
- **ステークホルダー合意**で §9 の表を確定させてから implement Phase へ。

## 次に進むなら何をやるか

1. 合意形成（削除が要るか、条件は何か）  
2. `DATA_MODEL.md` §4.6 に削除またはアーカイブの SSOT を追加する **短い docs Phase**  
3. **別 implement Phase:** `DELETE` または `PATCH archived` + 条件チェック + テスト + UI（モック比較）

## 実装をまだやらない理由

本 Phase の目的は **判断材料の整理**であり、**ポリシー未確定のまま DELETE を実装するとデータ喪失リスクが高い**ため。ユーザー指示どおり **docs only** とした。

## Merge Evidence

**種別:** docs — `php artisan test` 対象外。  
develop 取り込み後、merge commit id・ブランチ名を追記すること（[PRLESS_MERGE_FLOW.md](../../git/PRLESS_MERGE_FLOW.md)）。

**changed files:** `MEETINGS_DELETE_FIT_AND_GAP.md`、`PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_*`、INDEX、PHASE_REGISTRY、dragonfly_progress（**アプリコード 0 件**）  
**scope check:** OK（docs のみ）  
**code change:** **なし**
