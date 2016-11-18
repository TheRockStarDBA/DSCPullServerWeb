
<#
    .SYNOPSIS
    Update a MOF configuration checksum on a DSC Pull Server.

    .DESCRIPTION
    The Update-DSCPullServerConfigurationChecksum cmdlet uses the
    Invoke-RestMethod to recalcualte the checksum file for an existing MOF
    configuration. The DSC Pull Server Web API must be deployed on the target
    DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    DSCPullServerWeb.Configuration.

    .EXAMPLE
    PS C:\> Update-DSCPullServerConfigurationChecksum -Uri 'http://localhost:8081/api' -Name 'Demo'
    Recalcualte the checksum of the Demo configuration.

    .EXAMPLE
    PS C:\> Update-DSCPullServerConfigurationChecksum -Uri 'http://localhost:8081/api' -Name 'Demo' -Credential 'DOMAIN\user'
    Recalcualte the checksum of the Demo configuration with alternative
    credentials.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Update-DSCPullServerConfigurationChecksum
{
    [CmdletBinding()]
    [OutputType([PSObject])]
    param
    (
        # Base uri to the DSC Pull Server including the relative '/api' path.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        # Use this parameter to specified the target MOF configuration name.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        # Optionally specify credentials for the request.
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    # Use splatting to prepare the parameters.
    $RestMethodParam = @{
        Method = 'Get'
        Uri    = "$Uri/configurations/$Name/hash"
    }

    # Depending on the credential input, add the default or specfic credentials.
    if ($null -eq $Credential)
    {
        $RestMethodParam.UseDefaultCredentials = $true
    }
    else
    {
        $RestMethodParam.Credential = $Credential
    }

    $configurations = Invoke-RestMethod @RestMethodParam

    foreach ($configuration in $configurations)
    {
        $configuration.PSTypeNames.Insert(0, 'DSCPullServerWeb.Configuration')

        Write-Output $configuration
    }
}