# Phase 278 WORKLOG: 静岡合同懇親会 参加者名簿作成

tool: cursor

## 2026-07-08 19:43 JST

- 判断: Phase 277 要件に従い、Religo 本体ではなく `docs/pdf/260709/` に静的成果物を集約する。
- 判断: Google フォームの分岐により、`所属チャプター != その他` の行は列 E=chapter, F=category, G=company, H=comment。`その他` 行は E=その他, F=実チャプター, G=category, H=company, I=comment と解釈する。
- 判断: チャプター表記ゆれは自動統合せず、要件どおり生の表記を保持する。
- 実装: `docs/pdf/260709/generate_roster.py` で正規化 CSV・print HTML・mobile HTML を同一データから生成する方針。

## 2026-07-08 19:44 JST

- 生成: 43名・17チャプターの名簿を `docs/pdf/260709/` に出力。A4 PDF は Chrome headless で生成。
- 確認: DragonFly 8名が先頭、チャプター内は名前順。個人情報注意書きを print/mobile 両方に記載。
- 確認候補: 後藤聡美行のカテゴリ列長文、`インフィニティー` 表記ゆれは REPORT に記録（自動統合なし）。
