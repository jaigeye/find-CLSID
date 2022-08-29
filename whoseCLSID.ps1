# feed me a CLSID to fetch a "pretty" name from varying reg locations that may contain it
# input:   {2A118EB5-5797-4F5E-8B3D-F4ECBA3C98E4}
# output:  C:\Program Files (x86)\Common Files\Adobe\CoreSyncExtension\CoreSync_x64.dll

$CLSID = Read-Host -Prompt "Insert CLSID ..."

# paths the CLSID may be in  
$paths = @('HKLM:\SOFTWARE\Classes\CLSID',
         'Microsoft.PowerShell.Core\Registry::HKEY_CLASSES_ROOT\CLSID',
         'HKLM:\SOFTWARE\Classes\WOW6432Node\CLSID',
         'HKLM:\SOFTWARE\WOW6432Node\Classes\CLSID')  


foreach ($i in $CLSID){  
    # append key to end of path to enumerate "pretty" name  
    $joined = Join-Path -Path $paths -ChildPath ($i + "\InProcServer32") 
}

Get-Item -Path $joined -ErrorAction SilentlyContinue