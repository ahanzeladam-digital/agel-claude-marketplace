---
name: firecrawl-api
description: >-
  Scrape, crawl, map, search, and monitor websites via the Firecrawl REST
  API. Use when the user needs clean markdown/content extracted from a
  URL, a whole-site crawl, URL discovery on a domain, live web search
  with content, a local document (PDF/DOCX/XLSX/etc) parsed to markdown,
  or a recurring page/site change monitor. Also use when the user
  mentions Firecrawl, or asks for a "Messy Middle" / cognitive-bias
  content audit, SEO content audit, or competitor-site content
  comparison that needs page text, not just SERP metadata.
allowed-tools: Bash, Read, WebFetch
homepage: https://firecrawl.dev
metadata:
  requires:
    env:
      - FIRECRAWL_API_KEY
  tags:
    - scraping
    - crawling
    - web-search
    - content-audit
    - document-parsing
    - monitoring
---

# Firecrawl API

REST API for turning live web pages (and local documents) into clean markdown/structured data for an agent to read.

**Base URL:** `https://api.firecrawl.dev/v2`
**Auth:** `Authorization: Bearer $FIRECRAWL_API_KEY`
Dashboard / account: https://www.firecrawl.dev

## Core endpoints

```bash
# Scrape a single known URL -> clean markdown (also handles public PDF/DOCX etc URLs)
curl -s -X POST "https://api.firecrawl.dev/v2/scrape" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" -H "Content-Type: application/json" \
  -d '{"url":"https://example.com","formats":["markdown"]}'

# Search the web (with optional full-page content per result)
curl -s -X POST "https://api.firecrawl.dev/v2/search" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" -H "Content-Type: application/json" \
  -d '{"query":"dentálna klinika Bratislava recenzie","limit":10}'

# Discover URLs on a domain (sitemap-style, no content extraction)
curl -s -X POST "https://api.firecrawl.dev/v2/map" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" -H "Content-Type: application/json" \
  -d '{"url":"https://example.com"}'

# Crawl a whole site (bulk extraction, async job)
curl -s -X POST "https://api.firecrawl.dev/v2/crawl" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" -H "Content-Type: application/json" \
  -d '{"url":"https://example.com","limit":50}'
# -> returns a job id; poll GET /v2/crawl/{id}

# Interact with a live page after scraping it (clicks/forms/login) — two-step
curl -s -X POST "https://api.firecrawl.dev/v2/scrape/{scrapeId}/interact" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" -H "Content-Type: application/json" \
  -d '{"prompt":"click the accept cookies button"}'

# Recurring monitor: diffs a page/crawl/search target on a schedule, notifies by webhook/email
curl -s -X POST "https://api.firecrawl.dev/v2/monitor" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" -H "Content-Type: application/json" \
  -d '{"target":{"type":"scrape","url":"https://example.com/pricing"},"schedule":"every 30 minutes","goal":"alert only if the price changed"}'
GET https://api.firecrawl.dev/v2/monitor           # list monitors
GET https://api.firecrawl.dev/v2/monitor/{id}/checks

# Parse a LOCAL/non-public document (multipart upload, up to 50MB: PDF, DOCX, DOC, ODT, RTF, XLSX, XLS, HTML)
curl -s -X POST "https://api.firecrawl.dev/v2/parse" \
  -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
  -F "file=@/path/to/report.pdf"
# A document with a public URL goes through /scrape instead, not /parse.
```

## Research index (scientific papers + GitHub)

```bash
GET https://api.firecrawl.dev/v2/search/research/papers?query=...
GET https://api.firecrawl.dev/v2/search/research/papers/{id}?query=...   # top passages
GET https://api.firecrawl.dev/v2/search/research/papers/{id}/similar     # related/citers/references
GET https://api.firecrawl.dev/v2/search/research/github?query=...
```

## Support / debugging

```bash
POST https://api.firecrawl.dev/v2/support/ask         # {"question": "..."} — diagnose a failing job, include job id if known
POST https://api.firecrawl.dev/v2/support/docs-search  # {"question": "..."} — answer "how do I..." from Firecrawl docs
```

## Notes

- Full API reference (schemas/params/SDKs): https://docs.firecrawl.dev/api-reference/v2-introduction
- `/scrape`, `/search`, `/interact`, `/parse`, and the research-index endpoints work keyless (rate-limited) if the key is ever missing — prefer the key above (higher limits, unlocks `/crawl`, `/map`, `/monitor`).
- Prefer `/monitor` over repeated one-off scrapes whenever the same URL/site needs checking more than once ("alert me when X changes").
- A lightweight Firecrawl **MCP connector** (search-only) is also available in this account's connector list for interactive chat use; this skill's REST API covers the full feature set (crawl/map/monitor/parse) for scripted work.
