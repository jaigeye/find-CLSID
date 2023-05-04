<#
.DESCRIPTION
Feed me a CLSID to fetch a "pretty" name from varying registry locations that may contain it. For example:
Expected Input:   {2A118EB5-5797-4F5E-8B3D-F4ECBA3C98E4}
Expected Output:  C:\Program Files (x86)\Common Files\Adobe\CoreSyncExtension\CoreSync_x64.dll

.EXAMPLE
PS> .\Find-CLSID.ps1 -CLSID 2A118EB5-5797-4F5E-8B3D-F4ECBA3C98E4

.EXAMPLE
PS> .\Find-CLSID.ps1 -CLSID {2A118EB5-5797-4F5E-8B3D-F4ECBA3C98E4}

.PARAMETER CLSID
The only flag required: a CLSID string, which has the format of 8,4,4,4,12 hexadecimal bytes. If one is not provided, the user will be prompted to enter one.

#>

# this is ugly and painful but it makes an exact match so fuck it we ball
param (
    [ValidateNotNullOrEmpty()]
    [string]$CLSID = $(Read-Host "Input CLSID string")
)

$input_regex = "^\{([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}$"

# paths the CLSID may be in  
$paths = @('HKLM:\SOFTWARE\Classes\CLSID',
         'Microsoft.PowerShell.Core\Registry::HKEY_CLASSES_ROOT\CLSID',
         'HKLM:\SOFTWARE\Classes\WOW6432Node\CLSID',
         'HKLM:\SOFTWARE\WOW6432Node\Classes\CLSID')  

foreach ($i in $CLSID){  
    # append key to end of path to enumerate "pretty" name
    if ($i -notmatch $input_regex) {$i = $("{" + $i + "}")}
    $joined = Join-Path -Path $paths -ChildPath ($i + "\InProcServer32") 
}

$path_check = Test-Path $joined
if ($path_check -eq $true)
{
    Get-Item -Path $joined -ErrorAction SilentlyContinue;
}
else
{
    write-host "The CLSID" $CLSID "was not found in the local registry.";
}
