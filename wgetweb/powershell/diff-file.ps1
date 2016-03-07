$fileName= $MyInvocation.MyCommand.Name  -replace '_diff.ps1$',''
$outputPath =  Split-Path $script:MyInvocation.MyCommand.Path 
$outputPath = "$outputPath\$fileName"

#Delete login file
$downPath = "C:\vulth\domino\leonotes09.leopalace21.com\SoumuJin\Archivedata\ringi_soumu_32.nsf\569DE1E70D3FD5EB49256BBB003B7467"
Get-ChildItem $downPath  -Filter *.html  |?{$_.PSIsContainer -eq $false -and $_.length -eq 1150}|?{Remove-Item $_.fullname -WhatIf}
#list file 
$downFile = $outputPath+"\down_file.txt"
$sourceFile="C:\vulth\domino\linked_files_source\$fileName.txt"
$compareFile = "$outputPath\compare_file.txt"
#delete files in foders
Remove-Item "$outputPath\*"
cmd /c "dir $downPath /b /o:e /a:-d > $downFile" 
(Get-Content $downFile) -replace '@OpenDocument.html$', '' | Set-Content $downFile
Compare-Object -ReferenceObject (Get-Content $sourceFile) -DifferenceObject  (Get-Content $downFile) | WHERE {$_.SideIndicator -eq “<=”} | select -ExpandProperty InputObject | Out-File $compareFile
Remove-Item $downFile
#if ( (Get-Item $compareFile).length -gt 33920 ) {
#  echo "Run split"
  cmd /c "split -l 1000 $compareFile compare_file_"
  if ( (Get-ChildItem $outputPath).Count -gt  1 ) {
    Remove-Item $compareFile
  }
#} else {
#    echo "Run continue" 
#}
#
Invoke-Item (start powershell ((Split-Path $MyInvocation.InvocationName) + "\$fileName.ps1"))