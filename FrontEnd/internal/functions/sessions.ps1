function sessions {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)] 
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session,
        [Parameter(Mandatory = $false)]
        [switch]$Detailed
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {
        [string]$usr = Read-Host "Active Directory or local account to use {Press ENTER to default to your admin account}";
        [string]$type = Read-Host "Type of session to create (RDP or SSH) {Press ENTER to default to RDP}";
        [string]$hlist = Read-Host "Absolute path to list containing hostnames or a ';' delimited list (host1;host2;host3;)";

        Invoke-RemoteSession -sessionToken $Session -User $usr -TypeOfSession $type -HostList $hlist -Detailed:$Detailed;
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}