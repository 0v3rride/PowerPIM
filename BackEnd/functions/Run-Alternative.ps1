function Run-Alternative {
    <#
    .SYNOPSIS

        This module will grab the password for the specified domain user (UPN format) and start the program, service or application as this specified user via
        the absolute path given for the ApplicationPath argument. Works with .msc MMC snap-ins too.

    .PARAMETER sessionToken
    
        The session token or 'session state' value returned from the Invoke-PIMSignIn module.
        
    .PARAMETER Detailed

        A switch argument that shows verbose information regarding calls to the API. Recommended, but not required.

    .PARAMETER User
        
        The user you want to get the password for. By default it is the current user who is logged in and is mapped to their domain admin account. To get the password for a domain account, use the
        following User Principal Name schema (aduser@domain). Local accounts do not require the UPN schema.
    
    .PARAMETER ComputerName

        PIM requires that you give a host that the logged in API user has access to (jsmith, wsus_maint-1, etc.). You can view this in the BeyondTrust Password Safe web console under the
        the systems tab (local accounts) and domain linked accounts (domain accounts).
            
#>

    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)] 
        [Microsoft.PowerShell.Commands.WebRequestSession]$sessionToken,

        [Parameter(Mandatory = $false)]
        [string]$User = (Get-ADUser -Identity "$($env:username)admin").UserPrincipalName,

        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false)]
        [string]$Domain = $env:USERDOMAIN,

        [Parameter(Mandatory = $false)]
        [switch]$Detailed,

        [Parameter(Mandatory = $true)]
        [string]$ApplicationPath
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting";
        
        #User input validation
        if ([string]::IsNullOrEmpty($User) -or $User -eq " ") {
            $User = (Get-ADUser -Identity "$($env:username)admin").UserPrincipalName;
        }

        #User input validation
        if ([string]::IsNullOrEmpty($ComputerName) -or $ComputerName -eq " ") {
            $ComputerName = $env:COMPUTERNAME;
        }

        #User input validation
        if ([string]::IsNullOrEmpty($Domain) -or $Domain -eq " ") {
            $Domain = $env:USERDOMAIN;
        }

        if ($User -notlike '*@*') {
            $User = ((Get-ADUser -Identity $User).UserPrincipalName); 
        }

        if ($ApplicationPath -match '\*') {
            Write-Host "[I]: ApplicationPath [$ApplicationPath] contains a wildcard using Get-ChildItem to resolve path." -f Yellow

            if ((Get-ChildItem -Path $ApplicationPath | Select-Object FullName -First 1).FullName) {
                $ApplicationPath = (Get-ChildItem -Path $ApplicationPath | Select-Object FullName -First 1).FullName
                Write-Host "[I]: Get-ChildItem resolved path to [$ApplicationPath]." -f Yellow
            }
        }

        # if (-not (Test-Path -Path $ApplicationPath)) {
        #     Write-Error "[E]: ApplicationPath [$ApplicationPath] does not exist."
        # }
    }

    process {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2

        $username = $User.Split('@')[0];
        [string]$passwd = (Get-PIMPassword -sessionToken $sessionToken -User $User -ComputerName $ComputerName -Detailed:$Detailed);
        Set-Clipboard -Value $passwd;

        if ($Detailed) { Write-Host "[I]: Run as user [$Domain\$username]..." -f Yellow; }

        if ([System.IO.File]::Exists($ApplicationPath)) {
            $fpass = ConvertTo-SecureString $passwd -AsPlainText -Force;
            $fuser = "$($env:USERDOMAIN)\$($username)"
            $cred = New-Object System.Management.Automation.PSCredential ($fuser, $fpass);
            
            try {
                switch ($ApplicationPath.ToLower()) {
                    { $_ -like "*msc" } {
                        $call = ('Start-Process -FilePath mmc.exe -ArgumentList {0} -WorkingDirectory $env:windir -verb runAs' -f $ApplicationPath);
                        Start-Process PowerShell -NoNewWindow -ArgumentList $call -Credential $cred;
                        break; 
                    }
                    default {
                        $call = ('Start-Process -FilePath {0} -WorkingDirectory $env:windir -verb runAs' -f $ApplicationPath);
                        Start-Process PowerShell -NoNewWindow -ArgumentList $call -Credential $cred;
                        break;
                    }
                }
            }
            catch {
                Write-Error "
                Error message: $_
                StackTrace: $($_.ScriptStackTrace)"
            }
        }
        else {
            return "The option selected was invalid or the file path for the specified option does not exist!";
        }
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}