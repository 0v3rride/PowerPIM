function getpass {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)] 
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session,

        [Alias("u")]
        [Parameter(Mandatory = $false)]
        [string]$User = (Get-ADUser -Identity "$($env:username)admin").UserPrincipalName,

        [Alias("c")]
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME,

        [Alias("p")]
        [Parameter(Mandatory = $false)]
        [switch]$Print,

        [Alias("d")]
        [Parameter(Mandatory = $false)]
        [switch]$Detailed
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"
    } 
    process {
        $passwd = (Get-PIMPassword -sessionToken $Session -User $User -ComputerName $ComputerName -Detailed:$Detailed);
                
        if ([string]::IsNullOrEmpty($passwd)) {
            Write-Host "[E]: Could not obtain password for specified user!" -f Red;
        }
        else {
            Set-Clipboard -Value $passwd; #copy to clipboard
        
            if ($Print) {
                Write-Host "[`$PASSWORD$]: $passwd" -f Green;
            }

            Write-Host @"
[$]: The password has been copied to your clipboard!
"@ -f Green;
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}