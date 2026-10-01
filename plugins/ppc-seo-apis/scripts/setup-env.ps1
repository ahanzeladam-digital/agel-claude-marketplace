<#
.SYNOPSIS
  One-time setup: adds the API credentials required by the ppc-seo-apis
  plugin (ScrapeCreators, DataForSEO, Firecrawl) to your personal
  ~/.claude/settings.json, without touching anything else already there.

.NOTES
  Written for Windows PowerShell 5.1 (no -AsHashtable, PSCustomObject only).
  Run this once after installing the plugin:
    powershell -ExecutionPolicy Bypass -File setup-env.ps1
  You will be asked for 4 values. Get them from whoever shared the
  internal "AGEL Marketing Claude API keys" note/vault entry with you --
  this script does not contain or fetch any secret itself.
#>

$ErrorActionPreference = "Stop"

$settingsDir  = Join-Path $HOME ".claude"
$settingsPath = Join-Path $settingsDir "settings.json"

if (-not (Test-Path $settingsDir)) {
    New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
}

if (Test-Path $settingsPath) {
    $raw = Get-Content -Path $settingsPath -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        $settings = [PSCustomObject]@{}
    } else {
        $settings = $raw | ConvertFrom-Json
    }
} else {
    $settings = [PSCustomObject]@{}
}

if (-not ($settings.PSObject.Properties.Name -contains "env")) {
    $settings | Add-Member -NotePropertyName "env" -NotePropertyValue ([PSCustomObject]@{})
}

function Set-EnvValue {
    param(
        [string]$Name,
        [string]$Prompt
    )
    $hasExisting = $settings.env.PSObject.Properties.Name -contains $Name
    $existing = if ($hasExisting) { $settings.env.$Name } else { $null }
    $suffix = if ($existing) { " [uz nastavene, Enter = ponechat]" } else { "" }
    $value = Read-Host "$Prompt$suffix"
    if ([string]::IsNullOrWhiteSpace($value)) {
        if ($existing) {
            Write-Host "  -> ponechavam existujucu hodnotu pre $Name" -ForegroundColor DarkGray
        } else {
            Write-Host "  -> preskocene $Name (nenastavene)" -ForegroundColor Yellow
        }
        return
    }
    if ($hasExisting) {
        $settings.env.$Name = $value
    } else {
        $settings.env | Add-Member -NotePropertyName $Name -NotePropertyValue $value
    }
    Write-Host "  -> ulozene $Name" -ForegroundColor Green
}

Write-Host "=== ppc-seo-apis: nastavenie API klucov ===" -ForegroundColor Cyan
Write-Host "Hodnoty ziskaj od administratora tymu (zdielany trezor / poznamka)." -ForegroundColor DarkGray
Write-Host ""

Set-EnvValue -Name "SCRAPECREATORS_API_KEY" -Prompt "ScrapeCreators API key"
Set-EnvValue -Name "DATAFORSEO_LOGIN"       -Prompt "DataForSEO login (e-mail)"
Set-EnvValue -Name "DATAFORSEO_PASSWORD"    -Prompt "DataForSEO API password (nie heslo do dashboardu)"
Set-EnvValue -Name "FIRECRAWL_API_KEY"      -Prompt "Firecrawl API key"

($settings | ConvertTo-Json -Depth 10) | Set-Content -Path $settingsPath -Encoding utf8

Write-Host ""
Write-Host "Hotovo. Ulozene do $settingsPath" -ForegroundColor Cyan
Write-Host "Over funkcnost v novej Claude Code session, napr.: 'over ScrapeCreators kluc'." -ForegroundColor DarkGray
