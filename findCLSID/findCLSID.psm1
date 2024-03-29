<#
 .Synopsis
  CLSID to a normalized name because I'm lazy

 .Description
  feed me a CLSID to fetch a "pretty" name from varying reg locations that may contain it

 .Example
   # Run without flags to offer one upon prompt
   # input:   {2A118EB5-5797-4F5E-8B3D-F4ECBA3C98E4}
   # output:  C:\Program Files (x86)\Common Files\Adobe\CoreSyncExtension\CoreSync_x64.dll
   whose-CLSID

 .Example
   # Pipe into it while offering $i as a variable with a CLSID. 
   Get-Item $path | whose-CLSID $i

 .Example
   # Highlight a range of days.
   Show-Calendar -HighlightDay (1..10 + 22) -HighlightDate "2008-12-25"
#>

function Find-CLSID {
param (
    [ValidateNotNullOrEmpty()]
    [string]$CLSID = $(Read-Host "Input CLSID string")
)

# this is ugly and painful but it makes an exact match so fuck it we ball
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
}

Export-ModuleMember -Function find-CLSID
