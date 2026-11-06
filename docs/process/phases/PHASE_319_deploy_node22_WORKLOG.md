# Phase 319 WORKLOG — デプロイ先のフロントビルド Node を nvm 22 系にする

**作成:** 2026-10-24 07:38 JST

---

## 判断

- 直すのは deploy.yml だけ。VPS の nvm 20.19.5 は残す。戻すときは `git revert <merge commit> -m 1` で 20 のビルドに戻る。
- 旧記述 `nvm use 20 2>/dev/null || true` は失敗を握りつぶして default（いまは 22）か `/usr/bin/node`（apt の 18、EOL）に落ちる。22 が無いときは exit 1 で止めるように変えた。
- `nvm use 22` は 22 系の最新を選ぶ。今後 22.x の修正版を nvm に足すだけで workflow は変えずに追随する。
- ローカル Docker の `versions.env`（NODE_VERSION=20）は別 Phase。vite 7 は Node 22 で動くことを VPS で確認済み。

## 変更

- `.github/workflows/deploy.yml`: `nvm use 22`（無ければ exit 1）と版の echo。冒頭コメントの「nvm Node 20」を 22 に。

## 確認

- アプリコード変更なし。確認は develop デプロイの Actions ログで行う。
