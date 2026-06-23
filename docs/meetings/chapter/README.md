# DragonFly チャプター定例会 議事録（docs/meetings/chapter/）

## 役割

BNI **DragonFly チャプター**の定例会および **定例会回数に含めない** チャプターイベントの議事録を Markdown で残す。

| 種別 | ディレクトリ | front matter `doc_type` | `meeting_number` | Religo `meetings.number` |
|------|--------------|-------------------------|------------------|---------------------------|
| **週次定例会** | 本ディレクトリ | `chapter_weekly` | **必須**（例: 211） | 取り込み時に付与 |
| **モメンタムトレーニング** | 本ディレクトリ | `chapter_momentum` | **付けない** | **付与しない** |
| **BOD（ビジネスオープンデイ）** | 本ディレクトリ | `chapter_bod` | **付けない** | **付与しない** |

- **1to1** → [`../1to1/`](../1to1/)
- **チーム MTG**（スリーバイス等）→ [`../team/`](../team/)

### 定例会回数に含めないイベント（重要）

火曜の定例会枠、または別日でも、次は **「第 N 回定例会」ではない**。

| イベント | 例（DragonFly） | 備考 |
|----------|-----------------|------|
| **モメンタムトレーニング** | 2026-06-16 | BOD 向け学び。定例会 **9回目扱い** など期のカウントは別軸 |
| **BOD** | **2026-07-28（月）** | 半期一度のビジネスオープンデイ。定例会の **回数は進まない** |
| **その他** | GBM 等 | 公式カレンダーで定例会が休止・代替の場合も **回数を進めない** |

**次の定例会回数** は、直前の **通常定例会** の `meeting_number + 1` でよい（例: 第211回の次は **第212回** = 2026-06-23。その間の 6/16 モメンタムは **212ではない**）。

front matter では `last_chapter_meeting_number` / `next_chapter_meeting_number` で **前後の定例会** を参照する（モメンタム・BOD 用）。

---

## ファイル命名

```
chapter_weekly_YYYYMMDD.md   … 通常定例会（meeting_number あり）
chapter_weekly_YYYYMMDD.md   … モメンタムも同パターン可（doc_type で区別）
chapter_bod_YYYYMMDD.md      … BOD（月曜開催など doc_type: chapter_bod）
```

例:

- `chapter_weekly_20260609.md` — 第211回定例会
- `chapter_weekly_20260616.md` — モメンタム（**第212回ではない**）
- `chapter_bod_20260728.md` — BOD（**定例会回数外**）
- `chapter_weekly_20260623.md` — 第212回定例会

---

## YAML front matter（推奨）

### 通常定例会（`doc_type: chapter_weekly`）

| キー | 例 | 備考 |
|------|-----|------|
| `doc_type` | `chapter_weekly` | 固定 |
| `chapter` | `bni_dragonfly` | |
| `meeting_number` | `211` | **`meetings.number` に対応。必須** |
| `session_date` | `2026-06-09` | 開催日 |
| `session_time_jst` | `09:00-11:00` | 要確認時は `session_time_note` と併記 |
| `format` | `zoom` | |
| `source` | Zoom 文字起こし要約 | 取得元 |

### モメンタム / BOD（回数外）

| キー | 例 | 備考 |
|------|-----|------|
| `doc_type` | `chapter_momentum` / `chapter_bod` | |
| `session_type` | `momentum_training` / `business_open_day` | |
| `session_date` | `2026-06-16` / `2026-07-28` | |
| `last_chapter_meeting_number` | `211` | 直前の **通常** 定例会 |
| `next_chapter_meeting_number` | `212` | 次の **通常** 定例会（予定） |
| **`meeting_number`** | — | **キー自体を付けない** |

---

## 添付・関連データ

参加者 CSV・PDF は [`docs/pdf/`](../pdf/) 配下の日付フォルダに置き、議事録本文からリンクする。

- 定例会: `dragonfly_{N}_{YYYYMMDD}_*.csv`
- 回数外: `dragonfly_momentum_{YYYYMMDD}_*.csv` 等（回番号をファイル名に含めない）

---

## Religo / DB 連携

**source of truth = 本ディレクトリの Markdown。** DB は取り込みコピー（一方向）。

### 取り込み

```bash
# 1ファイル
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-chapter-minutes docs/meetings/chapter/chapter_weekly_20260512.md

# ディレクトリ一括（chapter_weekly_* / chapter_bod_*）
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app \
  php artisan dragonfly:import-chapter-minutes docs/meetings/chapter/
```

| 種別 | DB キー | 備考 |
|------|---------|------|
| 通常定例会 | `meetings.number` | `meeting_number` 必須 |
| モメンタム | `session_type=momentum_training` + `held_on` | `number` は **NULL** |
| BOD | `session_type=business_open_day` + `held_on` | `number` は **NULL** |

**注意:** `chapter_weekly_*_momentum_script.md` / `*_momentum_bor_*.md` は **進行原稿・個人原稿** であり、議事録本体と同じ `meetings` 行を上書きする。一括取り込み後は **必ず** `chapter_weekly_YYYYMMDD.md`（議事録本体）を再取り込みすること。

参加者 CSV は `dragonfly:import-participants-csv`（番号なしイベントは `meeting_number` に `-`、`--session-type` / `--held_on` を指定）。

### front matter（取り込み照合用）

| キー | 用途 |
|------|------|
| `meeting_number` | 通常定例会のみ → `meetings.number` |
| `session_type` | モメンタム / BOD → `meetings.session_type` |
| `session_date` | `meetings.held_on` |

詳細: [CHAPTER_MINUTES_REQUIREMENTS.md](../../SSOT/CHAPTER_MINUTES_REQUIREMENTS.md) / [MEETING_DOMAIN_IA.md](../../SSOT/MEETING_DOMAIN_IA.md)
