function Create-PageInputObject {
    <#
    .SYNOPSIS
    Grabs form inputs and exports to object.

    .DESCRIPTION
    Create-PageInputObject grabs the inputs from the form and outputs to a custom object.  Current revision only works with text input controls.  Will need to addapt for other forms of input.

    .PARAMETER uri
    url to grab inputs from.

    .PARAMETER activeSession
    The active web session to use

    .EXAMPLE
    $newSession = Initialize-WebSession -uri "http://metasploitable/dvwa/login.php"
    $test = Create-PageInputObject -uri "http://metasploitable/dvwa/login.php" -activeSession $newSession.Session
    $test | Get-Member

    TypeName: System.Management.Automation.PSCustomObject

    Name        MemberType   Definition                    
    ----        ----------   ----------                    
    Equals      Method       bool Equals(System.Object obj)
    GetHashCode Method       int GetHashCode()             
    GetType     Method       type GetType()                
    ToString    Method       string ToString()             
    password    NoteProperty string password=              
    username    NoteProperty string username= 

    .NOTES
    Written by JW @fpieces
    Additional information on using Invoke-WebReqest can be found at: https://technet.microsoft.com/en-us/library/hh849901.aspx
    
    #>

    [CmdletBinding()]
    param (
    [parameter(Mandatory = $true)]
        [System.Uri] $uri,

    [parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession] $activeSession
    )

    process {
        #Custom PSObject for creating the page input properties
        $outputObject = New-Object PSObject

        #Gets the page inputs and adds the property to the custom object.
        (Invoke-WebRequest -Uri $uri -WebSession $activeSession).InputFields | Where-Object { ($_.OuterHTML -inotmatch "type") -or ($_.OuterHTML -imatch "password") } | ForEach-Object {
        $outputObject | Add-Member -Name $_.Name -MemberType NoteProperty -Value ""
        }

        Write-Output $outputObject
    }
}