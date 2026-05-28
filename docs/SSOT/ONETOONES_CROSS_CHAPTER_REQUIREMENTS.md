# 1 to 1 とチャプター外（他チャプター BNI メンバー）— 目的・効果・要件・実装

**Spec ID:** SPEC-006（[SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md) 参照）  
**ステータス:** active（**解釈 A 確定**・API/UI/階層 DB 反映済み。**記録:** Phase **ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1**）  
**関連 SSOT:** [DATA_MODEL.md](DATA_MODEL.md)、[MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md](MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md)、[DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md](DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md)（guest/visitor 除外）、[WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)

---

## 1. 背景

BNI の 1 to 1 は、**自チャプターのメンバー**だけでなく、**他チャプターのメンバー**（ビジター・合同例会・紹介経由など）と行うことがある。Religo では、それらを **単なる「自分の仕事」の記録**にとどめず、**今後どの人とどうつながっていくか**の判断材料として蓄積したい。

---

## 2. 目的

| 目的 | 説明 |
|------|------|
| **記録の一貫性** | チャプター外相手との 1 to 1 も、チャプター内と同様に **予定・実施・メモ**として残し、接触履歴・ダッシュボード・メンバー文脈で参照可能にする。 |
| **関係の地図の拡張** | 「自会のメンバー同士」だけでなく、**他チャプターとの接点**をデータ上で区別・検索できる土台にする。 |
| **次のアクションの材料** | 紹介・フォロー・次回 1 to 1 の候補を考えるとき、**どのチャプター・どの業種・どの経路**でつながったかを振り返れるようにする。 |

---

## 3. 期待される効果

- **オーナー視点:** 自分のネットワークが **チャプター境界をまたいで**可視化され、紹介やコラボの着想がしやすくなる。
- **運用:** 合同・ビジター往来が多いチャプターでも、**記録漏れ**を減らし、後から「いつ誰と話したか」を SSOT に近い形で追える。
- **将来機能:** Introduction ヒント・リード一覧・検索で **「自チャプター優先 / 他チャプターも含む」** などの切り替えを載せるための **データ上のフック**になる。

---

## 4. 確定方針（解釈 A）

### 4.1 `one_to_ones.workspace_id` の意味

- **`one_to_ones.workspace_id` は記録コンテキスト**である。
- 通常は **オーナー（owner）側の所属チャプター**に対応する `workspaces.id` を送る。
- **`target_member` は別チャプター所属（`members.workspace_id` が記録コンテキストと異なる）でもよい。**
- 例: DragonFly 所属オーナーが他チャプター所属メンバーと 1 to 1 した行は、`workspace_id = DragonFly の workspace` で保持し、相手の所属は `target_member` 経由で表現する。

### 4.2 地理階層（国 > リージョン > チャプター）

- **Country > Region > Workspace（チャプター）** を DB で表現できる（`countries` / `regions` / `workspaces.region_id`）。詳細は [DATA_MODEL.md](DATA_MODEL.md) §4.0.1–4.1。
- 既存 `workspaces.region_id` は **nullable** で導入し、**全件のバックフィルは必須としない**（運用で徐々に紐付け可能）。

### 4.3 残る任意課題（非スコープでないが未実装）

| ID | 要件 | 状態 |
|----|------|------|
| R1 | 別チャプター target の 1 to 1 | **可**。バリデーションは `exists:members,id` のみ。 |
| R2 | 一覧で「自チャプター相手のみ」等のフィルタ | **将来**（API は `is_cross_chapter` 等で識別可能）。 |
| R3 | 相手が DB 未登録 | **未決**（guest 仮登録等）。 |

---

## 5. 実装（API / UI）

### 5.1 1 to 1 一覧・詳細（GET `/api/one-to-ones` / `/{id}`）

返却に以下を含む（null 安全・既存キーは維持）:

- `recording_workspace_name` — 行の `workspace_id` に対応するチャプター名
- `target_workspace_id` / `target_workspace_name`
- `target_region_id` / `target_region_name` / `target_country_id` / `target_country_name`（階層が無い場合は null）
- `is_cross_chapter` — 記録コンテキストの `workspace_id` と `target_workspace_id` が **両方非 null かつ異なる**とき `true`

### 5.2 メンバー API（`GET /api/dragonfly/members` / `{id}`）

各メンバーに `workspace_name`, `region_*`, `country_*` を **フラット追加**（`MemberWorkspaceAttributes`）。相手 Autocomplete のラベル・1 to 1 サマリカードで利用。

### 5.3 管理画面 UI

- **1 to 1 一覧:** 相手列にチャプター名を括弧表示し、他チャプター時は **「他チャプター」** Chip。
- **相手サマリ:** 所属チャプター／リージョン／国を表示（データがある場合）。

---

## 6. ギャップ・リスク（更新）

| 項目 | 内容 |
|------|------|
| **データ登録** | 他チャプター相手が **`members` にいない**と 1 to 1 を POST できない点は変わらない。 |
| **表示・リード** | Dashboard「次の 1 to 1 候補」の **guest/visitor 除外**は別 SSOT（SPEC-005）。クロスチャプター全面改修はしていない。 |
| **検索・フィルタ** | 「他チャプターとの 1 to 1 のみ」一覧フィルタは **未実装**（API 拡張で可能）。 |

---

## 7. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-04-03 | 初版。目的・効果・要件たたき台・実装確認・ギャップを記載。 |
| 2026-04-08 | 解釈 A 確定・階層 DB・API/UI 反映（ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1）。 |
