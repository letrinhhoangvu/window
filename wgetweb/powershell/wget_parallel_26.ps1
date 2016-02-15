workflow RunDownloadHtml
{
     param(
        [Parameter()]
        [String]$exeProgram, 
        [Parameter()]
		[string]$dirReadFile,
        [Parameter()]
		[string]$replaceText,
        [Parameter()]
		[string]$logPath,
        [Parameter()]
		[string]$outputPath,
        [Parameter()]
		[string]$cookiePath,
        [Parameter()]
		[string]$logFile
	 )
     try {               
            $FilesInFolder = Get-ChildItem  $dirReadFile -filter "*.txt"  
            ForEach($File in $FilesInFolder) {
                $a = Get-Content $File.FullName
                ForEach -Parallel($b in $a) {
                    Download-HTML $exeProgram $b.ToString() $replaceText $logPath  $outputPath $cookiePath $logFile
                }
                    
            }			
	} catch {
		#Write-Error $_.Exception.Message	
	}
}
Function Download-HTML {
	[CmdletBinding()]
	param(
        [Parameter()]
		[string]$exeProgram,
        [Parameter()]
		[string]$linkFile,
        [Parameter()]
		[string]$replaceText,
        [Parameter()]
		[string]$logPath,
        [Parameter()]
		[string]$outputPath,
        [Parameter()]
		[string]$cookiePath,
        [Parameter()]
		[string]$logFile
	)
	begin {
        $linkDownLoad = "http://leonotes09.leopalace21.com/SoumuJin/ringi_soumu.nsf/569DE1E70D3FD5EB49256BBB003B7467/XXXXX?OpenDocument"
        $linkDownLoad= $linkDownLoad -replace $replaceText,$linkFile
        echo  $linkDownLoad      
	}
    process {        
        try {          
        & $exeProgram -q -P $outputPath --save-cookies=$cookiePath --keep-session-cookies --load-cookies=$cookiePath -p -k -E -r -l1 $linkDownLoad
        } catch {
            #Write-Output $linkDownLoad | Out-File $logFile
        }   
    }
	end { 
    }
}
$exeProgram = "C:\Program Files\GnuWin32\bin\wget"
$logFile = "C:\vulth\domino\download_domino.log"
$loginUrl = "http://leonotes09.leopalace21.com/names.nsf?Login"
$postData = '"username=admin&password=password&redirectto=%2Ftop.nsf%3FOpen"'
$outputPath = "C:\vulth\domino"
$dirReadFile = "C:\vulth\domino\linked_files"
$logPath = "C:\vulth\domino\log.txt"
$cookiePath = "C:\vulth\domino\cookie.txt"
$replaceText = 'XXXXX'
$start_time = Get-Date
# Run Parallel wget
#echo  "$exeProgram -P $outputPath --save-cookies=$cookiePath --keep-session-cookies --post-data=$postData $loginUrl"
try {  
    & $exeProgram -q -P $outputPath --save-cookies=$cookiePath --keep-session-cookies --post-data=$postData $loginUrl
} catch {
    #Write-Error $_.Exception.Message
    #Write-Output $file | Out-File $logFile
}
#$PSVersionTable.PSVersion  
RunDownloadHtml $exeProgram  $dirReadFile  $replaceText $logPath  $outputPath $cookiePath $logFile
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

