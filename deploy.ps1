# Deploys src/ to the MO2 mod folder. -Spike also copies the spike/ test files.
# Mirrors: files removed from src/ are removed from the target. MO2's meta.ini is kept.
param(
    [switch]$Spike,
    [string]$Target = $(if ($env:NOTM_DEPLOY_TARGET) { $env:NOTM_DEPLOY_TARGET } else { throw 'Set NOTM_DEPLOY_TARGET to the MO2 mod folder, or pass -Target' })
)
$ErrorActionPreference = 'Stop'

function Copy-Tree([string]$Source, [switch]$Mirror) {
    # /XF also protects meta.ini from /MIR purge.
    $opts = @('/E', '/XF', 'meta.ini', '.gitkeep', '/NJH', '/NJS', '/NDL', '/NP')
    if ($Mirror) { $opts += '/MIR' }
    robocopy $Source $Target @opts
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed with code $LASTEXITCODE for $Source" }
}

Copy-Tree "$PSScriptRoot\src" -Mirror
if ($Spike) { Copy-Tree "$PSScriptRoot\spike" }
Write-Host "Deployed to $Target$(if ($Spike) { ' (with spike)' })"
exit 0  # robocopy codes 1-7 mean success; do not leak them
