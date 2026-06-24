# PHASE_243_sonae_requirements_wall_bounce WORKLOG

**作成日時:** 2026-06-24 18:22:02  
**最終更新日時:** 2026-06-24 18:35:01  
**tool:** cursor

---

## Task1 - 壁打ち合意の SSOT 化方針

- 状態: 完了
- 判断: チャット上の合意は詳細を `SONAE_WALL_BOUNCE_DECISIONS.md` に集約し、`SONAE_REQUIREMENTS.md` には実装可能な正規要件として吸収する。二重管理を避けるため、SSOT 本文から壁打ち doc へリンクする。
- 実施: Phase 243 PLAN 作成。docs のみ Scope。
- 確認: —

## Task2 - Member Roster / Religo オプション

- 状態: 完了
- 判断: Religo はオプション。実行時正は `sonae_members`。Religo 時は `members`（`type=member` のみ）を 1:1 sync。LINE ID は Religo `members` に持たず extension テーブルのみ。機能ごとに members 表を増やさない。
- 実施: SSOT §2.6–2.7、壁打ち doc §2–3 に記載。
- 確認: Religo `members` に活動市町村カラム無しを確認済み。

## Task3 - JMA 9種・閾値 UI

- 状態: 完了
- 判断: 提案書記載9種すべてを PoC データソース対象とする。取得は JMAXML PULL 1 ジョブ + Normalizer アダプタ。閾値はハードコードせず管理画面 + `alert_threshold_options` マスタ。
- 実施: SSOT §9 拡張、§11 テーブル追加。
- 確認: —

## Task4 - 将来: 地域別回答義務

- 状態: 完了
- 判断: PoC は LINE 紐付け済み全員を回答必須とする。将来 `activity_areas` + `notification_targets.response_requirement` で必須/任意/対象外を実現。PoC では DB 拡張余地のみ要件化。
- 実施: SSOT §14、§11 notification_targets 注記。
- 確認: —

## Task5 - LINE 紐付け済みのみ通知・段階展開

- 状態: 完了
- 判断: Push 通知は LINE userId が必須のため、名簿全員と通知対象を分離する。パイロット用フラグは運用複雑化を避け、紐付け状態そのものを段階展開のゲートとする。自動発報は手動訓練で登録率が上がってから ON。
- 実施: SSOT §5.3 共通・§5.5–5.6、壁打ち doc §3・§8。提案書ギャップ（被害あり定義・回答率比較・導入 Runbook・訓練/本番同一 UI）を SSOT §6.4・§16.1 に反映。
- 確認: —
