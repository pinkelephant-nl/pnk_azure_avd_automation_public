Param   

(  

    [Parameter (Mandatory = $false)]  

    [string] $SerialNumber, 

  

    [Parameter (Mandatory = $false)] 

    [string] $HardwareHash, 

     

    [Parameter (Mandatory = $false)] 

    [string] $OrderIdentifier = "", 

     

    [Parameter (Mandatory = $false)] 

    [object]$WebhookData 

) 

if ($WebHookData) { 

# Collect properties of WebhookData 

    $WebhookName = $WebHookData.WebhookName 

    $WebhookHeaders = $WebHookData.RequestHeader 

    $WebhookBody = $WebHookData.RequestBody 

  

    $Input = (ConvertFrom-Json -InputObject $WebhookBody) 

  

    $SerialNumber = $Input.SerialNumber 

    $HardwareHash = $Input.HardwareHash 

    $OrderIdentifier = $Input.OrderIdentifier 

} 

  

####################################################################### 

Import-Module Microsoft.Graph.Intune  

Import-Module WindowsAutopilotIntune 

  

#collect and set variables 

$IntuneClientId = Get-AutomationVariable -Name Intune-Client-Id 

$IntuneSecret = Get-AutomationVariable -Name Intune-Secret 

$tenantid = Get-AutomationVariable -Name Intune-Tenant 

$tenant = $tenantid 

$authority = "https://login.windows.net/$tenant" 

$clientId = $IntuneClientId  

$clientSecret = $IntuneSecret 

  

Update-MSGraphEnvironment -AppId $clientId -Quiet  

Update-MSGraphEnvironment -AuthUrl $authority -Quiet  

Connect-MSGraph -ClientSecret $ClientSecret -Quiet 

Get-AutopilotDevice 

############################################################# 

#Register Device for AutoPilot 

$dev = Add-AutoPilotImportedDevice -serialNumber $SerialNumber -hardwareIdentifier $HardwareHash -orderIdentifier $OrderIdentifier 

  

$processingCount = 1 

while ($processingCount -gt 0) { 

    $deviceStatuses = Get-AutoPilotImportedDevice -id $dev.id 

    $deviceCount = $deviceStatuses.Length 

    if (-not $deviceCount -and $deviceStatuses ) { $devicecount = 1} 

     

    # Check to see if any devices are still processing 

    $processingCount = 0 

    foreach ($device in $deviceStatuses) { 

        if ($device.state.deviceImportStatus -eq "unknown") { 

            $processingCount = $processingCount + 1 

        } 

    } 

    Write-Output "Waiting for $processingCount of $deviceCount" 

  

    # Still processing?  Sleep before trying again. 

    if ($processingCount -gt 0) { 

        Start-Sleep 2 

    } 

} 

  

# Display the statuses 

$deviceStatuses | ForEach-Object { 

    Write-Output "Serial number $($_.serialNumber): $($_.state.deviceImportStatus) $($_.state.deviceErrorCode) $($_.state.deviceErrorName)" 

} 

  

#Cleanup 

Remove-AutoPilotImportedDevice -id $dev.id 
