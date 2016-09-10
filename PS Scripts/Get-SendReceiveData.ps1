function Get-SendReceiveData {
    <#
    .SYNOPSIS
    Sends and receives data over a socket connection

    .DESCRIPTION
    New-Socket creates a new System.Net.Sockets.Socket and connects to it for sending and receiving data.

    .PARAMETER socket
    Socket to send data.

    .PARAMETER sendData
    Data to send.

    .EXAMPLE
    Get-SendReceiveData -socket (New-Socket -system appsecusamedcenter.com -portNo 80) -sendData([System.Text.Encoding]::ASCII.GetBytes("TextData")) 
    
    .NOTES
    Written by JW @fpieces
    Concept was adapted from Michael Born's (@Blu3Gl0w13) AppSec 2015 Hands on Web Exploitation With Python Shellshock scripts.
    Additional information on working with sockets in .NET can be found at: https://msdn.microsoft.com/en-us/library/system.net.sockets.socket(v=vs.110).aspx
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [System.Net.Sockets.Socket]
        $socket,

        [parameter(Mandatory=$true)]
        [Byte[]]
        $sendData
    )

    process {
        $socket.Send($sendData)

        $receiveBuffer = New-Object Byte[] 256
        $receivedBytes = $socket.Receive($receiveBuffer)

        $responseString = ""
        while ($receivedBytes) {
            $responseString = $responseString + [System.Text.Encoding]::ASCII.GetString($receiveBuffer)
            $receivedBytes = $socket.Receive($receiveBuffer)
        }

        Write-Output $responseString
    }
}

