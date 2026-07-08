#!/usr/bin/env python3
"""Generate BNI Shizuoka joint social roster CSV + print/mobile HTML from form export."""

from __future__ import annotations

import csv
import html
import re
from collections import defaultdict
from datetime import datetime
from pathlib import Path
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
PUBLIC_URL_PATH = "/events/bni-shizuoka-joint-social-20260709"

EVENT_TITLE = "BNI 静岡合同懇親会 参加者名簿"
EVENT_DATE = "2026-07-09"
SOURCE_SHEET = "2026_07_09_BNI合同懇親会_参加者一覧"
BNI_RED = "#CF2030"
BNI_RED_DARK = "#A01825"


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


def main() -> None:
    raw = parse_markdown_table(SOURCE)
    rows = dedupe(raw)
    chapters = sort_grouped(rows)
    total = write_csv(chapters)
    print_html = build_print_html(chapters, total)
    mobile_html = build_mobile_html(chapters, total)
    PRINT_OUT.write_text(print_html, encoding="utf-8")
    MOBILE_OUT.write_text(mobile_html, encoding="utf-8")
    write_public_html(chapters, total)
    print(f"Parsed raw rows: {len(raw)}")
    print(f"After dedupe: {total}")
    print(f"Chapters: {len(chapters)}")
    print(chapter_summary(chapters))
    print(
        f"Wrote: {CSV_OUT.name}, {PRINT_OUT.name}, {MOBILE_OUT.name}, "
        f"{PUBLIC_DIR.relative_to(REPO_ROOT)}/"
    )
    print(f"Public URLs (auth not required): http://localhost{PUBLIC_URL_PATH}/")


if __name__ == "__main__":
    main()
