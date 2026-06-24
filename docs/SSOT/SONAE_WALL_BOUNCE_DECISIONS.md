# SONAE 壁打ち合意事項（PoC 着手前）

**Spec ID:** SPEC-017 補足  
**作成日時:** 2026-06-24 18:22:02 JST  
**最終更新日時:** 2026-06-24 18:35:01 JST  
**正本:** 実装可能な粒度は [SONAE_REQUIREMENTS.md](SONAE_REQUIREMENTS.md)。本文は合意経緯・判断理由の記録。

---

## 1. 位置づけ

| 項目 | 合意 |
|------|------|
| Religo | **オプション**。Religo がなくても SONAE 単体で稼働 |
| DragonFly | Religo 利用のモデルチャプター。会員は Religo `members` に既存 |
| PoC 費用 | DragonFly への開発費・利用料請求なし |
| 実装順 | 要件確定（本 doc）→ core（訓練・LINE・回答）→ Religo adapter → JMA 9種 |

---

## 2. メンバー・ロスター（Member Roster Policy）

### 2.1 原則

- **機能ごとに members テーブルを増やさない**（1 roster + N extensions）
- SONAE 実行時の正（source of truth）は **`sonae_members`**
- Religo 利用時: `members` は**供給元**。`sonae_members` に **1:1 sync（コピー）**
- Religo `members` に **LINE userId は載せない**（SONAE extension のみ）

### 2.2 同期対象

| 項目 | 内容 |
|------|------|
| 対象 | Religo `members` の **`type=member` のみ** |
| 除外 | guest / visitor 等 |
| タイミング（PoC） | 初回 bootstrap + **訓練発報前の手動同期** |
| DragonFly | `workspaces.slug=bni_dragonfly` → `sonae_chapters.external_id` |

### 2.3 Religo `members` に無いもの

現行 Religo `members` には **活動市町村・住所・都道府県** カラムはない（`workspace_id` まで）。

SONAE `sonae_members` も PoC では同様。**活動地域は PoC スコープ外**。

### 2.4 LINE 紐付け

| 保存先 | 内容 |
|--------|------|
| `sonae_line_user_links.line_user_id` | LINE Messaging API の userId |
| `sonae_members.invite_token_hash` | 友だち登録時の本人確認用（任意） |

---

## 3. 通知対象（段階展開）

| 項目 | 合意 |
|------|------|
| 名簿 | 全 active メンバーを `sonae_members` に登録（Religo sync / CSV） |
| Push 通知 | **LINE 友だち登録 + `sonae_line_user_links` 紐付け済みのみ** |
| パイロットフラグ | **不要**。登録率が上がるほど自然に通知対象が増える |
| 未紐付け | 一覧で可視化。訓練前に周知して登録率を上げる |
| 自動発報 | 手動訓練で運用に慣れ、登録率が十分になってから ON 推奨 |

**判断理由:** LINE Push は userId が必要なため、名簿全員と通知対象は一致しない。パイロット用の別フラグは運用が複雑になるため設けず、紐付け状態そのものが段階展開のゲートとする。

---

## 4. 実装テーブル命名

Religo 既存表（`members`, `users`）との衝突回避のため、SONAE 実装 DB は **`sonae_*` 接頭辞** を用いる。概念名（chapters / members）は SSOT ER 図上の論理名として維持する。

---

## 5. 気象庁連携（提案書9種すべて）

### 5.1 データソース

| 項目 | 合意 |
|------|------|
| 正 | [気象庁防災情報 XML（JMAXML）](https://xml.kishou.go.jp/) |
| 方式 | **PULL**（Atom フィード）。PUSH 配信は終了済み |
| 取得単位 | **システム全体 1 ジョブ**（チャプターごとに取得しない） |
| 正規化 | `AlertEvent` + `alert_event_areas` |
| 種別 | 提案書・SSOT §9.3 の **9種すべて** を PoC 対象 |

| code | 名称 |
|------|------|
| `earthquake` | 地震（震度・EEW 含む） |
| `tsunami` | 津波 |
| `heavy_rain` | 大雨 |
| `flood` | 洪水 |
| `landslide` | 土砂災害 |
| `typhoon` | 台風 |
| `heavy_snow` | 大雪 |
| `volcano` | 火山 |
| `nankai_trough` | 南海トラフ |

### 5.2 実装効率

- 取得ジョブは **1 本**
- 種別ごとに **AlertEventNormalizer アダプタ**（クラス）を追加。テーブル・ジョブは増殖させない
- 2026 年以降の警報 XML 体系整理に注意（実装 Phase で公式サンプル XML を参照）

### 5.3 発報判定

1. JMA 取得 → `AlertEvent` 生成  
2. チャプター `chapter_alert_settings`（地域・閾値・ON/OFF）と照合  
3. 合致時に LINE 発報（対象は §3 の紐付け済みメンバー）

---

## 6. 発報条件・閾値（設定画面で柔軟に変更）

### 6.1 原則

- 震度・警報レベル等を **コードにハードコードしない**
- **チャプター単位**・**アラート種別ごと**に管理画面から変更
- 保存後、**次回 JMA 取得サイクルから**新設定を適用

### 6.2 UI

- 管理画面「**発報条件設定**」: 9種一覧 → 種別ごと編集ダイアログ
- 共通: 有効/無効、対象都道府県（複数可）、対象市区町村（任意）
- 種別固有: 閾値（`threshold_code`）— マスタ `alert_threshold_options` から選択肢生成

### 6.3 判定

- Normalizer が `AlertEvent.severity_rank` を付与
- 設定側 `alert_threshold_options.severity_rank` と比較（`>=` で発報）
- 地震の EEW は地震設定内フラグ（例: `include_eew`）または専用 threshold

---

## 7. PoC 完了条件（2段階）

### L1 — 初回訓練（気象庁自動発報なしでも可）

- Religo sync または CSV で `sonae_members` 登録
- LINE 設定・友だち紐付け
- **手動訓練発報**（紐付け済みのみ通知）→ 回答 → 集計・未回答者・訓練履歴

### L2 — 本番準備

- JMA 手動/定期取得（9種 Normalizer）
- 設定画面の発報条件に基づく **自動発報**
- 発報履歴・エラーログ
- 月1訓練の継続運用

---

## 8. 集計・UI（提案書ギャップ反映）

| 項目 | 合意 |
|------|------|
| 被害あり | 安否 `minor_injury` 以上を集計（SSOT §6.4） |
| 訓練回答率比較 | 直前訓練との回答率差分を訓練履歴に表示 |
| 訓練 vs 本番 UI | **同一の安否回答画面・集計 UI**。履歴のみ `training_event_id` で分離 |
| 導入ステップ | 5 ステップ Runbook（SSOT §5.6） |

---

## 9. 将来拡張 — 地域別回答義務

PoC では **LINE 紐付け済みメンバー全員が回答必須**（§3）。

将来、次を追加して運用柔軟化:

| 要素 | 将来 |
|------|------|
| `sonae_members.activity_areas` | メンバーの活動都道府県・市区町村（json 可） |
| `notification_targets.response_requirement` | `required` / `optional` / `excluded` |
| 未回答一覧 | `required` のみ |
| 回答率 KPI | 必須対象ベース |

例: 浜松市警報 → 浜松活動メンバーは必須、静岡市のみのメンバーは通知省略または任意。

---

## 10. 飯田香さん・DragonFly 確認事項（未確定）

SSOT §16.1 に統合。実装前に BCP と合意する。

| # | 項目 |
|---|------|
| 1 | 公式 LINE Messaging API 利用可否 |
| 2 | 自動発報の初期閾値（例: 震度5弱以上） |
| 3 | 対象地域（静岡県全体 vs 市区町村） |
| 4 | 訓練月1回でよいか |
| 5 | 未回答フォロー担当 |
| 6 | 集計閲覧者（役員） |
| 7 | 既存チームスレッド運用との並行/移行 |
| 8 | 災害時の手動本番発報要否（自動 OFF 時） |

---

## 11. 関連 Phase

| Phase | 内容 | 状態 |
|-------|------|------|
| 224 | SONAE 要件定義初版 | completed |
| 241 | PoC 提案書同期 | completed |
| 242 | DB 基盤 implement（途中・保留） | 未 merge |
| 243 | 本壁打ち要件の SSOT 反映 | 本 doc |

---

## 12. 更新履歴

| 日時 | 内容 |
|------|------|
| 2026-06-24 18:22:02 JST | 初版。壁打ち合意を集約 |
| 2026-06-24 18:35:01 JST | LINE 紐付け済みのみ通知対象、段階展開（パイロットフラグなし）、提案書ギャップ（被害あり・回答率比較・導入 Runbook・訓練/本番同一 UI）を追記 |
