function New-TCPSocketStream {
    <#
    .SYNOPSIS
    Returns a new connected socket

    .DESCRIPTION
    New-Socket creates a new System.Net.Sockets.Socket and connects to it for sending and receiving data.

    .PARAMETER system
    The system to connect.  Required if IP Address parameter is not used.

    .PARAMETER portNo
    The port to connect.

    .EXAMPLE
    New-Socket -serverName appsecusamedcenter.com -portNo 80
    New-Socket -ipAddress 127.0.0.1 -portNo 80
    
    .NOTES
    Written by JW @fpieces
    Concept was adapted from Michael Born's (@Blu3Gl0w13) AppSec 2015 Hands on Web Exploitation With Python Shellshock scripts.
    Additional information on working with sockets in .NET can be found at: https://msdn.microsoft.com/en-us/library/system.net.sockets.socket(v=vs.110).aspx
    
    #>

    [CmdletBinding()]
    param (
        [parameter()]
        [string]
        $system,

        [parameter(Mandatory=$true)]
        [int]
        $portNo
    )

    process {
        $ip = [System.Net.IPAddress]::Parse(([System.Net.Dns]::GetHostAddresses($system)[0]).IPAddressToString)
        $ipe = New-Object System.Net.IPEndPoint $ip, $portNo

        $s = New-Object System.Net.Sockets.Socket $ipe.AddressFamily, ([System.Net.Sockets.SocketType]::Stream), ([System.Net.Sockets.ProtocolType]::Tcp)
        $s.Connect($ipe);

        if ($s.Connected) {
            Write-Output $s
        }
        else {
            Write-Output $null
        }
    }
}