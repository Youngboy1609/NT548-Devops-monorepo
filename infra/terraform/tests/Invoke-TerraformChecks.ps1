[CmdletBinding()]
param(
  [string]$NetworkRoot = "",
  [string]$ComputeRoot = "",
  [string]$TerraformBinary = "",
  [switch]$SkipPlan
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $PSCommandPath

if ([string]::IsNullOrWhiteSpace($NetworkRoot)) {
  $NetworkRoot = Join-Path $scriptRoot "..\\examples\\network"
}

if ([string]::IsNullOrWhiteSpace($ComputeRoot)) {
  $ComputeRoot = Join-Path $scriptRoot "..\\environments\\dev"
}

if ([string]::IsNullOrWhiteSpace($TerraformBinary)) {
  $terraformCommand = Get-Command terraform -ErrorAction SilentlyContinue

  if ($terraformCommand) {
    $TerraformBinary = $terraformCommand.Source
  }
  else {
    $fallbackTerraform = "C:\\Users\\lenovo\\AppData\\Local\\Microsoft\\WinGet\\Packages\\Hashicorp.Terraform_Microsoft.Winget.Source_8wekyb3d8bbwe\\terraform.exe"

    if (Test-Path $fallbackTerraform) {
      $TerraformBinary = $fallbackTerraform
    }
  }
}

function Invoke-Step {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Label,
    [Parameter(Mandatory = $true)]
    [scriptblock]$Action
  )

  Write-Host "==> $Label" -ForegroundColor Cyan
  & $Action

  if ($LASTEXITCODE -ne 0) {
    throw "$Label failed with exit code $LASTEXITCODE."
  }
}

if ([string]::IsNullOrWhiteSpace($TerraformBinary) -or -not (Test-Path $TerraformBinary)) {
  throw "terraform was not found in PATH and no fallback binary was found."
}

$networkRootPath = (Resolve-Path $NetworkRoot).Path
$computeRootPath = (Resolve-Path $ComputeRoot).Path

Invoke-Step -Label "terraform init (network)" -Action {
  & $TerraformBinary "-chdir=$networkRootPath" init -backend=false -input=false
}

Invoke-Step -Label "terraform validate (network)" -Action {
  & $TerraformBinary "-chdir=$networkRootPath" validate
}

Invoke-Step -Label "terraform init (compute)" -Action {
  & $TerraformBinary "-chdir=$computeRootPath" init -backend=false -input=false
}

Invoke-Step -Label "terraform validate (compute)" -Action {
  & $TerraformBinary "-chdir=$computeRootPath" validate
}

$canPlan =
  -not $SkipPlan `
  -and -not [string]::IsNullOrWhiteSpace($env:TF_VAR_key_name) `
  -and $env:TF_VAR_key_name -notin @("REPLACE_ME", "replace_me") `
  -and -not [string]::IsNullOrWhiteSpace($env:TF_VAR_image_id) `
  -and $env:TF_VAR_image_id.StartsWith("ami-")

if ($canPlan) {
  Invoke-Step -Label "terraform plan (compute)" -Action {
    & $TerraformBinary "-chdir=$computeRootPath" plan -input=false
  }
}
else {
  Write-Warning "Skipping terraform plan for infra/terraform/environments/dev because TF_VAR_key_name or TF_VAR_image_id is still a placeholder."
}
