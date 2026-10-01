# AGEL Marketing — interný Claude plugin marketplace

Interný zdroj pluginov pre Claude Code pre marketingový tím AGEL.

## Obsah

- **ppc-seo-apis** — skilly pre ScrapeCreators (social/ad-library scraping),
  DataForSEO (SEO/SERP/keyword dáta) a Firecrawl (web scraping/crawling).
  Pozri [plugins/ppc-seo-apis/SETUP.md](plugins/ppc-seo-apis/SETUP.md).

## Pridanie tohto marketplace (pre administrátora, raz)

Tento priečinok treba nahrať niekam, odkiaľ ho vie Claude Code stiahnuť —
typicky git repozitár (napr. interný GitLab/GitHub AGEL org). Potom každý
člen tímu spustí:

```
/plugin marketplace add <owner/repo alebo URL>
/plugin install ppc-seo-apis@agel-marketing-tools
```

Presný prvý príkaz závisí od toho, kam sa repo nahralo — doplň konkrétnu
adresu po nahraní.

## Pridanie ďalšieho pluginu

1. Vytvor nový priečinok v `plugins/<meno-pluginu>/` s `.claude-plugin/plugin.json`
   a (voliteľne) `skills/`, `agents/`, `commands/`, `hooks/`.
2. Pridaj záznam do `.claude-plugin/marketplace.json` (pole `plugins`).
3. Commitni a pushni — členovia tímu dostanú update automaticky pri ďalšom
   `claude plugin update` (alebo pri reštarte, ak má marketplace `autoUpdate`).
