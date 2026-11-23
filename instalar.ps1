# Instala a skill /cantos-apple no Claude Code (para todos os projetos).
# Uso: powershell -ExecutionPolicy Bypass -File instalar.ps1            -> %USERPROFILE%\.claude\skills\cantos-apple
#      powershell -ExecutionPolicy Bypass -File instalar.ps1 -Projeto   -> .\.claude\skills\cantos-apple
param([switch]$Projeto)
$ErrorActionPreference = "Stop"

$origem = Join-Path $PSScriptRoot "skills\cantos-apple\SKILL.md"
if (-not (Test-Path $origem)) { Write-Host "Nao achei skills\cantos-apple\SKILL.md. Rode a partir do repositorio clonado."; exit 1 }

if ($Projeto) { $destino = Join-Path (Get-Location) ".claude\skills\cantos-apple" }
else { $destino = Join-Path $env:USERPROFILE ".claude\skills\cantos-apple" }

New-Item -ItemType Directory -Force -Path $destino | Out-Null
Copy-Item $origem (Join-Path $destino "SKILL.md") -Force
Write-Host "Skill instalada em $destino"
Write-Host "Abra o Claude Code no seu projeto e digite: /cantos-apple"
