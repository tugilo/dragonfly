#!/usr/bin/env python3
"""Generate BNI Shizuoka joint social roster CSV + print/mobile HTML from form export."""

from __future__ import annotations

import csv
import html
import json
import re
from collections import defaultdict
from datetime import datetime
from pathlib import Path
from urllib.parse import quote
from zoneinfo import ZoneInfo

DIR = Path(__file__).resolve().parent
REPO_ROOT = DIR.parent.parent.parent
SOURCE = DIR / "source_form_responses.md"
CSV_OUT = DIR / "bni_shizuoka_joint_social_roster_normalized.csv"
PRINT_OUT = DIR / "bni_shizuoka_joint_social_roster_print.html"
MOBILE_OUT = DIR / "bni_shizuoka_joint_social_roster_mobile.html"
PUBLIC_DIR = REPO_ROOT / "www" / "public" / "events" / "bni-shizuoka-joint-social-20260709"
PUBLIC_PRINT = PUBLIC_DIR / "print.html"
PUBLIC_MOBILE = PUBLIC_DIR / "mobile.html"
PUBLIC_INDEX = PUBLIC_DIR / "index.html"
OUTREACH_OUT = DIR / "bni_shizuoka_joint_social_outreach.html"
PRIVATE_OUTREACH = REPO_ROOT / "www" / "resources" / "private" / "tools" / "bni-shizuoka-joint-social-outreach.html"
PUBLIC_URL_PATH = "/events/bni-shizuoka-joint-social-20260709"

EVENT_TITLE = "BNI 静岡合同懇親会 参加者名簿"
OUTREACH_TITLE = "BNI 静岡合同懇親会 — お礼・121案内"
EVENT_DATE = "2026-07-09"
SOURCE_SHEET = "2026_07_09_BNI合同懇親会_参加者一覧"
BNI_RED = "#CF2030"
BNI_RED_DARK = "#A01825"

SENDER_NAME = "次廣 淳"
SENDER_EMAIL = "tugi@tugilo.com"
SENDER_CHAPTER = "DragonFly"
SENDER_CHAPTER_DISPLAY = "BNI 東京NEリージョン DragonFly"
SENDER_CATEGORY = "AI業務改善システム構築"
SENDER_EXCLUDE_EMAILS = {"tugi@tugilo.com"}
SCHEDULING_URL = "https://timerex.net/s/tugi_3d63/c6ec5c0e"

SELF_INTRO_BODY = """東京NEリージョン DragonFly、AI業務改善システム構築の次廣です。
システムエンジニア歴26年。静岡県藤枝市を拠点に、
Excelや手作業で回っている業務を、現場に合った仕組みに整えています。
「探す・書き写す・確認する」が減ると、本来の仕事に集中できる時間が増えます。"""

OUTREACH_STORAGE_KEY = "bni-shizuoka-joint-social-20260709-outreach-sent-v1"
OUTREACH_CARD_STORAGE_KEY = "bni-shizuoka-joint-social-20260709-outreach-card-v1"


def parse_markdown_table(path: Path) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line.startswith("|") or line.startswith("| ---"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if len(cells) < 9:
            continue
        row_num = cells[0]
        if not row_num.isdigit() or int(row_num) <= 1:
            continue
        timestamp = cells[1]
        name = re.sub(r"\\(.)", r"\1", cells[2]).strip()
        email = re.sub(r"\\(.)", r"\1", cells[3]).strip()
        chapter_raw = cells[4].strip()
        col_f = cells[5].strip()
        col_g = cells[6].strip()
        col_h = cells[7].strip()
        col_i = cells[8].strip() if len(cells) > 8 else ""

        if not name:
            continue

        if chapter_raw == "その他":
            chapter = col_f
            category = col_g
            comment = col_i or col_h
        else:
            chapter = chapter_raw
            category = col_f
            comment = col_h or col_i

        rows.append(
            {
                "timestamp": timestamp,
                "name": name,
                "email": email,
                "chapter_name": chapter,
                "category": category,
                "comment": comment,
            }
        )
    return rows


def dedupe(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_key: dict[tuple[str, str], dict[str, str]] = {}
    for row in rows:
        key = (row["name"], row["email"].lower())
        existing = by_key.get(key)
        if existing is None or row["timestamp"] >= existing["timestamp"]:
            by_key[key] = row
    return list(by_key.values())


def sort_grouped(rows: list[dict[str, str]]) -> list[tuple[str, list[dict[str, str]]]]:
    by_chapter: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        by_chapter[row["chapter_name"]].append(row)

    for members in by_chapter.values():
        members.sort(key=lambda r: r["name"])

    chapters = sorted(
        by_chapter.items(),
        key=lambda item: (-len(item[1]), item[0]),
    )
    return chapters


def write_csv(chapters: list[tuple[str, list[dict[str, str]]]]) -> int:
    count = 0
    with CSV_OUT.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=["chapter_name", "category", "name", "email", "comment"],
        )
        writer.writeheader()
        for _, members in chapters:
            for row in members:
                writer.writerow(
                    {
                        "chapter_name": row["chapter_name"],
                        "category": row["category"],
                        "name": row["name"],
                        "email": row["email"],
                        "comment": row["comment"],
                    }
                )
                count += 1
    return count


def esc(value: str) -> str:
    return html.escape(value or "", quote=True)


def generated_at() -> str:
    return datetime.now(ZoneInfo("Asia/Tokyo")).strftime("%Y-%m-%d %H:%M JST")


def build_print_html(chapters: list[tuple[str, list[dict[str, str]]]], total: int) -> str:
    body_parts: list[str] = []
    for chapter, members in chapters:
        body_parts.append(
            f'<section class="chapter"><h2>{esc(chapter)}（{len(members)}名）</h2>'
            '<table><thead><tr>'
            "<th>チャプター</th><th>カテゴリ</th><th>名前</th><th>メール</th><th>一言</th>"
            "</tr></thead><tbody>"
        )
        for row in members:
            body_parts.append(
                "<tr>"
                f"<td>{esc(row['chapter_name'])}</td>"
                f"<td>{esc(row['category'])}</td>"
                f"<td>{esc(row['name'])}</td>"
                f"<td class=\"email\">{esc(row['email'])}</td>"
                f"<td class=\"comment\">{esc(row['comment'])}</td>"
                "</tr>"
            )
        body_parts.append("</tbody></table></section>")

    return f"""<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="robots" content="noindex, nofollow">
  <title>{esc(EVENT_TITLE)} — 印刷用</title>
  <style>
    @page {{ size: A4 landscape; margin: 12mm; }}
    * {{ box-sizing: border-box; }}
    body {{ font-family: "Hiragino Sans", "Yu Gothic", sans-serif; font-size: 9pt; color: #111; margin: 0; }}
    header {{ margin-bottom: 10px; border-bottom: 2px solid #333; padding-bottom: 6px; }}
    h1 {{ font-size: 16pt; margin: 0 0 4px; }}
    .meta {{ font-size: 8pt; color: #444; line-height: 1.5; }}
    .notice {{ margin-top: 6px; font-size: 8pt; color: #800; }}
    .chapter {{ margin-top: 14px; break-inside: avoid-page; }}
    h2 {{ font-size: 11pt; margin: 0 0 6px; background: #eef2ff; padding: 4px 6px; border-left: 4px solid #334155; }}
    table {{ width: 100%; border-collapse: collapse; table-layout: fixed; }}
    th, td {{ border: 1px solid #cbd5e1; padding: 4px 5px; vertical-align: top; word-wrap: break-word; }}
    th {{ background: #f8fafc; font-size: 8pt; }}
    td.email {{ font-size: 8pt; word-break: break-all; }}
    td.comment {{ font-size: 8pt; }}
    colgroup col:nth-child(1) {{ width: 11%; }}
    colgroup col:nth-child(2) {{ width: 18%; }}
    colgroup col:nth-child(3) {{ width: 10%; }}
    colgroup col:nth-child(4) {{ width: 18%; }}
    colgroup col:nth-child(5) {{ width: 43%; }}
  </style>
</head>
<body>
  <header>
    <h1>{esc(EVENT_TITLE)}</h1>
    <div class="meta">
      開催日: {esc(EVENT_DATE)} / 参加者: {total}名 / 生成: {esc(generated_at())}<br>
      入力元: {esc(SOURCE_SHEET)}
    </div>
    <div class="notice">個人情報を含みます。参加者・運営関係者以外への配布・転送は禁止です。</div>
  </header>
  {''.join(body_parts)}
</body>
</html>
"""


def chapter_anchor(index: int) -> str:
    return f"chapter-{index}"


def build_mobile_html(chapters: list[tuple[str, list[dict[str, str]]]], total: int) -> str:
    nav_parts: list[str] = []
    body_parts: list[str] = []
    for index, (chapter, members) in enumerate(chapters):
        anchor = chapter_anchor(index)
        nav_parts.append(
            f'<a class="chapter-link" href="#{anchor}">'
            f"{esc(chapter)}（{len(members)}）</a>"
        )
        cards: list[str] = []
        for row in members:
            email_link = (
                f'<a href="mailto:{esc(row["email"])}">{esc(row["email"])}</a>'
                if row["email"]
                else "（未入力）"
            )
            search_blob = " ".join(
                [
                    chapter,
                    row["name"],
                    row["category"],
                    row["email"],
                    row["comment"],
                ]
            ).lower()
            cards.append(
                f"""<article class="card" data-search="{esc(search_blob)}">
  <p class="card-chapter">{esc(chapter)}</p>
  <h3>{esc(row['name'])}</h3>
  <dl>
    <dt>カテゴリ</dt><dd>{esc(row['category'])}</dd>
    <dt>メール</dt><dd>{email_link}</dd>
    <dt>一言</dt><dd>{esc(row['comment']) or '—'}</dd>
  </dl>
</article>"""
            )
        body_parts.append(
            f"""<details class="chapter" id="{anchor}" open>
  <summary>{esc(chapter)}（{len(members)}名）</summary>
  <div class="cards">{''.join(cards)}</div>
</details>"""
        )

    return f"""<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <title>{esc(EVENT_TITLE)} — スマホ閲覧用</title>
  <style>
    * {{ box-sizing: border-box; }}
    html {{ scroll-behavior: smooth; }}
    body {{
      font-family: "Hiragino Sans", "Yu Gothic", sans-serif;
      margin: 0;
      background: #e2e8f0;
      color: #0f172a;
      font-size: 16px;
      line-height: 1.55;
      padding-bottom: 5rem;
    }}
    header {{
      background: linear-gradient(160deg, {BNI_RED} 0%, {BNI_RED_DARK} 100%);
      color: #fff;
      padding: 16px 14px 14px;
      box-shadow: 0 2px 10px rgba(160, 24, 37, 0.25);
    }}
    h1 {{ font-size: 1.2rem; margin: 0 0 8px; line-height: 1.35; }}
    .meta {{ font-size: 0.84rem; opacity: 0.95; line-height: 1.5; }}
    .notice {{ margin-top: 8px; font-size: 0.8rem; color: #fef9c3; }}
    .toolbar {{
      position: sticky;
      top: 0;
      z-index: 20;
      background: #fff;
      border-bottom: 1px solid #cbd5e1;
      box-shadow: 0 2px 8px rgba(15, 23, 42, 0.08);
      padding: 10px 12px 12px;
    }}
    .search-wrap {{ margin-bottom: 10px; }}
    .search-wrap label {{
      display: block;
      font-size: 0.78rem;
      font-weight: 700;
      color: #475569;
      margin-bottom: 6px;
    }}
    #search {{
      width: 100%;
      font-size: 1rem;
      padding: 11px 12px;
      border: 2px solid #94a3b8;
      border-radius: 10px;
      background: #f8fafc;
    }}
    #search:focus {{
      outline: none;
      border-color: #2563eb;
      background: #fff;
    }}
    #search-status {{
      margin-top: 6px;
      font-size: 0.8rem;
      color: #64748b;
      min-height: 1.2em;
    }}
    .chapter-nav-label {{
      font-size: 0.78rem;
      font-weight: 700;
      color: #475569;
      margin: 0 0 6px;
    }}
    .chapter-nav {{
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      max-height: 9.5rem;
      overflow-y: auto;
      -webkit-overflow-scrolling: touch;
    }}
    .chapter-link {{
      display: inline-block;
      padding: 7px 10px;
      border-radius: 999px;
      background: #e0e7ff;
      color: #1e3a8a;
      font-size: 0.78rem;
      font-weight: 700;
      text-decoration: none;
      border: 1px solid #c7d2fe;
      white-space: nowrap;
    }}
    .chapter-link:active {{ background: #c7d2fe; }}
    main {{ padding: 12px; max-width: 680px; margin: 0 auto; }}
    .chapter {{
      background: #fff;
      border-radius: 12px;
      margin-bottom: 14px;
      overflow: hidden;
      box-shadow: 0 2px 6px rgba(15, 23, 42, 0.08);
      scroll-margin-top: 11rem;
    }}
    .chapter[hidden] {{ display: none; }}
    summary {{
      cursor: pointer;
      font-weight: 800;
      font-size: 1rem;
      padding: 14px 14px;
      background: #dbeafe;
      color: #1e3a8a;
      list-style: none;
      border-bottom: 1px solid #bfdbfe;
    }}
    summary::-webkit-details-marker {{ display: none; }}
    .cards {{ padding: 10px 10px 12px; display: grid; gap: 12px; }}
    .card {{
      border: 1px solid #cbd5e1;
      border-radius: 10px;
      padding: 12px 14px;
      background: #fff;
    }}
    .card[hidden] {{ display: none; }}
    .card-chapter {{
      margin: 0 0 4px;
      font-size: 0.72rem;
      font-weight: 700;
      color: #64748b;
      letter-spacing: 0.02em;
    }}
    .card h3 {{
      margin: 0 0 10px;
      font-size: 1.15rem;
      font-weight: 800;
      color: #0f172a;
      line-height: 1.35;
    }}
    dl {{
      margin: 0;
      display: grid;
      grid-template-columns: 4.8em 1fr;
      gap: 6px 10px;
      font-size: 0.92rem;
    }}
    dt {{
      color: #64748b;
      font-weight: 700;
      font-size: 0.82rem;
    }}
    dd {{ margin: 0; word-break: break-word; color: #1e293b; }}
    a {{ color: #1d4ed8; word-break: break-all; }}
    #top-btn {{
      position: fixed;
      right: 14px;
      bottom: 18px;
      z-index: 30;
      width: 3.1rem;
      height: 3.1rem;
      border: none;
      border-radius: 999px;
      background: #1d4ed8;
      color: #fff;
      font-size: 0.72rem;
      font-weight: 800;
      line-height: 1.15;
      box-shadow: 0 4px 14px rgba(29, 78, 216, 0.45);
      cursor: pointer;
    }}
    #top-btn:active {{ transform: scale(0.96); }}
  </style>
</head>
<body>
  <header>
    <h1>{esc(EVENT_TITLE)}</h1>
    <div class="meta">開催日: {esc(EVENT_DATE)} / 参加者: {total}名 / 生成: {esc(generated_at())}</div>
    <div class="notice">個人情報を含みます。限定共有 URL で閲覧してください。</div>
  </header>
  <div class="toolbar">
    <div class="search-wrap">
      <label for="search">名前・カテゴリ・一言で検索</label>
      <input id="search" type="search" inputmode="search" autocomplete="off"
        placeholder="例: デザイン / ゴルフ / 姓">
      <div id="search-status"></div>
    </div>
    <p class="chapter-nav-label">チャプターへジャンプ</p>
    <nav class="chapter-nav" aria-label="チャプター一覧">
      {''.join(nav_parts)}
    </nav>
  </div>
  <main>
    {''.join(body_parts)}
  </main>
  <button id="top-btn" type="button" aria-label="ページトップへ戻る">▲<br>TOP</button>
  <script>
    (function () {{
      var searchInput = document.getElementById("search");
      var statusEl = document.getElementById("search-status");
      var chapters = Array.prototype.slice.call(document.querySelectorAll(".chapter"));

      function applySearch() {{
        var query = searchInput.value.trim().toLowerCase();
        var visibleCards = 0;
        chapters.forEach(function (chapter) {{
          var chapterCount = 0;
          chapter.querySelectorAll(".card").forEach(function (card) {{
            var blob = card.getAttribute("data-search") || "";
            var show = !query || blob.indexOf(query) !== -1;
            card.hidden = !show;
            if (show) chapterCount += 1;
          }});
          chapter.hidden = chapterCount === 0;
          if (query && chapterCount > 0) chapter.open = true;
          visibleCards += chapterCount;
        }});
        if (query) {{
          statusEl.textContent = visibleCards + " 件ヒット（全 {total} 名）";
        }} else {{
          statusEl.textContent = "";
        }}
      }}

      searchInput.addEventListener("input", applySearch);
      document.getElementById("top-btn").addEventListener("click", function () {{
        window.scrollTo({{ top: 0, behavior: "smooth" }});
      }});
    }})();
  </script>
</body>
</html>
"""


def chapter_summary(chapters: list[tuple[str, list[dict[str, str]]]]) -> str:
    lines = [f"{name}: {len(members)}名" for name, members in chapters]
    return ", ".join(lines)


def outreach_targets(
    chapters: list[tuple[str, list[dict[str, str]]]],
) -> list[dict[str, str]]:
    targets: list[dict[str, str]] = []
    for chapter, members in chapters:
        if chapter.strip() == SENDER_CHAPTER:
            continue
        for row in members:
            email = (row["email"] or "").strip().lower()
            if email in SENDER_EXCLUDE_EMAILS:
                continue
            targets.append(
                {
                    "chapter_name": chapter,
                    "category": row["category"],
                    "name": row["name"],
                    "email": row["email"],
                    "comment": row["comment"],
                }
            )
    return targets


def build_outreach_message(name: str, chapter: str) -> str:
    return (
        f"{name}さん\n\n"
        f"先日の7月9日 静岡合同懇親会ではありがとうございました。\n"
        "人数も40名を超える中では、なかなか十分にお話しするお時間をいただけませんでした。\n"
        "このご縁を大切に、ぜひ1to1（121）でゆっくりお話しできれば幸いです。\n\n"
        "改めて簡単に自己紹介させてください。\n\n"
        f"{SELF_INTRO_BODY}\n\n"
        "下記からご都合の良い日時をお選びください（60分・Zoom）。\n\n"
        f"{SCHEDULING_URL}\n\n"
        "どうぞよろしくお願いいたします。\n\n"
        f"{SENDER_CHAPTER_DISPLAY}\n"
        f"{SENDER_NAME}（{SENDER_CATEGORY}）\n"
        f"{SENDER_EMAIL}"
    )


def build_outreach_html(targets: list[dict[str, str]]) -> str:
    cards: list[str] = []
    for index, row in enumerate(targets):
        message = build_outreach_message(row["name"], row["chapter_name"])
        email = row["email"] or ""
        search_blob = " ".join(
            [
                row["chapter_name"],
                row["name"],
                row["category"],
                email,
                row["comment"],
            ]
        ).lower()
        if email:
            mailto_href = (
                f"mailto:{esc(email)}?"
                f"subject={quote('静岡合同懇親会のお礼と121のご案内')}&"
                f"body={quote(message)}"
            )
            mailto = f'<a class="mailto" href="{mailto_href}">メール作成</a>'
        else:
            mailto = ""
        cards.append(
            f"""<article class="card" id="target-{index}" data-id="{esc(email or row['name'])}" data-search="{esc(search_blob)}">
  <div class="card-head">
    <div class="card-identity">
      <p class="card-chapter">{esc(row['chapter_name'])}</p>
      <h3>{esc(row['name'])}</h3>
      <p class="card-category">{esc(row['category'])}</p>
    </div>
    <div class="card-checks">
      <label class="status-check card-check">
        <input type="checkbox" class="card-toggle" aria-label="{esc(row['name'])}と名刺交換済み">
        <span>名刺交換済み</span>
      </label>
      <label class="status-check sent-check">
        <input type="checkbox" class="sent-toggle" aria-label="{esc(row['name'])}への送信済み">
        <span>送信済み</span>
      </label>
    </div>
  </div>
  <pre class="message" id="msg-{index}">{esc(message)}</pre>
  <div class="actions">
    <button type="button" class="btn copy-btn" data-target="msg-{index}">文面をコピー</button>
    {mailto}
  </div>
</article>"""
        )

    total = len(targets)
    return f"""<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <title>{esc(OUTREACH_TITLE)}</title>
  <style>
    * {{ box-sizing: border-box; }}
    html {{ scroll-behavior: smooth; }}
    body {{
      font-family: "Hiragino Sans", "Yu Gothic", sans-serif;
      margin: 0;
      background: #e2e8f0;
      color: #0f172a;
      font-size: 16px;
      line-height: 1.55;
      padding-bottom: 5rem;
    }}
    header.page-header {{
      background: linear-gradient(160deg, {BNI_RED} 0%, {BNI_RED_DARK} 100%);
      color: #fff;
      padding: 16px 14px 14px;
      box-shadow: 0 2px 10px rgba(160, 24, 37, 0.25);
    }}
    h1 {{ font-size: 1.15rem; margin: 0 0 8px; line-height: 1.35; }}
    .meta {{ font-size: 0.84rem; opacity: 0.95; line-height: 1.5; }}
    .notice {{ margin-top: 8px; font-size: 0.8rem; color: #fef9c3; }}
    .toolbar {{
      position: sticky;
      top: 0;
      z-index: 20;
      background: #fff;
      border-bottom: 1px solid #cbd5e1;
      box-shadow: 0 2px 8px rgba(15, 23, 42, 0.08);
      padding: 10px 12px 12px;
    }}
    .progress {{
      font-size: 0.9rem;
      font-weight: 800;
      color: #1e3a8a;
      margin-bottom: 8px;
      line-height: 1.45;
    }}
    .progress-sub {{
      font-size: 0.82rem;
      font-weight: 700;
      color: #475569;
      margin-bottom: 8px;
    }}
    .progress-bar {{
      height: 8px;
      background: #e2e8f0;
      border-radius: 999px;
      overflow: hidden;
      margin-bottom: 10px;
    }}
    .progress-fill {{
      height: 100%;
      width: 0%;
      background: linear-gradient(90deg, #22c55e, #16a34a);
      transition: width 0.2s ease;
    }}
    .filter-tabs {{
      display: flex;
      gap: 6px;
      flex-wrap: wrap;
      margin-bottom: 10px;
    }}
    .filter-tab {{
      border: 1px solid #cbd5e1;
      background: #f8fafc;
      color: #334155;
      border-radius: 999px;
      padding: 7px 12px;
      font-size: 0.82rem;
      font-weight: 700;
      cursor: pointer;
    }}
    .filter-tab.active {{
      background: #1d4ed8;
      border-color: #1d4ed8;
      color: #fff;
    }}
    .search-wrap label {{
      display: block;
      font-size: 0.78rem;
      font-weight: 700;
      color: #475569;
      margin-bottom: 6px;
    }}
    #search {{
      width: 100%;
      font-size: 1rem;
      padding: 11px 12px;
      border: 2px solid #94a3b8;
      border-radius: 10px;
      background: #f8fafc;
    }}
    #search:focus {{
      outline: none;
      border-color: #2563eb;
      background: #fff;
    }}
    #search-status {{
      margin-top: 6px;
      font-size: 0.8rem;
      color: #64748b;
      min-height: 1.2em;
    }}
    main {{ padding: 12px; max-width: 680px; margin: 0 auto; }}
    .card {{
      background: #fff;
      border: 1px solid #cbd5e1;
      border-radius: 12px;
      padding: 0;
      margin-bottom: 12px;
      box-shadow: 0 2px 6px rgba(15, 23, 42, 0.06);
      overflow: hidden;
    }}
    .card[hidden] {{ display: none; }}
    .card.sent {{
      border-color: #86efac;
      background: #f0fdf4;
    }}
    .card.no-card {{
      border-color: #f59e0b;
      background: #fffbeb;
    }}
    .card-head {{
      display: flex;
      justify-content: space-between;
      gap: 10px;
      align-items: flex-start;
      padding: 12px 14px;
      background: #f8fafc;
      border-bottom: 1px solid #e2e8f0;
    }}
    .card.no-card .card-head {{
      background: #fff7ed;
      border-bottom-color: #fed7aa;
    }}
    .card.sent .card-head {{
      background: #ecfdf5;
      border-bottom-color: #bbf7d0;
    }}
    .card-checks {{
      display: flex;
      flex-direction: column;
      gap: 6px;
      align-items: flex-end;
      flex-shrink: 0;
    }}
    .card-chapter {{
      margin: 0 0 4px;
      font-size: 0.78rem;
      font-weight: 800;
      color: #1e3a8a;
      letter-spacing: 0.02em;
    }}
    .card h3 {{
      margin: 0;
      font-size: 1.15rem;
      font-weight: 800;
      color: #0f172a;
      line-height: 1.3;
    }}
    .card-category {{
      margin: 4px 0 0;
      font-size: 0.86rem;
      font-weight: 600;
      color: #334155;
      line-height: 1.4;
    }}
    .status-check, .sent-check {{
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 0.8rem;
      font-weight: 800;
      white-space: nowrap;
      cursor: pointer;
      user-select: none;
      padding: 5px 8px;
      border-radius: 8px;
      border: 1px solid transparent;
    }}
    .card-check {{
      color: #1e3a8a;
      background: #dbeafe;
      border-color: #93c5fd;
    }}
    .sent-check {{
      color: #14532d;
      background: #dcfce7;
      border-color: #86efac;
    }}
    .status-check input {{
      width: 1.1rem;
      height: 1.1rem;
    }}
    .card-check input {{
      accent-color: #2563eb;
    }}
    .sent-check input {{
      accent-color: #16a34a;
    }}
    .message {{
      margin: 12px 14px 10px;
      padding: 10px 12px;
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      font-family: inherit;
      font-size: 0.88rem;
      line-height: 1.6;
      white-space: pre-wrap;
      word-break: break-word;
    }}
    .actions {{
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
      padding: 0 14px 12px;
    }}
    .btn, .mailto {{
      display: inline-block;
      padding: 9px 12px;
      border-radius: 8px;
      font-size: 0.84rem;
      font-weight: 700;
      text-decoration: none;
      cursor: pointer;
    }}
    .btn {{
      border: none;
      background: #1d4ed8;
      color: #fff;
    }}
    .btn:active {{ transform: scale(0.98); }}
    .btn.copied {{ background: #16a34a; }}
    .mailto {{
      background: #fff;
      color: #1d4ed8;
      border: 1px solid #93c5fd;
    }}
    #toast {{
      position: fixed;
      left: 50%;
      bottom: 80px;
      transform: translateX(-50%);
      background: #0f172a;
      color: #fff;
      padding: 10px 14px;
      border-radius: 8px;
      font-size: 0.84rem;
      opacity: 0;
      pointer-events: none;
      transition: opacity 0.2s ease;
      z-index: 40;
    }}
    #toast.show {{ opacity: 0.95; }}
    #top-btn {{
      position: fixed;
      right: 14px;
      bottom: 18px;
      z-index: 30;
      width: 3.1rem;
      height: 3.1rem;
      border: none;
      border-radius: 999px;
      background: #1d4ed8;
      color: #fff;
      font-size: 0.72rem;
      font-weight: 800;
      line-height: 1.15;
      box-shadow: 0 4px 14px rgba(29, 78, 216, 0.45);
      cursor: pointer;
    }}
  </style>
</head>
<body>
  <header class="page-header">
    <h1>{esc(OUTREACH_TITLE)}</h1>
    <div class="meta">送信者: {esc(SENDER_NAME)}（{esc(SENDER_CHAPTER_DISPLAY)}） / 対象: {total}名 / 生成: {esc(generated_at())}</div>
    <div class="notice">個人用ツールです。DragonFlyメンバーは対象外。名刺交換・送信状況はこの端末のブラウザに保存されます。</div>
  </header>
  <div class="toolbar">
    <div class="progress" id="progress-text">送付待ち（名刺交換済み・未送信）を確認してください</div>
    <div class="progress-sub" id="progress-sub">名刺交換済み 0 / {total}　｜　送信済み 0 / {total}</div>
    <div class="progress-bar"><div class="progress-fill" id="progress-fill"></div></div>
    <div class="filter-tabs" role="tablist" aria-label="表示フィルタ">
      <button type="button" class="filter-tab active" data-filter="no-card">名刺未交換</button>
      <button type="button" class="filter-tab" data-filter="ready">送付待ち</button>
      <button type="button" class="filter-tab" data-filter="all">すべて</button>
      <button type="button" class="filter-tab" data-filter="sent">送信済み</button>
    </div>
    <div class="search-wrap">
      <label for="search">名前・チャプター・カテゴリで検索</label>
      <input id="search" type="search" inputmode="search" autocomplete="off" placeholder="例: デザイン / ゴルフ / 姓">
      <div id="search-status"></div>
    </div>
  </div>
  <main id="cards">
    {''.join(cards)}
  </main>
  <div id="toast" role="status" aria-live="polite"></div>
  <button id="top-btn" type="button" aria-label="ページトップへ戻る">▲<br>TOP</button>
  <script>
    (function () {{
      var SENT_STORAGE_KEY = {json.dumps(OUTREACH_STORAGE_KEY)};
      var CARD_STORAGE_KEY = {json.dumps(OUTREACH_CARD_STORAGE_KEY)};
      var total = {total};
      var cards = Array.prototype.slice.call(document.querySelectorAll(".card"));
      var searchInput = document.getElementById("search");
      var statusEl = document.getElementById("search-status");
      var progressText = document.getElementById("progress-text");
      var progressSub = document.getElementById("progress-sub");
      var progressFill = document.getElementById("progress-fill");
      var toast = document.getElementById("toast");
      var activeFilter = "no-card";
      var toastTimer = null;

      function loadMap(key) {{
        try {{
          return JSON.parse(localStorage.getItem(key) || "{{}}") || {{}};
        }} catch (e) {{
          return {{}};
        }}
      }}

      function saveMap(key, map) {{
        localStorage.setItem(key, JSON.stringify(map));
      }}

      function showToast(text) {{
        toast.textContent = text;
        toast.classList.add("show");
        clearTimeout(toastTimer);
        toastTimer = setTimeout(function () {{
          toast.classList.remove("show");
        }}, 1800);
      }}

      function sentCount() {{
        return cards.filter(function (card) {{
          return card.classList.contains("sent");
        }}).length;
      }}

      function cardCount() {{
        return cards.filter(function (card) {{
          return card.classList.contains("card-exchanged");
        }}).length;
      }}

      function readyCount() {{
        return cards.filter(function (card) {{
          return card.classList.contains("card-exchanged") && !card.classList.contains("sent");
        }}).length;
      }}

      function updateProgress() {{
        var sentDone = sentCount();
        var cardDone = cardCount();
        var ready = readyCount();
        progressText.textContent = "送付待ち " + ready + " 名（名刺交換済み・未送信）";
        progressSub.textContent = "名刺交換済み " + cardDone + " / " + total + "　｜　送信済み " + sentDone + " / " + total;
        progressFill.style.width = (total ? (sentDone / total) * 100 : 0) + "%";
      }}

      function cardMatchesFilter(card) {{
        var hasCard = card.classList.contains("card-exchanged");
        var isSent = card.classList.contains("sent");
        if (activeFilter === "ready") return hasCard && !isSent;
        if (activeFilter === "no-card") return !hasCard;
        if (activeFilter === "sent") return isSent;
        return true;
      }}

      function applyFilters() {{
        var query = searchInput.value.trim().toLowerCase();
        var visible = 0;
        cards.forEach(function (card) {{
          var blob = card.getAttribute("data-search") || "";
          var matchSearch = !query || blob.indexOf(query) !== -1;
          var matchFilter = cardMatchesFilter(card);
          var show = matchSearch && matchFilter;
          card.hidden = !show;
          if (show) visible += 1;
        }});
        if (query || activeFilter !== "all") {{
          statusEl.textContent = visible + " 件表示";
        }} else {{
          statusEl.textContent = "";
        }}
      }}

      var sentMap = loadMap(SENT_STORAGE_KEY);
      var cardMap = loadMap(CARD_STORAGE_KEY);
      cards.forEach(function (card) {{
        var id = card.getAttribute("data-id") || "";
        var sentCheckbox = card.querySelector(".sent-toggle");
        var cardCheckbox = card.querySelector(".card-toggle");

        function refreshCardStyle() {{
          card.classList.toggle("card-exchanged", !!cardCheckbox.checked);
          card.classList.toggle("no-card", !cardCheckbox.checked);
          card.classList.toggle("sent", !!sentCheckbox.checked);
        }}

        if (cardMap[id]) {{
          cardCheckbox.checked = true;
        }}
        if (sentMap[id]) {{
          sentCheckbox.checked = true;
        }}
        refreshCardStyle();

        cardCheckbox.addEventListener("change", function () {{
          if (cardCheckbox.checked) {{
            cardMap[id] = true;
          }} else {{
            delete cardMap[id];
          }}
          saveMap(CARD_STORAGE_KEY, cardMap);
          refreshCardStyle();
          updateProgress();
          applyFilters();
        }});

        sentCheckbox.addEventListener("change", function () {{
          if (sentCheckbox.checked) {{
            sentMap[id] = true;
          }} else {{
            delete sentMap[id];
          }}
          saveMap(SENT_STORAGE_KEY, sentMap);
          refreshCardStyle();
          updateProgress();
          applyFilters();
        }});
      }});

      document.querySelectorAll(".copy-btn").forEach(function (btn) {{
        btn.addEventListener("click", function () {{
          var targetId = btn.getAttribute("data-target");
          var el = document.getElementById(targetId);
          if (!el) return;
          navigator.clipboard.writeText(el.textContent || "").then(function () {{
            btn.classList.add("copied");
            btn.textContent = "コピーしました";
            showToast("文面をコピーしました");
            setTimeout(function () {{
              btn.classList.remove("copied");
              btn.textContent = "文面をコピー";
            }}, 1500);
          }}).catch(function () {{
            showToast("コピーに失敗しました");
          }});
        }});
      }});

      document.querySelectorAll(".filter-tab").forEach(function (tab) {{
        tab.addEventListener("click", function () {{
          document.querySelectorAll(".filter-tab").forEach(function (t) {{
            t.classList.remove("active");
          }});
          tab.classList.add("active");
          activeFilter = tab.getAttribute("data-filter") || "all";
          applyFilters();
        }});
      }});

      searchInput.addEventListener("input", applyFilters);
      document.getElementById("top-btn").addEventListener("click", function () {{
        window.scrollTo({{ top: 0, behavior: "smooth" }});
      }});

      updateProgress();
      applyFilters();
    }})();
  </script>
</body>
</html>
"""


def build_public_index_html(total: int) -> str:
    return f"""<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <meta http-equiv="refresh" content="0; url=mobile.html">
  <title>{esc(EVENT_TITLE)}</title>
  <style>
    body {{ font-family: "Hiragino Sans", "Yu Gothic", sans-serif; margin: 2rem; line-height: 1.6; }}
    a {{ color: #2563eb; }}
  </style>
</head>
<body>
  <h1>{esc(EVENT_TITLE)}</h1>
  <p>開催日: {esc(EVENT_DATE)} / 参加者: {total}名 / 生成: {esc(generated_at())}</p>
  <p>個人情報を含みます。参加者・運営関係者以外への転送は控えてください。</p>
  <ul>
    <li><a href="mobile.html">スマホ閲覧用名簿</a></li>
    <li><a href="print.html">印刷用名簿（A4 横向き）</a></li>
  </ul>
</body>
</html>
"""


def write_public_html(
    chapters: list[tuple[str, list[dict[str, str]]]], total: int
) -> None:
    PUBLIC_DIR.mkdir(parents=True, exist_ok=True)
    print_html = build_print_html(chapters, total)
    mobile_html = build_mobile_html(chapters, total)
    PUBLIC_PRINT.write_text(print_html, encoding="utf-8")
    PUBLIC_MOBILE.write_text(mobile_html, encoding="utf-8")
    PUBLIC_INDEX.write_text(build_public_index_html(total), encoding="utf-8")


def write_private_outreach_html(chapters: list[tuple[str, list[dict[str, str]]]]) -> None:
    outreach_html = build_outreach_html(outreach_targets(chapters))
    PRIVATE_OUTREACH.parent.mkdir(parents=True, exist_ok=True)
    PRIVATE_OUTREACH.write_text(outreach_html, encoding="utf-8")


def main() -> None:
    raw = parse_markdown_table(SOURCE)
    rows = dedupe(raw)
    chapters = sort_grouped(rows)
    total = write_csv(chapters)
    print_html = build_print_html(chapters, total)
    mobile_html = build_mobile_html(chapters, total)
    outreach_html = build_outreach_html(outreach_targets(chapters))
    PRINT_OUT.write_text(print_html, encoding="utf-8")
    MOBILE_OUT.write_text(mobile_html, encoding="utf-8")
    OUTREACH_OUT.write_text(outreach_html, encoding="utf-8")
    write_public_html(chapters, total)
    write_private_outreach_html(chapters)
    outreach_total = len(outreach_targets(chapters))
    print(f"Parsed raw rows: {len(raw)}")
    print(f"After dedupe: {total}")
    print(f"Outreach targets: {outreach_total}")
    print(f"Chapters: {len(chapters)}")
    print(chapter_summary(chapters))
    print(
        f"Wrote: {CSV_OUT.name}, {PRINT_OUT.name}, {MOBILE_OUT.name}, "
        f"{OUTREACH_OUT.name}, {PRIVATE_OUTREACH.relative_to(REPO_ROOT)}, "
        f"{PUBLIC_DIR.relative_to(REPO_ROOT)}/"
    )
    print(f"Public URLs (auth not required): http://localhost{PUBLIC_URL_PATH}/")
    print("Outreach tool: Religo 管理画面メニュー「静岡懇親会 121案内」（本人専用）")


if __name__ == "__main__":
    main()
