param(
    [string]$PrismDir = $(if ($env:PRISM_DIR) { $env:PRISM_DIR } else { 'E:\llama-prism-clean' }),
    [string]$ModelDir = $(if ($env:MODEL_DIR) { $env:MODEL_DIR } else { 'E:\models' })
)

$ErrorActionPreference = 'Stop'
$server = Join-Path $PrismDir 'llama-server.exe'

Write-Host ''
Write-Host '=== NVIDIA ==='
if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) {
    nvidia-smi
} else {
    Write-Warning 'nvidia-smi no está disponible en PATH.'
}

Write-Host ''
Write-Host '=== llama.cpp Prism ==='
if (Test-Path -LiteralPath $server) {
    & $server --version
} else {
    Write-Warning "No se encuentra $server"
}

Write-Host ''
Write-Host '=== CUDA DLLs ==='
if (Test-Path -LiteralPath $PrismDir) {
    Get-ChildItem -LiteralPath $PrismDir -File |
        Where-Object { $_.Name -like 'cudart*.dll' -or $_.Name -like 'cublas*.dll' } |
        Select-Object Name, Length
} else {
    Write-Warning "No se encuentra $PrismDir"
}

Write-Host ''
Write-Host '=== Modelo ==='
if (Test-Path -LiteralPath $ModelDir) {
    Get-ChildItem -LiteralPath $ModelDir -Filter '*Ternary-Bonsai-27B*PQ2*.gguf' -File |
        Select-Object FullName, Length
} else {
    Write-Warning "No se encuentra $ModelDir"
}
