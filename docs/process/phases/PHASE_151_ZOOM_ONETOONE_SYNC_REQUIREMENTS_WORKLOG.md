# PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS WORKLOG

## Task1 - SSOT 要件本体の作成
- 状態: 完了
- 判断: 連携対象を **1 to 1 のみ**に絞り、定例会・チーム MTG は除外した（誤取り込み防止・スコープ明確化）。要約取得（R2）は Zoom プラン依存のため Must ではなく段階2 / Should とし、取得不可時は手動要約継続にフォールバックする方針にした。相手の正規化は **自動同一人物判定をせず、必ず人の確認を挟む**方針とし、新規器を作らず M7/M8 系（CSV 取込）のメンバー解決・候補提示・手動マッチングを流用する前提にした。
- 実施: docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md を新規作成。背景/目的/要件サマリ（R1〜R8）/機能要件/正規化フロー/Zoom API 前提/重複防止/取り込み UI/段階/リスク/カレンダー非採用理由/DoD/変更履歴を記載。
- 確認: ユーザー提示の 3 点（R1 予定起票・R2 要約取得・R3 相手正規化）がすべて機能要件に展開されていることを確認。

## Task2 - 重複防止・突合キーの方針
- 状態: 完了
- 判断: 再取り込みで二重登録しないよう、`one_to_ones` に `zoom_meeting_id` / `zoom_meeting_uuid` / `external_source` を持たせる方針を要件に明記。予定は `zoom_meeting_id`、実施は `zoom_meeting_uuid` で突合し、planned→completed 更新を可能にする。DATA_MODEL §4.12 へのカラム追記は実装 Phase で行うため SSOT 更新要として残した。
- 実施: §7・§10・DoD に記載。
- 確認: 突合ルール（予定/実施）と planned→completed 更新の整合を確認。

## Task3 - カレンダー連携の扱い
- 状態: 完了
- 判断: 直前の検討（Zoom 取り込みで実績時刻まで取れる／カレンダーは予定のみ）を踏まえ、iCal/Google カレンダー連携は **当面非採用**とし理由を §11 に明記。対面・非 Zoom 用に手入力フォームは残す。
- 実施: §2.1 非目標・§11 に記載。
- 確認: 「カレンダー連携は不要」というユーザー結論と矛盾しないことを確認。

## Task3.5 - 登録要否の複数選択 UI（R9 追加）
- 状態: 完了
- 判断: Zoom には BNI 以外（社内・営業・私用）のミーティングも含まれるため、「1to1 候補だけを出す」のではなく **取得一覧を全件表示し、人が複数選択して登録要否を決める** 方式を中核 UX とした。判定漏れ（候補にならなかった本物の 1to1）も人が拾える。BNI 以外は既定未選択、既登録（§7 突合済み）はグレーアウトでスキップし誤登録・二重登録を防ぐ。
- 実施: §3 に R9 追加、§4.4 を「判定・除外・登録要否の選択」に拡張、§8 を複数選択リスト（列定義・一括操作・確定・監査）として詳細化、§9 段階1・DoD・変更履歴を更新。
- 確認: ユーザー指摘（BNI 関係ない会議の除外・複数選択で簡単に登録）が §4.4・§8・R9 に反映されていることを確認。

## Task3.6 - API キー等の保管方針（.env）
- 状態: 完了
- 判断: API キー等のアプリ資格情報（Client ID/Secret・S2S Account ID・Webhook Secret）は **`.env` に置き `config/services.php` 経由で参照、ハードコード禁止**とする。ユーザーごとに動的発行されるアクセス/リフレッシュトークンは静的設定の `.env` ではなく **DB に暗号化保存**と区別した。`.env` は手動編集せず PHP スクリプトで追記（.cursorrules 準拠）。
- 実施: §6 にキー保管行・注意書き・想定キー名（ZOOM_CLIENT_ID 等）を追記、§10 リスク・DoD・変更履歴を更新。
- 確認: ユーザー指摘「API キーは .env に保存」が §6 に反映され、動的トークンとの保管先の違いも整理されていることを確認。

## Task3.7 - Zoom 公式ドキュメント精査（§6.1）
- 状態: 完了
- 判断: 「実際に何が可能か」を裏取りするため Zoom 公式 API Reference を精査し、要件 R1〜R5 を具体的な API/Webhook にマッピングした。要約（R2）は **AI Companion／クラウド録画＋文字起こしのプラン依存**で取得不可の環境があるため Should かつフォールバック前提を再確認。実装の落とし穴（UUID 二重エンコード・参加者 email 欠落・レート制限 429／ページネーション・UTC→JST）を明文化した。取得系（read）スコープのみとし作成・変更系は要求しない方針を固定。
- 実施: §6.1（共通仕様・要件マッピング表・Webhook・想定スコープ・制約）を追記。DoD・変更履歴を更新。出典 URL を引用。
- 確認: R1=List meetings、R4=past_meetings instances/details、R3=past participants、R2=Meeting Summary / Cloud Recording TRANSCRIPT が対応づけられ、プラン依存項目がリスクに反映されていることを確認。

## Task4 - Registry / INDEX / 進捗の同期
- 状態: 完了
- 判断: SPEC-012 として SSOT_REGISTRY に draft 登録。Phase 151 を PHASE_REGISTRY に completed で追記。INDEX の SSOT 節・Phase 節に追記。進捗 1 行追記。
- 実施: 各ファイルを更新。
- 確認: SSOT_REGISTRY / PHASE_REGISTRY / INDEX / progress の相互参照が揃っていることを確認。
