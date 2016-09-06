function Initialize-WebSession {
    <#
    .SYNOPSIS
    Returns an initial web session

    .DESCRIPTION
    Initialize-WebSession is used to create an initial web session to work with.
    
    .PARAMETER uri
    Url to request to create initialized session object.

    .EXAMPLE
    Initialize-WebSession -uri "http://metasploitable/dvwa/login.php"
    
    .NOTES
    Written by JW @fpieces
    Additional information on using Invoke-WebReqest can be found at: https://technet.microsoft.com/en-us/library/hh849901.aspx
    
    #>

    [CmdletBinding()]

    param(
    [parameter(Mandatory=$true)]
    [System.Uri] $uri
    
    )

    try {
        #Webrequest stored to session variable.
        $iwr = Invoke-WebRequest -uri $uri -SessionVariable initialSession
        
        #Output custom object to keep the session alive.
        $responseWithSession = New-Object PSObject -Property @{ Response = $iwr; Session = $initialSession }
        Write-Output $responseWithSession

    }
    catch {
        #Something went wrong, write the output.
        Write-Host $Error -ForegroundColor Red
    }
    finally {
        $Error.Clear()
    }
}