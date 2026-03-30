# SSOT Registry

このプロジェクトのSingle Source of Truth一覧。
AIは仕様を参照する際、必ずこの一覧を起点とする。

| Spec ID | Spec Name | File | Status |
|---|---|---|---|
| SPEC-001 | Religo システム全体仕様 | system_requirements.md | draft |
| SPEC-002 | 接触ロジック整合（last_contact・999・1to1 completed） | ../SSOT/CONTACT_LOGIC_ALIGNMENT.md | active |

## Statusの値
- active     : 現在有効なSSOT
- draft      : 作成中・未確定
- deprecated : 廃止（参照禁止）

## ルール
- 新しい仕様ファイルを作成したら必ずこのRegistryに登録する
- deprecatedになった仕様は削除せず状態を変更して残す
- Spec IDは SPEC-### の形式で連番管理する

## 既存 SSOT（docs/SSOT/）との対応

本プロジェクトでは docs/SSOT/ 配下にも仕様が存在する。新規 Phase で参照する際は、必要に応じて本 Registry に Spec ID を追加し、該当ファイルを登録すること。
