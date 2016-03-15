$downPath = "C:\vulth\domino\leonotes09.leopalace21.com\SoumuJin\Archivedata\ringi_soumu_32.nsf\569DE1E70D3FD5EB49256BBB003B7467"
$fileName= $MyInvocation.MyCommand.Name  -replace '_pdf_diff.ps1$',''
$outputPath =  Split-Path $script:MyInvocation.MyCommand.Path 
$outputPath = "$outputPath\$fileName"
#Delete login file
#Get-ChildItem $downPath  -Filter *.html  |?{$_.PSIsContainer -eq $false -and $_.length -eq 1316}|?{Remove-Item $_.fullname}
#list file 
$downFile = $outputPath+"\down_file.txt"
$sourceFile="C:\vulth\domino\linked_files_source\$fileName.txt"
$compareFile = "$outputPath\compare_file.txt"
#delete files in foders
Remove-Item "$outputPath\*"
cmd /c "dir $downPath\*.pdf /b /o:e /a:-d > $downFile" 
(Get-Content $downFile) -replace '@OpenDocument.pdf$', '' | Set-Content $downFile
Compare-Object -ReferenceObject (Get-Content $sourceFile) -DifferenceObject  (Get-Content $downFile) | WHERE {$_.SideIndicator -eq “<=”} | select -ExpandProperty InputObject | Set-Content $compareFile
Remove-Item $downFile
if ( (Get-Item $compareFile).length -lt 350 ) {
    echo "Complete"
}
#if ( (Get-Item $compareFile).length -gt 33920 ) {
#  echo "Run split"
  cmd /c "split -l 1000 $compareFile $outputPath\compare_file_"
  if ( (Get-ChildItem $outputPath).Count -gt  1 ) {
    Remove-Item $compareFile
  }
#} else {
#    echo "Run continue" 
#}
#

#Invoke-Item (start powershell ((Split-Path $MyInvocation.InvocationName) + "\$fileName"+"_pdf.ps1"))

workflow RunHtmlToPdf 
{
     param(
        [Parameter()]
        [String]$exeProgram, 
        [Parameter()]
		[string]$htmlFolder,
        [Parameter()]
		[string]$dirReadFile
	 )
     try {
				
            $FilesInFolder = Get-ChildItem  $dirReadFile
            ForEach($File in $FilesInFolder) {
                $rows = Get-Content $File.FullName
                #-throttlelimit 100
                ForEach -Parallel  ($row in $rows) {
                    $htmlFile = $htmlFolder + "\" + $row.ToString() + "@OpenDocument.html" 
					#echo $htmlFile
                    Convert-PDF $exeProgram $htmlFile 
                }
                    
            }			
			
	} catch {
		#Write-Error $_.Exception.Message	
	}
}
Function Convert-PDF {
	[CmdletBinding()]
	param(
        [Parameter()]
		[string]$exeProgram,
        [Parameter()]
		[string]$HtmlFile
	)
	begin {
        $PdfFile= $HtmlFile -replace '.html$','.pdf'          
	}
    process {
        try {
            #echo $HtmlFile
            & $exeProgram -q --encoding shift_jis $HtmlFile  $PdfFile
            
        } catch {
            #Write-Error $_.Exception.Message	
            #Write-Output $file | Out-File $logFile
        }
    }
	end { 
    }
}
$exeProgram = "C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf"
$outputPath =  Split-Path $script:MyInvocation.MyCommand.Path 
$dirReadFile = "$outputPath\$fileName"
RunHtmlToPdf $exeProgram  $downPath $dirReadFile