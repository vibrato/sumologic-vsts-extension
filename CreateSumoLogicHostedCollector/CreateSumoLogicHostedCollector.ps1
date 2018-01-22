Trace-VstsEnteringInvocation $MyInvocation
Import-Module -Name $PSScriptRoot\ps_modules\VstsTaskSdk\VstsTaskSdk.psm1

# Get inputs.
$SumoLogicAccessKeyId = Get-VstsInput -Name SumoLogicAccessKeyId -Require
$SumoLogicAccessKey = Get-VstsInput -Name SumoLogicAccessKey -Require
$SumoLogicEndpoint = Get-VstsInput -Name SumoLogicEndpoint -Require
$SumoLogicCollectorName = Get-VstsInput -Name SumoLogicCollectorName -Require
$SumoLogicCollectorCategory = Get-VstsInput -Name SumoLogicCollectorCategory -Require

Write-Output "AccessKeyId: $SumoLogicAccessKeyId"
Write-Output "AccessKey: $($SumoLogicAccessKey.Substring(0,8))"
Write-Output "APIEndpoint: $SumoLogicEndpoint"
Write-Output "CollectorName: $SumoLogicCollectorName"
Write-Output "CollectorCategory: $SumoLogicCollectorCategory"

function New-SumoLogicHostedCollector {
    param (
        [Parameter(Mandatory=$true)]
            [ValidateNotNull()]
            [ValidateNotNullOrEmpty()]
            [Hashtable]$AuthHeader,
        [Parameter(Mandatory=$true)]
            [ValidateNotNull()]
            [ValidateNotNullOrEmpty()]
            [string]$ApiEndpoint,
        [Parameter(Mandatory=$true)]
            [ValidateNotNull()]
            [ValidateNotNullOrEmpty()]
            [string]$CollectorName,
        [Parameter(Mandatory=$false)]
            [string]$CollectorDescription,
        [Parameter(Mandatory=$false)]
            [string]$CollectorCategory,
        [Parameter(Mandatory=$false)]
            [string]$CollectorHostName,
        [Parameter(Mandatory=$false)]
            [string]$CollectorTimeZone,
        [switch]$Ephemeral
    )

    $CollectorData = @{
        collectorType = "Hosted"
        name = $SumoLogicCollectorName
    }

    if($CollectorDescription) { $CollectorData.Add('description', $CollectorDescription) }
    if($CollectorCategory)    { $CollectorData.Add('category', $CollectorCategory) }
    if($CollectorHostName)    { $CollectorData.Add('hostName', $CollectorHostName) }
    if($Ephemeral)            { $CollectorData.Add('ephemeral', $true ) }
    if($CollectorTimeZone)    { $CollectorData.Add('timeZone', $CollectorTimeZone) }

    $RequestData = @{
        collector = $CollectorData
    }

    Write-Verbose $CollectorData

    $NewCollector = Invoke-WebRequest -Method Post -Headers $AuthHeader -Uri ($ApiEndpoint+'/collectors') -Body ($RequestData | ConvertTo-Json) -UseBasicParsing

    return $NewCollector.Content | ConvertFrom-Json
}


$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $SumoLogicAccessKeyId,$SumoLogicAccessKey)))
$AuthHeader = @{
    Authorization=("Basic {0}" -f $base64AuthInfo)
    'Content-Type' = 'application/json'
    }

$CollectorReq = Invoke-WebRequest -Method Get -Headers $AuthHeader -Uri ($SumoLogicEndpoint+'/collectors') -UseBasicParsing

$CollectorsCollection = ($CollectorReq.Content | ConvertFrom-Json)

$Collector = $CollectorsCollection.collectors.Where({$_.name.ToLower() -eq $SumoLogicCollectorName.ToLower()})

if(-not $Collector)
{
    Write-Output "Creating Hosted Collector: $SumoLogicCollectorName"
    $Collector = (New-SumoLogicHostedCollector `
        -AuthHeader $AuthHeader  `
        -ApiEndpoint $SumoLogicEndpoint `
        -CollectorName $SumoLogicCollectorName `
        -CollectorCategory $SumoLogicCollectorCategory).collector
}
else
{
    Write-Output "Collector Exists: $SumoLogicCollectorName"
}