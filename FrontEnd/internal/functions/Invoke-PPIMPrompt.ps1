function Invoke-PPIMPrompt {
    [CmdletBinding()]
    param (
        
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {
        Write-Host "[I]: Use the 'help' command to list available modules and commands!" -f Yellow;
    
        do {
            $PPcmd = Read-Host "`nPowerPIM >>";
            Parse-Command -command $PPcmd; 
        }
        while ($PPcmd.ToLower() -notlike "exit*");
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}