function Invoke-Rdp {
        <#
        .SYNOPSIS
        
            This module launches RDP sessions on the hosts specified by the host list argument via the specified account.

        .DESCRIPTION

            Use the Get-Help cmdlet to see examples
        
        .PARAMETER sessionToken
            
            The session token or 'session state' value returned from the Invoke-PIMSignIn module.
        
        .PARAMETER Detailed

            A switch argument that shows verbose information regarding calls to the API. Recommended, but not required.
        
        .PARAMETER User
    
            The Active Directory user you want to use to initiate the RDP session(s) with. If no value is given, then it is the admin account of the current user logged into to the system that
            the this script is running on. Otherwise, if you specify an Active Directory user then it should be in the user principal name format (Useradmin@domain). If
            it is a shared or service account, then it will be the name of the APIUser that was created locally on the PIM appliance to manage the account. 
            
            E.g. shared or service accounts
            + wsusapiuser on the PIM appliance manages the wsusadmin shared account

        .PARAMETER HostList
    
            The value is either a string represntation of the absolute path to a text file that contains the list of hosts in the following format:

            + example.txt
                + Inside example.txt
                    host-h1
                    host-h2
                    host-h3
                    host-h4
                    ...

            Or it is a ',' delimited list of host names.

        .EXAMPLE

            Invoke-Rdp -sessionToken <value returned from Invoke-SignIn> -User aduseradmin@domain -HostList C:\Users\username\Desktop\hostlist.txt
            Invoke-Rdp -sessionToken <value returned from Invoke-SignIn> -User pimapiuser -HostList host1,host2,host3,host4
            
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$sessionToken,

        [Parameter(Mandatory = $false)]
        [switch]$Detailed,

        [Parameter(Mandatory = $true)]
        [string]$User,

        [Parameter(Mandatory = $true)]
        [string[]]$HostList
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"
        
        $User = (Get-ADUser -Identity $User.Split("@")[0]).UserPrincipalName

        if ([System.IO.File]::Exists($HostList)) {
            $Servers = Get-Content -Path $HostList
        }
        else {
            $Servers = $HostList.Split(',').Trim() 
        }
    }
    process {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2

        foreach ($Server in $Servers) {
            if (-not [string]::IsNullOrEmpty($Server)) {
                if ($Detailed) { Write-Host "[I]: Setting up an rdp session on [$Server] as [$User]..." -f Yellow; }
                
                $rID = Invoke-PIMRequest -sessionToken $sessionToken -Detailed:$Detailed -User $User -ComputerName $Server -Type "RDP";

                $SessionsBody = @{
                    SessionType = "rdpfile"
                }
                $sessionValue = Invoke-RestMethod -Uri "$script:RestApiUrl/Requests/$rID/Sessions" -Method POST -WebSession $sessionToken -Body (ConvertTo-Json $SessionsBody) -ContentType "application/json";
                
                $rdpFile = "$($env:temp)\$Server-$User.rdp"
                if ($Detailed) { Write-Host "[I]: Saving file to [$rdpFile]." -f Yellow; }

                $sessionValue | Out-File -FilePath $rdpFile;
                Invoke-Item $rdpFile;
            }
        }  
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}