[CmdletBinding()]
param(
  [string]$TemplateDir = "",
  [string]$PackagedTemplateFile = "",
  [string]$AwsBinary = "",
  [string]$Region = "",
  [string]$S3Bucket
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $PSCommandPath

if ([string]::IsNullOrWhiteSpace($TemplateDir)) {
  $TemplateDir = Join-Path $scriptRoot "..\\templates"
}

if ([string]::IsNullOrWhiteSpace($PackagedTemplateFile)) {
  $PackagedTemplateFile = Join-Path $scriptRoot "..\\templates\\packaged-main.yaml"
}

if ([string]::IsNullOrWhiteSpace($AwsBinary)) {
  $awsCommand = Get-Command aws -ErrorAction SilentlyContinue

  if ($awsCommand) {
    $AwsBinary = $awsCommand.Source
  }
  else {
    $fallbackAws = "C:\\Program Files\\Amazon\\AWSCLIV2\\aws.exe"

    if (Test-Path $fallbackAws) {
      $AwsBinary = $fallbackAws
    }
  }
}

if ([string]::IsNullOrWhiteSpace($Region)) {
  if (-not [string]::IsNullOrWhiteSpace($env:AWS_DEFAULT_REGION)) {
    $Region = $env:AWS_DEFAULT_REGION
  }
  else {
    $Region = "ap-southeast-1"
  }
}

function Invoke-Step {
  param(
    [Parameter(Mandatory = $true)][string]$Label,
    [Parameter(Mandatory = $true)][scriptblock]$Action
  )

  Write-Host "==> $Label" -ForegroundColor Cyan
  & $Action

  if ($LASTEXITCODE -ne 0) {
    throw "$Label failed with exit code $LASTEXITCODE."
  }
}

if ([string]::IsNullOrWhiteSpace($AwsBinary) -or -not (Test-Path $AwsBinary)) {
  throw "aws CLI was not found in PATH and no fallback binary was found."
}

$templateRoot = (Resolve-Path $TemplateDir).Path
$networkTemplate = Join-Path $templateRoot "network.yaml"
$securityTemplate = Join-Path $templateRoot "security.yaml"
$computeTemplate = Join-Path $templateRoot "compute.yaml"
$mainTemplate = Join-Path $templateRoot "main.yaml"

foreach ($templatePath in @($networkTemplate, $securityTemplate, $computeTemplate)) {
  Invoke-Step -Label "validate-template $(Split-Path $templatePath -Leaf)" -Action {
    & $AwsBinary cloudformation validate-template --region $Region --template-body "file://$templatePath"
  }
}

$cfnLint = Get-Command cfn-lint -ErrorAction SilentlyContinue

if ($cfnLint) {
  Invoke-Step -Label "cfn-lint" -Action {
    cfn-lint --non-zero-exit-code error $networkTemplate $securityTemplate $computeTemplate $mainTemplate
  }
}
else {
  Write-Warning "cfn-lint was not found in PATH. Skipping linter step."
}

if ($S3Bucket) {
  Invoke-Step -Label "cloudformation package" -Action {
    & $AwsBinary cloudformation package `
      --region $Region `
      --template-file $mainTemplate `
      --s3-bucket $S3Bucket `
      --output-template-file $PackagedTemplateFile
  }

  Invoke-Step -Label "validate packaged main template" -Action {
    & $AwsBinary cloudformation validate-template --region $Region --template-body "file://$PackagedTemplateFile"
  }
}
else {
  Write-Warning "Skipping package and main template validation because -S3Bucket was not provided."
}
