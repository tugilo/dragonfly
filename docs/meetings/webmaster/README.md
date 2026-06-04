# Webマスターチーム 議事録（docs/meetings/webmaster/）

## 役割

BNI **DragonFly チャプター**の **Webマスターチーム**（朝礼スライド・定例会 Zoom 操作・ビジタースライド等）に関する打合せ・引き継ぎ・運用確認の議事録を置く。

- **1to1（倉持×次廣 等）** → [`../1to1/`](../1to1/)（個別関係の履歴）
- **定例会** → [`../chapter/`](../chapter/)
- **Webマスターチーム MTG** → **本ディレクトリ**

## ファイル命名

```
webmaster_<topic>_YYYYMMDD.md
```

例: `webmaster_handover_20260603.md`（引き継ぎ・業務分担確認）

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

## 関連

- 倉持 賢一 との 1to1 履歴: [`../1to1/1to1_kuramoto_kenichi_webmaster.md`](../1to1/1to1_kuramoto_kenichi_webmaster.md)
