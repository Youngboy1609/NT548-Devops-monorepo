[CmdletBinding()]
param(
  [string]$Region = "ap-southeast-1",
  [Parameter(Mandatory = $true)][string]$VpcId,
  [Parameter(Mandatory = $true)][string]$PublicSubnetId,
  [Parameter(Mandatory = $true)][string]$PrivateSubnetId,
  [Parameter(Mandatory = $true)][string]$PublicSecurityGroupId,
  [Parameter(Mandatory = $true)][string]$PrivateSecurityGroupId,
  [Parameter(Mandatory = $true)][string]$PublicInstanceId,
  [Parameter(Mandatory = $true)][string]$PrivateInstanceId,
  [Parameter(Mandatory = $true)][string]$AllowedSshCidr,
  [string]$InternetGatewayId,
  [string]$NatGatewayId,
  [string]$PublicRouteTableId,
  [string]$PrivateRouteTableId,
  [string]$DefaultSecurityGroupId
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Assert-Check {
  param(
    [Parameter(Mandatory = $true)][bool]$Condition,
    [Parameter(Mandatory = $true)][string]$Message
  )

  if (-not $Condition) {
    throw $Message
  }

  Write-Host "PASS: $Message" -ForegroundColor Green
}

function Invoke-AwsJson {
  param(
    [Parameter(Mandatory = $true)][string[]]$Arguments
  )

  $output = & aws @Arguments --region $Region --output json

  if ($LASTEXITCODE -ne 0) {
    throw "aws $($Arguments -join ' ') failed with exit code $LASTEXITCODE."
  }

  return $output | ConvertFrom-Json
}

if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
  throw "aws CLI was not found in PATH."
}

$publicSubnet = (Invoke-AwsJson @("ec2", "describe-subnets", "--subnet-ids", $PublicSubnetId)).Subnets[0]
$privateSubnet = (Invoke-AwsJson @("ec2", "describe-subnets", "--subnet-ids", $PrivateSubnetId)).Subnets[0]
$publicSecurityGroup = (Invoke-AwsJson @("ec2", "describe-security-groups", "--group-ids", $PublicSecurityGroupId)).SecurityGroups[0]
$privateSecurityGroup = (Invoke-AwsJson @("ec2", "describe-security-groups", "--group-ids", $PrivateSecurityGroupId)).SecurityGroups[0]
$publicInstance = (Invoke-AwsJson @("ec2", "describe-instances", "--instance-ids", $PublicInstanceId)).Reservations[0].Instances[0]
$privateInstance = (Invoke-AwsJson @("ec2", "describe-instances", "--instance-ids", $PrivateInstanceId)).Reservations[0].Instances[0]

Assert-Check ($publicSubnet.VpcId -eq $VpcId) "Public subnet belongs to the expected VPC."
Assert-Check ($privateSubnet.VpcId -eq $VpcId) "Private subnet belongs to the expected VPC."
Assert-Check ($publicSubnet.MapPublicIpOnLaunch -eq $true) "Public subnet auto-assigns public IP addresses."
Assert-Check ($privateSubnet.MapPublicIpOnLaunch -eq $false) "Private subnet does not auto-assign public IP addresses."

$publicSshRule = $publicSecurityGroup.IpPermissions | Where-Object {
  $_.IpProtocol -eq "tcp" -and
  $_.FromPort -eq 22 -and
  $_.ToPort -eq 22 -and
  ($_.IpRanges | Where-Object { $_.CidrIp -eq $AllowedSshCidr })
} | Select-Object -First 1

Assert-Check ($null -ne $publicSshRule) "Public security group allows SSH from the configured admin CIDR."

$privateSshRule = $privateSecurityGroup.IpPermissions | Where-Object {
  $_.IpProtocol -eq "tcp" -and
  $_.FromPort -eq 22 -and
  $_.ToPort -eq 22 -and
  ($_.UserIdGroupPairs | Where-Object { $_.GroupId -eq $PublicSecurityGroupId })
} | Select-Object -First 1

Assert-Check ($null -ne $privateSshRule) "Private security group allows SSH from the public security group."

Assert-Check ($publicInstance.SubnetId -eq $PublicSubnetId) "Public EC2 instance is placed in the public subnet."
Assert-Check ($privateInstance.SubnetId -eq $PrivateSubnetId) "Private EC2 instance is placed in the private subnet."
Assert-Check (-not [string]::IsNullOrWhiteSpace($publicInstance.PublicIpAddress)) "Public EC2 instance has a public IP address."
Assert-Check ([string]::IsNullOrWhiteSpace($privateInstance.PublicIpAddress)) "Private EC2 instance does not have a public IP address."
Assert-Check (($publicInstance.SecurityGroups | Where-Object { $_.GroupId -eq $PublicSecurityGroupId }).Count -gt 0) "Public EC2 instance uses the public security group."
Assert-Check (($privateInstance.SecurityGroups | Where-Object { $_.GroupId -eq $PrivateSecurityGroupId }).Count -gt 0) "Private EC2 instance uses the private security group."

if ($PublicRouteTableId -and $InternetGatewayId) {
  $publicRouteTable = (Invoke-AwsJson @("ec2", "describe-route-tables", "--route-table-ids", $PublicRouteTableId)).RouteTables[0]
  $publicDefaultRoute = $publicRouteTable.Routes | Where-Object {
    $_.DestinationCidrBlock -eq "0.0.0.0/0" -and $_.GatewayId -eq $InternetGatewayId
  } | Select-Object -First 1

  Assert-Check ($null -ne $publicDefaultRoute) "Public route table sends default traffic to the Internet Gateway."
}

if ($PrivateRouteTableId -and $NatGatewayId) {
  $privateRouteTable = (Invoke-AwsJson @("ec2", "describe-route-tables", "--route-table-ids", $PrivateRouteTableId)).RouteTables[0]
  $privateDefaultRoute = $privateRouteTable.Routes | Where-Object {
    $_.DestinationCidrBlock -eq "0.0.0.0/0" -and $_.NatGatewayId -eq $NatGatewayId
  } | Select-Object -First 1

  Assert-Check ($null -ne $privateDefaultRoute) "Private route table sends default traffic to the NAT Gateway."
}

if ($DefaultSecurityGroupId) {
  $defaultSecurityGroup = (Invoke-AwsJson @("ec2", "describe-security-groups", "--group-ids", $DefaultSecurityGroupId)).SecurityGroups[0]
  Assert-Check ($defaultSecurityGroup.VpcId -eq $VpcId) "Default VPC security group belongs to the expected VPC."
}

Write-Host ""
Write-Host "Manual SSH proof is still required:" -ForegroundColor Yellow
Write-Host "1. SSH from your machine to the public EC2 instance."
Write-Host "2. SSH from the public EC2 instance to the private EC2 instance."
Write-Host "3. Capture a failed direct SSH attempt to the private EC2 instance."
