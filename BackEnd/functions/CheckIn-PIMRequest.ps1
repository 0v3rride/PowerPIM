function CheckIn-PIMRequest {
    <#
    .SYNOPSIS
        
        This module can be used to check-in open requests with PIM.
    
     .PARAMETER sessionToken
    
        The session token or 'session state' value returned from the Invoke-PIMSignIn module.
        
    .PARAMETER Detailed

        A switch argument that shows verbose information regarding calls to the API. Recommended, but not required.
    
    .PARAMETER Rid

        The specified request ID or number to check-in.

    .PARAMETER All

        A switch argument that shows checks in all active requests with the PIM appliance

    .DESCRIPTION

        Use the Get-Help cmdlet to see examples
    
    .EXAMPLE
        
        There are multiple ways to view open requests:
        1. Use the Show-PIMRequestID powershell function.
        2. If you are using your standard account to access your administrator account an email with the request id will be sent to you email from BeyondInsight.
        3. Login to the web interface and view your active requests (top right corner of the screen).

        Checkin-PIMRequest -sessionToken <value returned from Invoke-SignIn> -Rid 1234 -Detailed
        Checkin-PIMRequest -sessionToken <value returned from Invoke-SignIn> -All -Detailed
#>

    [CmdletBinding(DefaultParameterSetName = "all")]
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$sessionToken,

        [Parameter(mandatory = $false, ParameterSetName = "rid")]
        [string]$Rid,

        [Parameter(mandatory = $false, ParameterSetName = "all")]
        [switch]$All,
        
        [Parameter(Mandatory = $false)]
        [switch]$Detailed
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    }

    process {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2
        
        function CheckInAllRequests {
            $activeRequests = Invoke-RestMethod -Uri ("{0}/Requests?active" -f $script:RestApiUrl) -Method GET -WebSession $sessionToken;

            if ($activeRequests.Count -le 0 -or $activeRequests.Count -eq $null) {
                Write-Host "[I]: All requests have already been checked in!" -f Yellow;
            }
            else {
                foreach ($id in $activeRequests.RequestID) {
                    if ($Detailed) { Write-Host ("[I]: Checking in request ID {0}..." -f $id) -f Yellow; }
                    $checkin = Invoke-RestMethod -Uri ("{0}/Requests/{1}/Checkin" -f $script:RestApiUrl, $id) -Method PUT -WebSession $sessionToken -Body (ConvertTo-Json @{Reason = ("CheckIn-PIMRequest.ps1 :: Objectives Completed :: {0} {1}" -f (Get-Date).ToShortDateString(), (Get-Date).ToShortTimeString()); }) -ContentType "application/json";
                    if ($Detailed) { Write-Host ("[$]: Done checking in request {0}!" -f $id) -f Green; }
                }
            }
        }

        function CheckInRequest {
            try {
                if ($Detailed) { Write-Host ("[I]: Checking in request ID {0}..." -f $Rid) -f Yellow; }
                Invoke-RestMethod -Uri ("{0}/Requests/{1}/Checkin" -f $script:RestApiUrl, $Rid) -Method PUT -WebSession $sessionToken -Body (ConvertTo-Json @{Reason = ("CheckIn-PIMRequest.ps1 :: Objectives Completed :: {0} {1}" -f (Get-Date).ToShortDateString(), (Get-Date).ToShortTimeString()); }) -ContentType "application/json";
                if ($Detailed) { Write-Host ("[$]: Done checking in request ID {0}..." -f $Rid) -f Green; }
            }
            catch {
                Write-Host "$_";
            }
        }

        try {
            #User input validation
            if (([string]::IsNullOrEmpty($Rid) -or $Rid -notmatch "^\d+$") -and ($All -or $All -ne $false)) {
                CheckInAllRequests;
            }
            else {
                CheckInRequest;
            }
        }
        catch {
            Write-Host ($_);
        } 
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}