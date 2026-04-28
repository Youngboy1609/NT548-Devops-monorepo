[CmdletBinding()]
param(
  [string]$Region = "ap-southeast-1",
  [Parameter(Mandatory = $true)][string]$StackName,
  [Parameter(Mandatory = $true)][string]$AllowedSshCidr
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

$stack = (Invoke-AwsJson @("cloudformation", "describe-stacks", "--stack-name", $StackName)).Stacks[0]
$outputs = @{}

foreach ($output in $stack.Outputs) {
  $outputs[$output.OutputKey] = $output.OutputValue
}

$publicSubnet = (Invoke-AwsJson @("ec2", "describe-subnets", "--subnet-ids", $outputs["PublicSubnetId"])).Subnets[0]
$privateSubnet = (Invoke-AwsJson @("ec2", "describe-subnets", "--subnet-ids", $outputs["PrivateSubnetId"])).Subnets[0]
$publicSecurityGroup = (Invoke-AwsJson @("ec2", "describe-security-groups", "--group-ids", $outputs["PublicSecurityGroupId"])).SecurityGroups[0]
$privateSecurityGroup = (Invoke-AwsJson @("ec2", "describe-security-groups", "--group-ids", $outputs["PrivateSecurityGroupId"])).SecurityGroups[0]
$publicInstance = (Invoke-AwsJson @("ec2", "describe-instances", "--instance-ids", $outputs["PublicInstanceId"])).Reservations[0].Instances[0]
$privateInstance = (Invoke-AwsJson @("ec2", "describe-instances", "--instance-ids", $outputs["PrivateInstanceId"])).Reservations[0].Instances[0]
$publicRouteTable = (Invoke-AwsJson @("ec2", "describe-route-tables", "--route-table-ids", $outputs["PublicRouteTableId"])).RouteTables[0]
$privateRouteTable = (Invoke-AwsJson @("ec2", "describe-route-tables", "--route-table-ids", $outputs["PrivateRouteTableId"])).RouteTables[0]
$defaultSecurityGroup = (Invoke-AwsJson @("ec2", "describe-security-groups", "--group-ids", $outputs["DefaultSecurityGroupId"])).SecurityGroups[0]

Assert-Check ($publicSubnet.VpcId -eq $outputs["VpcId"]) "Public subnet belongs to the stack VPC."
Assert-Check ($privateSubnet.VpcId -eq $outputs["VpcId"]) "Private subnet belongs to the stack VPC."
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
  ($_.UserIdGroupPairs | Where-Object { $_.GroupId -eq $outputs["PublicSecurityGroupId"] })
} | Select-Object -First 1

Assert-Check ($null -ne $privateSshRule) "Private security group allows SSH from the public security group."
Assert-Check ($publicInstance.SubnetId -eq $outputs["PublicSubnetId"]) "Public EC2 instance is placed in the public subnet."
Assert-Check ($privateInstance.SubnetId -eq $outputs["PrivateSubnetId"]) "Private EC2 instance is placed in the private subnet."
Assert-Check (-not [string]::IsNullOrWhiteSpace($publicInstance.PublicIpAddress)) "Public EC2 instance has a public IP address."
Assert-Check ([string]::IsNullOrWhiteSpace($privateInstance.PublicIpAddress)) "Private EC2 instance does not have a public IP address."

$publicDefaultRoute = $publicRouteTable.Routes | Where-Object {
  $_.DestinationCidrBlock -eq "0.0.0.0/0" -and $_.GatewayId -eq $outputs["InternetGatewayId"]
} | Select-Object -First 1

$privateDefaultRoute = $privateRouteTable.Routes | Where-Object {
  $_.DestinationCidrBlock -eq "0.0.0.0/0" -and $_.NatGatewayId -eq $outputs["NatGatewayId"]
} | Select-Object -First 1

Assert-Check ($null -ne $publicDefaultRoute) "Public route table sends default traffic to the Internet Gateway."
Assert-Check ($null -ne $privateDefaultRoute) "Private route table sends default traffic to the NAT Gateway."
Assert-Check ($defaultSecurityGroup.VpcId -eq $outputs["VpcId"]) "Default VPC security group belongs to the stack VPC."

Write-Host ""
Write-Host "Manual SSH proof is still required:" -ForegroundColor Yellow
Write-Host "1. SSH from your machine to the public EC2 instance."
Write-Host "2. SSH from the public EC2 instance to the private EC2 instance."
Write-Host "3. Capture a failed direct SSH attempt to the private EC2 instance."
