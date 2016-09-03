function Post-FormData {
    <#
    .SYNOPSIS
    Post form data to a specific url from a hashtable of values.

    .DESCRIPTION
    Post-FormData uses a Hashtable to create input references to post to a newly created session.
    
    .PARAMETER uri
    Url to post the data to.

    .PARAMETER fields2Post
    Hashtable of input.  Key is the input, value is the data to submit for the field.

    .EXAMPLE
    Post-FormData -uri http://metasploitable/dvwa/login.php -fields2Post @{ "username" = "admin"; "password" = "password" }
    
    .NOTES
    Written by JW @fpieces
    Additional information on using Invoke-WebReqest can be found at: https://technet.microsoft.com/en-us/library/hh849901.aspx
    
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string] $uri,

        [parameter(Mandatory=$true)]
        [Hashtable] $fields2Post
    )

    process {
        #initiating web request to create a session to post back to
        $iwr = Invoke-WebRequest -Uri $uri -SessionVariable session

        #Posts to single item field
        $form2Post = $iwr.Forms[0]
        
        #Loops through the $Fields in the hashtable adding values to appropriate fields
        foreach ($key in $fields2Post.Keys) {
            $form2Post.Fields[$key] = $fields2Post.Get_Item($key)
        }

        try {
            #Posts the URL and if the page is successful will return the posted form data.
            $iwrPost = Invoke-WebRequest -Uri $uri -WebSession $session -Method Post -Body $form2Post.Fields
            if (($iwrPost).StatusCode -eq 200) {
                Write-Output $iwrPost
            }

        }
        catch {
            #Things went wrong so throw the error out
            Write-Output $Error
        }
        finally {
            #Clear the error list
            $Error.Clear()
        }
    }
}