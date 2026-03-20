# PLAN: DASHBOARD-P7-1（Dashboard モック寄せ UI 再構成）

| 項目 | 内容 |
|------|------|
| Phase ID | **DASHBOARD-P7-1** |
| 種別 | implement |
| Related SSOT | `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`、`docs/SSOT/DASHBOARD_DATA_SSOT.md`、`docs/SSOT/DATA_MODEL.md` |
| 前提 | ONETOONES-P5/P6 完了。`GET /api/dragonfly/members/one-to-one-status` 利用可。 |
| ブランチ（想定） | `feature/phase-dashboard-p7-1-ui` |
| モック比較 | `www/public/mock/religo-admin-mock-v2.html` `#pg-dashboard`（レイアウト意味の SSOT）。活動の左右配置は P7-1 仕様で主列に寄せる。 |

---

## 1. ゴール

1. ダッシュボードの**レイアウト**をモックの意味構造に近づける（上段 KPI 4 → 下段 2 カラム）。
2. **主構成:** Tasks / Shortcuts / Activity を左列に縦に整理。
3. **補助:** P5/P6 の Leads を右列（340px 相当）に再配置。削除しない。
4. P7-2（データ・導線）向けにコンポーネント境界を切る。

---

## 2. スコープ

### 対象

- `www/resources/js/admin/pages/Dashboard.jsx` の再構成
- `www/resources/js/admin/pages/dashboard/*` の新規コンポーネント（必要最小限）
- 見出し・カード・余白・ブレークポイント
- 空状態・ローディングの最低限整理

### 対象外

- KPI 集計・例会「あとN日」動的化・Tasks メモ有効化・Activity kind 追加
- API・認証の変更
- Dashboard 全面リデザイン（ピクセル完全一致）

---

## 3. レイアウト（確定）

| 領域 | 内容 |
|------|------|
| 上 | `DashboardHeader`（タイトル・CTA・Owner セレクタ）＋ 既存オーナー設定カード |
| 上段 | `DashboardKpiGrid`（4 カード） |
| 下段左（1fr） | Tasks → Shortcuts → Activity |
| 下段右（340px, md+） | Leads（sticky 可）。オーナー未設定時は説明文のみ |

---

## 4. DoD

- [ ] 上記レイアウトが実装されている
- [ ] Leads のデータ・空状態文（P6）が維持されている
- [ ] `npm run build`・`php artisan test` 通過
- [ ] PLAN / WORKLOG / REPORT・PHASE_REGISTRY・INDEX・`dragonfly_progress.md` 更新
- [ ] Merge Evidence は develop 取り込み後に REPORT へ追記

---

## 5. リスク

- 狭幅で Leads が主列の下に落ちる際の順序（左列完走後に右列＝仕様どおり）。
