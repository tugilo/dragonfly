# PLAN: ONETOONES_DASHBOARD_TARGET_PREFILL_P4 — target プリフィル導線の統一

**Phase ID:** ONETOONES_DASHBOARD_TARGET_PREFILL_P4  
**種別:** implement（API + フロント）  
**Related SSOT:** [ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md](../../SSOT/ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md)、[ONETOONES_CREATE_UX_REQUIREMENTS.md](../../SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md)

---

## 1. 背景

Create / Edit / Quick Create のフォームは P1〜P3 で揃った。一方、**「この人で 1to1 を登録」**への導線は URL クエリで一部実装済みだが、**Tasks（stale）** と **Create 側の検証**にギャップがあった。

---

## 2. 目的

1. **`target_member_id` の受け渡しを URL クエリに統一**（SSOT）。
2. Create で **オーナースコープのメンバー一覧**に基づき prefill を検証する。
3. Dashboard Tasks の **1to1予定** から **相手付き**で Create へ遷移できるようにする。

---

## 3. スコープ

### 3.1 対象

| 領域 | 内容 |
|------|------|
| API | `DashboardService::getTasks` stale 行の `href` |
| フロント | `OneToOnesCreate.jsx` — scoped 検証 |
| フロント | `OneToOnesList.jsx` Quick Create — `useSearchParams` + prefill |
| テスト | `DashboardApiTest` 1st stale の href |
| SSOT | `ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md` |

### 3.2 対象外

- 所要時間カスタム、Dashboard 大規模リデザイン、Leads ロジック変更、自動 1to1 作成。

---

## 4. DoD

- [x] `ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md` がある  
- [x] Create が scoped API で `target_member_id` を検証する  
- [x] Tasks stale の 1 行目が `?target_member_id=` 付き  
- [x] Quick Create が一覧 URL の `target_member_id` を解釈可能  
- [x] test / build 通過、merge / Evidence 完了  

---

## 5. モック比較

- 本 Phase は導線・初期値の整合。モック差分は必要に応じて [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) を参照。
