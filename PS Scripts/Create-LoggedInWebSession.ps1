function Create-LoggedInWebSession {
    <#
    .SYNOPSIS
    Login to a webpage.

    .DESCRIPTION
    Create-LoggedInWebSession logs a user into a web page using a post method.
    
    .PARAMETER uri
    Login Url

    .PARAMETER form2Submit
    The form used to submit back to the page

    .PARAMETER activeSession
    The session being used to post the data back to.

    .EXAMPLE
    $iws = Initialize-WebSession -uri "http://metasploitable/dvwa/login.php"
    $form2Post = $iws.Response.Forms[0]
    $form2Post.Fields["username"] = "admin"
    $form2Post.Fields["password"] = "password"
    $loggedInSession = Create-LoggedInWebSession -uri "http://metasploitable/dvwa/login.php" -form2Submit $form2Post -activeSession $iws.Session


    .NOTES
    Written by JW @fpieces
    Additional information on using Invoke-WebReqest can be found at: https://technet.microsoft.com/en-us/library/hh849901.aspx
    
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [System.Uri] $uri,

        [parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.FormObject] $form2Submit,

        [parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession] $activeSession
    )

    process {
        try {
            #Posting the request.
            $loginRequest = Invoke-WebRequest -Uri $uri -Method Post -Body $form2Submit -WebSession $activeSession
            
            #Sends the login response back out with the active session to keep it alive.
            $loggedInSession = New-Object PSObject -Property @{ Response = $loginRequest; Session = $activeSession}
            Write-Output $loggedInSession
        }
        catch {
            #Something went wrong, write the output.
            Write-Host $Error -ForegroundColor Red
        }
        finally {
            $Error.Clear()
        }
    }
}