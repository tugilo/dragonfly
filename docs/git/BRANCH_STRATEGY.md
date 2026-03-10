# Branch Strategy

## ブランチ構成

| ブランチ | 用途 |
|---|---|
| main | 本番環境 |
| develop | 開発統合 |
| feature/phaseXXX-name | Phase作業 |

## ブランチ命名規則

feature/phaseXXX-<n>

例:
feature/phase001-devos-setup
feature/phase002-qr-url-restore

## mergeルール

feature/phaseXXX-xxx → develop  （Phase完了時）
develop              → main     （リリース時のみ）

## ルール

- ブランチ名は必ずPhase IDを含める
- Phase IDとブランチ名はPHASE_REGISTRYと一致させる
- mainへの直接pushは禁止

## 関連

- 取り込み手順の詳細: [PRLESS_MERGE_FLOW.md](PRLESS_MERGE_FLOW.md)
