# WORKLOG — WORKSPACE_CHAPTER_FIT_GAP_P1

## 実施内容

- `www/` 配下で `workspace` 関連の参照密度を確認（Controller / Service / Query / Model / admin JSX）。
- `database/migrations` で `workspace_id` を持つテーブルを一覧化。
- SSOT 上で **「1 チャプター = 1 workspaces 行」** と **chapter という語の非存在**の矛盾を、問題点 P1〜P4 として整理。
- **案 A（chapter 新設）** と **案 B（段階移行・エイリアス）** と **案 C（用語のみ）** を比較し、Fit & Gap 表に落とした。

## 判断

- **即時のスキーマ分割はコスト大** — 先に SSOT と API エイリアスで **業務語 Chapter を正**に寄せるのが現実的（ドキュメント結論 §9）。
- **ONETOONES_CROSS_CHAPTER** で既に `countries` / `regions` / `workspaces.region_id` があるため、「workspace = チャプター行」は **階層の葉**として説明しやすい。
- **Member は 1 Chapter にのみ所属する**業務ルールを前提にすると、**「所属の複雑化」対策ではなく「業務語として Chapter を正にする」**ことが設計の主題になる。多所属用スキーマは不要。
- **名簿を国・地域・チャプター横断で見る**ことは **検索・参照範囲**の話であり、**1 Member が複数 Chapter に所属する**こととは別。Fit & Gap から多所属前提の含みを削った。

## 修正（2026-04-17）

- 主ドキュメントに **§0 確定業務ルール**・定義文・**Member 単一所属**に沿った Fit & Gap（members 行の重さコメント）・案 A/B/C の相性・§7.3 非推奨・§8 次 Phase（多所属 Phase を外す）・§9 結論を追記・整合。

## 詰まりポイント

- なし（ドキュメントのみ）
