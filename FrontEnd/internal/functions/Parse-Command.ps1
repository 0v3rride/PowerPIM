function Parse-Command {
    [CmdletBinding()]
    param(
        [parameter(mandatory = $true)] 
        $command
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {
        try {
            switch ($command.ToLower()) {
                "clear" {
                    Clear-Host;
                    break;
                }
                { $_ -like "help*" } {
                    $mod = $_.Split(' ')[1];
                    help -Module $mod; 
                    break;
                }
                { $_ -like "exit*" } {
                    $UserInput = $_.Replace('exit', '')
                    $FunctionParameters = @{
                        Session  = $global:session_token
                        Detailed = $Detailed
                    }
    
                    if ($UserInput) {
                        $FunctionParameters = Parse-UserInput `
                            -FunctionParameters $FunctionParameters `
                            -UserInput $UserInput `
                            -DefaultUserInputParameter 'n'
                    }
                        
                    Exit-PowerPIM @FunctionParameters
                    break;
                }
                "showrids" {
                    showrids -Session $global:session_token;
                    break;
                }
                "sessions" {
                    sessions -Session $global:session_token -Detailed:$Detailed;
                    break;
                }
                { $_ -like "checkin*" } {
                    $UserInput = $_.Replace('checkin', '')
                    $FunctionParameters = @{
                        Session  = $global:session_token
                        Detailed = $Detailed
                    }
    
                    if ($UserInput) {
                        $FunctionParameters = Parse-UserInput `
                            -FunctionParameters $FunctionParameters `
                            -UserInput $UserInput `
                            -DefaultUserInputParameter 'rid'
                    }
                        
                    checkin @FunctionParameters
                    break;
                }
                { $_ -like "getpass*" } {
                    $UserInput = $_.Replace("getpass", "")
                    $FunctionParameters = @{
                        Session  = $global:session_token
                        Detailed = $Detailed
                    }

                    if ($UserInput) {
                        $FunctionParameters = Parse-UserInput `
                            -FunctionParameters $FunctionParameters `
                            -UserInput $UserInput `
                            -DefaultUserInputParameter 'u'
                    }
                    
                    getpass @FunctionParameters
                    break;
                }
                { $_ -like "resetpass*" } {
                    $UserInput = $_.Replace("resetpass", "")
                    $FunctionParameters = @{
                        Session  = $global:session_token
                        Detailed = $Detailed
                    }

                    if ($UserInput) {
                        $FunctionParameters = Parse-UserInput `
                            -FunctionParameters $FunctionParameters `
                            -UserInput $UserInput `
                            -DefaultUserInputParameter 'u'
                    }
                    
                    resetpass @FunctionParameters
                    break;
                }
                { $_ -like "rdp*" } {
                    $UserInput = $_.Replace('rdp', '')
                    $FunctionParameters = @{
                        Session  = $global:session_token
                        Detailed = $Detailed
                    }

                    if ($UserInput) {
                        $FunctionParameters = Parse-UserInput `
                            -FunctionParameters $FunctionParameters `
                            -UserInput $UserInput `
                            -DefaultUserInputParameter 'h'
                    }
                    
                    rdp @FunctionParameters
                    break;
                }
                { $_ -like "run*" } {
                    $UserInput = $_.Replace("run", "");
                    $UserInput = $UserInput.Split(" ")[1]; #remove small space that is the result of the previous Replace method above this line
                    $FunctionParameters = @{
                        Session  = $global:session_token
                        Detailed = $Detailed
                    }

                    if ($UserInput) {
                        $FunctionParameters = Parse-UserInput `
                            -FunctionParameters $FunctionParameters `
                            -UserInput $UserInput `
                            -DefaultUserInputParameter 'a'
                    }
                    
                    run @FunctionParameters
                    break;
                }
                { $_ -like "getconfig*" } {
                    Get-PIMConfig 
                    break;
                }
                { $_ -like "setconfig*" } {
                    $UserInput = $_.Replace('setconfig', '')
                    $FunctionParameters = @{
                        # No unspecified parameters
                    }

                    if ($UserInput) {
                        $FunctionParameters = Parse-UserInput `
                            -FunctionParameters $FunctionParameters `
                            -UserInput $UserInput `
                            -DefaultUserInputParameter 'N/A'
                    }
                    
                    Set-PIMConfig @FunctionParameters
                    break;
                }
                { $_ -like "setrdcman*" } {
                    $UserInput = $_.Replace('setrdcman', '')
                    $FunctionParameters = @{
                        Detailed = $Detailed
                    }

                    if ($UserInput) {
                        $FunctionParameters = Parse-UserInput `
                            -FunctionParameters $FunctionParameters `
                            -UserInput $UserInput `
                            -DefaultUserInputParameter 'u'
                    }
                    
                    Set-PIMRDCManConfig @FunctionParameters
                    break;
                }
                default {
                    Write-Host "[E]: The command given is not valid! Please use the 'help' command if you are having trouble!" -f Red;
                    break;
                }
            }
        }
        catch {
            Write-Host "$_";
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}