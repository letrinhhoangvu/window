$MyInvocation.MyCommand.Name  -replace '.ps1$',''
$FilesInFolder = Get-ChildItem  -Name -filter "*.html" D:\wgetweb\powershell\domino\leocdwiwf02.cloudapp.net+8080\imart
echo $FilesInFolder | Out-File ..\vu.txt
Compare-Object -ReferenceObject (Get-Content ..\vu.txt) -DifferenceObject  (Get-Content ..\vu2.txt) | WHERE {$_.SideIndicator -eq “<=”} | select -ExpandProperty InputObject | Out-File ..\vua.txt