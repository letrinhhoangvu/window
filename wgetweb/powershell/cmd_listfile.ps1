#ls | where {$_.Length -lt 10mb} | Remove-Item
#Get-ChildItem $path -Filter *.stat -recurse |?{$_.PSIsContainer -eq $false -and $_.length -lt 500}|?{Remove-Item $_.fullname -WhatIf}
$outputPath =  Split-Path $script:MyInvocation.MyCommand.Path
cmd /c "dir $outputPath /b /o:e /a:-d > cmd_listfile.txt" # /l :lower case
echo (Get-Content cmd_listfile.txt) 
(Get-Content cmd_listfile.txt) -replace 'batch_file', '222' | Set-Content cmd_listfile.txt
$result= Get-ChildItem $outputPath  -Filter *.html  |?{$_.PSIsContainer -eq $false -and $_.length -eq 1150}|?{Remove-Item $_.fullname -WhatIf}
echo $result
ls 