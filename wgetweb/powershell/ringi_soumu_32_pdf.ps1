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
$htmlFolder = "C:\vulth\domino\leonotes09.leopalace21.com\SoumuJin\Archivedata\ringi_soumu_32.nsf\569DE1E70D3FD5EB49256BBB003B7467" 
$exeProgram = "C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf"
$fileName= $MyInvocation.MyCommand.Name  -replace '_pdf.ps1$',''
$outputPath =  Split-Path $script:MyInvocation.MyCommand.Path 
$dirReadFile = "$outputPath\$fileName"
$sourceFile = "$outputPath\linked_files_source\$fileName.txt"
$sliptFile = "$dirReadFile\$fileName"+"_"
$start_time = Get-Date
# Run Parallel wget
Remove-Item "$dirReadFile\*"
cmd /c "split -l 1000 $sourceFile $sliptFile"
#echo $dirReadFile
RunHtmlToPdf $exeProgram  $htmlFolder $dirReadFile
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

