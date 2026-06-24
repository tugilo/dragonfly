# PHASE_250_sonae_jma_ingest WORKLOG

**作成日時:** 2026-06-24 21:53 JST  
**最終更新日時:** 2026-06-24 21:53 JST

---

## 判断記録

### Normalizer 分割

種別ごとに `AbstractSonaeJmaTypeNormalizer` を継承したクラスを配置。registry は AppServiceProvider で singleton 登録。PoC fixture は簡略 JSON（type / source_event_key / severity / areas）を各 normalizer が受け付ける。

### 重複排除

`source_event_key` ユニークで upsert 相当。再取得時は skipped_duplicate_count をログに反映。

### areas

都道府県・市区町村を `sonae_alert_event_areas` に展開。発報条件マッチ（Phase 251）は areas と chapter 設定を突合。
