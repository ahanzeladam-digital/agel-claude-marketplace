---
name: dataforseo-api
description: >-
  Query DataForSEO's REST API for SEO and marketing data: Google/Bing/YouTube
  SERP results, keyword search volume and Google Ads data, backlinks and
  domain analytics, on-page audits, DataForSEO Labs (keyword research,
  competitor research, ranked keywords), business data (Google My Business,
  reviews, hotels), app data (App Store/Google Play), merchant/shopping data,
  and content analysis. Use when the user asks about search rankings, SERP
  data, keyword volume/difficulty, backlinks, domain traffic/authority,
  on-page SEO audits, or mentions DataForSEO.
allowed-tools: Bash, Read, WebFetch
homepage: https://dataforseo.com
metadata:
  requires:
    env:
      - DATAFORSEO_LOGIN
      - DATAFORSEO_PASSWORD
  tags:
    - seo
    - serp
    - keywords
    - backlinks
    - domain-analytics
    - on-page
    - business-data
---

# DataForSEO API

REST API for SEO/marketing data. **Base URL:** `https://api.dataforseo.com/v3/`

Credentials/dashboard: https://app.dataforseo.com/

## Authentication

HTTP Basic Auth using `DATAFORSEO_LOGIN` / `DATAFORSEO_PASSWORD` env vars. Encode as `login:password` in Base64 and send as `Authorization: Basic <token>`.

```bash
TOKEN=$(printf '%s' "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" | base64 -w0)
curl -s "https://api.dataforseo.com/v3/appendix/user_data" \
  -H "Authorization: Basic $TOKEN"
```

Credentials cannot be passed as URL params — header only.

## Request Pattern

- Most data endpoints are **POST** with a **JSON array** body (even for a single item), because DataForSEO supports batching multiple tasks per call.
- Two access modes per module:
  - **Standard** (`task_post` → poll `tasks_ready` → `task_get`): async, cheaper, results cached 30 days.
  - **Live** (`.../live` or `.../live/advanced`): synchronous, returns results immediately, costs more.
- Response envelope: `{"status_code":20000,"status_message":"Ok.","tasks":[{"status_code":20000,"cost":<credits>,"result":[...]}]}`. Check both the top-level and per-task `status_code` (20000 = success).
- Responses are JSON by default; append `.xml` or `.html` to the path for other formats.

### Example: SERP live request

```bash
TOKEN=$(printf '%s' "$DATAFORSEO_LOGIN:$DATAFORSEO_PASSWORD" | base64 -w0)
curl -s -X POST "https://api.dataforseo.com/v3/serp/google/organic/live/advanced" \
  -H "Authorization: Basic $TOKEN" \
  -H "Content-Type: application/json" \
  -d '[{"keyword":"albert einstein","location_name":"United States","language_name":"English"}]'
```

### Example: Keyword search volume (standard/task_post)

```bash
curl -s -X POST "https://api.dataforseo.com/v3/keywords_data/google_ads/search_volume/task_post" \
  -H "Authorization: Basic $TOKEN" -H "Content-Type: application/json" \
  -d '[{"keywords":["seo tools","backlink checker"],"location_name":"United States","language_name":"English"}]'
# -> returns a task id, then poll:
curl -s "https://api.dataforseo.com/v3/keywords_data/google_ads/search_volume/tasks_ready" -H "Authorization: Basic $TOKEN"
curl -s "https://api.dataforseo.com/v3/keywords_data/google_ads/search_volume/task_get/<id>" -H "Authorization: Basic $TOKEN"
```

## Main API Modules

| Module | Path prefix | Covers |
|--------|-------------|--------|
| SERP | `/v3/serp/{google,bing,yahoo,baidu,youtube}/...` | Search result pages (organic, ads, maps, images, news) |
| Keywords Data | `/v3/keywords_data/{google_ads,bing,google_trends,dataforseo_trends,clickstream_data}/...` | Search volume, CPC, trends, ad traffic |
| DataForSEO Labs | `/v3/dataforseo_labs/google/...` | Keyword research, ranked keywords, competitor domains, SERP competitors, keyword ideas/suggestions |
| Backlinks | `/v3/backlinks/...` | Backlink summary, referring domains, anchors, bulk metrics |
| Domain Analytics | `/v3/domain_analytics/...` | Technologies, whois, similarweb-style traffic |
| On-Page | `/v3/on_page/...` | Site crawl/audit, instant single-page check, Lighthouse |
| Content Analysis | `/v3/content_analysis/...` | Brand/topic mentions across the web, sentiment |
| Business Data | `/v3/business_data/{google,tripadvisor,...}/...` | Google My Business listings, reviews, hotels |
| App Data | `/v3/app_data/{apple,google}/...` | App Store / Google Play listings, reviews, rankings |
| Merchant | `/v3/merchant/{amazon,google_shopping}/...` | Product listings, prices, reviews |
| AI Optimization | `/v3/ai_optimization/...` | LLM answer/mentions tracking |
| Appendix | `/v3/appendix/...` | Account info (`user_data`), locations, languages, errors |

Always fetch the specific endpoint's docs page at `https://docs.dataforseo.com/v3/<path>/` (e.g. `https://docs.dataforseo.com/v3/serp/google/organic/live/advanced/`) before calling it, to confirm required/optional parameters — the module surface is large and parameters vary a lot per endpoint.

## Cost / Credits

Each task response includes a `"cost"` field (credits charged for that task). `live` endpoints cost more than `task_post`/`task_get` (standard). Check account status any time with the free `/v3/appendix/user_data` endpoint (cost 0).

## Notes

- An official MCP server also exists (`npx dataforseo-mcp-server`, or hosted at `https://mcp.dataforseo.com/v3/mcp`) if a tool-call style integration is ever preferred over raw curl — not installed here.
