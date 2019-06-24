function Parse-UserInput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$FunctionParameters,
        [Parameter(Mandatory = $true)]
        [string]$UserInput,
        [Parameter(Mandatory = $true)]
        [string]$DefaultUserInputParameter
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {
        # No parameters specified
        if (-not ($UserInput -like '* -*')) {
            if ($DefaultUserInputParameter -eq 'N/A') {
                Write-Error "[E]: This function does not contain a default parameter mapping.  Please review the function's help for proper syntax."
                break
            }
            else {
                $FunctionParameters.$DefaultUserInputParameter = $UserInput
            }
        }
        # Parameters specified in the format ' -ParameterName'
        else {
            foreach ($Parameter in ($UserInput -split ' -')) {
                if ($Parameter) {
                    $ParameterParts = $Parameter -split " ", 2 # split into name and value.  the value could contain spaces.  This keeps it all together.
                    $Name = $ParameterParts[0]
                    $Value = $ParameterParts[1]

                    #Check if value is null, if it is then this argument is likely a switch
                    if([string]::IsNullOrEmpty($Value))
                    {
                        $FunctionParameters.$Name = $true;
                    }
                    else
                    {
                        $FunctionParameters.$Name = $Value;
                    }    
                }
            }
        }

        return $FunctionParameters
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}