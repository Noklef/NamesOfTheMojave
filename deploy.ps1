# Deploys src/ to the MO2 mod folder.
# Mirrors: files removed from src/ are removed from the target. MO2's meta.ini is kept.
param(
    [string]$Target = $(if ($env:NOTM_DEPLOY_TARGET) { $env:NOTM_DEPLOY_TARGET } else { throw 'Set NOTM_DEPLOY_TARGET to the MO2 mod folder, or pass -Target' })
)
$ErrorActionPreference = 'Stop'

# /XF also protects meta.ini from /MIR purge.
robocopy "$PSScriptRoot\src" $Target /E /MIR /XF meta.ini .gitkeep /NJH /NJS /NDL /NP
if ($LASTEXITCODE -ge 8) { throw "robocopy failed with code $LASTEXITCODE" }
Write-Host "Deployed to $Target"
exit 0  # robocopy codes 1-7 mean success; do not leak them
