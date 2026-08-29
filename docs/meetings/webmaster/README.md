# Webマスターチーム 議事録（docs/meetings/webmaster/）

**11期の入口:** [webmaster_term11.md](webmaster_term11.md)（人・URL・現状・Religo。これを見れば辿れる）

## 役割

BNI **DragonFly チャプター**の **Webマスターチーム**（朝礼スライド・定例会 Zoom 操作・ビジタースライド等）に関する打合せ・引き継ぎ・運用確認の議事録を置く。

- **1to1（倉持×次廣 等）** → [`../1to1/`](../1to1/)（個別関係の履歴）
- **定例会** → [`../chapter/`](../chapter/)
- **Webマスターチーム MTG** → **本ディレクトリ**
- 元 WM（退会済）からの知見移転も本ディレクトリ（例: [`webmaster_kudo_yuji_20260821.md`](webmaster_kudo_yuji_20260821.md)）

## ファイル命名

```
webmaster_<topic>_YYYYMMDD.md
```

例: `webmaster_handover_20260603.md`（一部引き継ぎ）、`webmaster_kudo_yuji_20260821.md`（元 WM 知見移転）、`webmaster_handover_20260822.md`（9・10期倉持→11期次廣の棚卸し）

## YAML front matter（推奨）

| キー | 例 | 備考 |
|------|-----|------|
| `doc_type` | `webmaster_meeting` | 固定 |
| `chapter` | `bni_dragonfly` | |
| `session_date` | `2026-06-03` | 開催日（不明時は TODO） |
| `session_time_jst` | `TODO` | 要確認時は `session_time_note` と併記 |
| `format` | `zoom` | |
| `source` | Zoom 文字起こし要約 | 取得元 |
| `related_1to1` | `meetings/1to1/1to1_kuramoto_kenichi_webmaster.md` | 関連 1to1 があれば |
| `nextcloud_share_url` | ST定例会 NextCloud 共有 URL | 運用リンク SSOT |
| `visitor_slide_tool_url` | ビジタースライド生成 URL | 運用リンク SSOT |

## 運用リンク（参照）

| 用途 | URL |
|------|-----|
| NextCloud 共有（ST定例会） | https://ne-dragonfly.site/cloud/index.php/s/E3a37t3pPsAJB8q?path=%2F |
| ビジタースライド自動生成 | https://ne-dragonfly.site/genslide/ |
| 11期 PC環境アンケート（回答） | https://docs.google.com/forms/d/e/1FAIpQLSfdmk-vyV-EX9f5ysH9xKoOU1_mFmEJIW0QSX087Hrom3kvjA/viewform |
| 11期 PC環境アンケート（編集） | https://docs.google.com/forms/d/1OwAoEbVkUGTaMkcTKtC8KmUR5yW1YLmfdCjHkh-hDYw/edit |
| 11期 PC環境アンケート（回答シート） | https://docs.google.com/spreadsheets/d/1IZN1u1OjXMvDVZTrnQHEYG05YqsxcejqkB-D5GHQVTg/edit |
| 11期 第1回ミーティング（調整さん） | https://chouseisan.com/s?h=b220119717c94e9bb43606c0f29973bb |

## タスク棚卸し

倉持さんが抱えている仕事の見える化。所要時間は未記入。判断（残す／やめる等）は操作習得後に切る。区分「個人・良かれ」は役職必須ではなく倉持さんが足したもの。

| ファイル | 用途 |
|----------|------|
| [webmaster_task_inventory_20260822.csv](webmaster_task_inventory_20260822.csv) | **正本。** WM-01〜54 |
| [Sheets](https://docs.google.com/spreadsheets/d/1TWadVczKpOXQTy76-3cij-kYOTfFi2eGl7bHyoKrsh4/edit) | 作業用シート |
| [webmaster_task_inventory_20260822.md](webmaster_task_inventory_20260822.md) | 列の意味・使い方 |
| [webmaster_term11.md](webmaster_term11.md) | **11期の入口**（2026-08-29 10:00 JST）。人・URL・現状・Religo |
| [webmaster_support_invite_20260826.md](webmaster_support_invite_20260826.md) | 11期サポートお声がけ。5名快諾（2026-08-26 23:57 JST 閉じ） |
| [webmaster_term11_goals_20260827.md](webmaster_term11_goals_20260827.md) | 11期の目標・課題・チームの約束（2026-08-27 00:36 JST）。役割は未決 |
| [webmaster_term11_messenger_group_20260828.md](webmaster_term11_messenger_group_20260828.md) | 11期グループ開設メッセージ（2026-08-28 23:56 JST 送信済み） |
| [webmaster_term11_pc_survey_20260828.md](webmaster_term11_pc_survey_20260828.md) | PC環境アンケート（2026-08-29 08:59 JST）。公開済み。OS質問追加。Jobなし |
| [webmaster_term11_meeting1_chouseisan_20260829.md](webmaster_term11_meeting1_chouseisan_20260829.md) | 第1回ミーティング調整さん（2026-08-29 09:59 JST 送信済み）。Jobなし |

## 関連

- 倉持 賢一 との 1to1 履歴: [`../1to1/1to1_kuramoto_kenichi_webmaster.md`](../1to1/1to1_kuramoto_kenichi_webmaster.md)
