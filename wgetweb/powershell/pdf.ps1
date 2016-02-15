workflow RunHtmlToPdf 
{
     param(
        [Parameter()]
        [String]$exeProgram, 
        [Parameter()]
		[string]$htmlFolder,
        [Parameter()]
		[string]$logFile
	 )
     try {
				
                $FilesInFolder = Get-ChildItem  $htmlFolder -filter "*.html"
                ForEach -Parallel ($File in $FilesInFolder) {
                      Convert-PDF $exeProgram $File.FullName $logFile
                    
                }
			
	} catch {
		Write-Error $_.Exception.Message	
	}
}
Function Convert-PDF {
	[CmdletBinding()]
	param(
        [Parameter()]
		[string]$exeProgram,
        [Parameter()]
		[string]$HtmlFile,
        [Parameter()]
		[string]$logFile
	)
	begin {
        $file = ""
        $PdfFile= $HtmlFile -replace '.html$','.pdf'          
	}
    process {
        try {
            $file = $HtmlFile
            & $exeProgram -q --encoding shift_jis $HtmlFile  $PdfFile
            
        } catch {
            #Write-Error $_.Exception.Message	
            Write-Output $file | Out-File $logFile
        }
    }
	end { 
    }
}
$htmlFolder = "D:\wgetweb\powershell\domino" 
$exeProgram = "C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf"
$logFile = "D:\wgetweb\powershell\domino\domino.log"
$start_time = Get-Date
# Run Parallel wget
RunHtmlToPdf $exeProgram  $htmlFolder $logFile
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

