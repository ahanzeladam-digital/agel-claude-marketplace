# ppc-seo-apis — nastavenie pre člena tímu

Tento plugin dáva Claude Code tri skilly (ScrapeCreators, DataForSEO, Firecrawl),
ktoré vie sám použiť pri PPC/SEO analýzach — kompetitívne audity Meta/Google Ads,
SERP a keyword dáta, scraping/crawling webov.

## 1. Nainštaluj plugin

V Claude Code (alebo Claude desktop appke, Code tab):

```
/plugin marketplace add <URL alebo owner/repo tejto marketplace>
/plugin install ppc-seo-apis@agel-marketing-tools
```

(presný prvý príkaz dostaneš od administrátora tímu — závisí, kam sa tento
priečinok nahral: GitHub repo, interný git server, alebo zdieľaný disk)

## 2. Nastav API kľúče (jednorazovo)

Plugin samotný **neobsahuje žiadne API kľúče** — tie sú tímový firemný majetok,
nie súčasť kódu. Spusti na svojom počítači:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\setup-env.ps1
```

(cesta k `scripts\setup-env.ps1` je v priečinku, kam sa plugin nainštaloval —
`claude plugin list` alebo administrátor ti povie presnú cestu)

Skript sa spýta na 4 hodnoty:
- `SCRAPECREATORS_API_KEY`
- `DATAFORSEO_LOGIN`
- `DATAFORSEO_PASSWORD`
- `FIRECRAWL_API_KEY`

**Tieto hodnoty získaš od administrátora tímu** (zdieľaný trezor hesiel / interná
poznámka "AGEL Marketing Claude API keys") — nie sú nikde v tomto repozitári.

Skript ich bezpečne doplní do `~/.claude/settings.json` bez prepísania
čohokoľvek iného, čo tam už máš nastavené.

## 3. Over, že to funguje

Otvor **novú** Claude Code session (nie tú, v ktorej si práve inštaloval/
nastavoval) a napíš napríklad:

> over mi ScrapeCreators kľúč

Claude by mal zavolať API a potvrdiť funkčnosť.

## Poznámky pre administrátora (nie pre bežného člena tímu)

- Všetci členovia tímu zdieľajú **tie isté 3 API kľúče/účty** (ScrapeCreators,
  DataForSEO, Firecrawl) — nie sú to individuálne OAuth prihlásenia ako pri
  Ahrefs/Windsor.ai/1ClickReport. To znamená, že spotreba kreditov (najmä
  ScrapeCreators a DataForSEO, oba na kreditovom pláne bez paušálu) sa sčítava
  naprieč celým tímom — sleduj zostatok kreditov pravidelne.
- Ak niekto z tímu odíde alebo treba kľúč rotovať, stačí vygenerovať nový kľúč
  u poskytovateľa a dať vedieť zvyšku tímu, nech si znova spustí
  `setup-env.ps1` s novou hodnotou (stará sa prepíše).
