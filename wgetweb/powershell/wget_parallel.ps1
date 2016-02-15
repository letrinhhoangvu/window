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
                Add-Content $logFile $File.FullName
                ForEach -Parallel -throttlelimit 100 ($b in $a) {
                    #Download-HTML $exeProgram $b.ToString() $replaceText $logPath  $outputPath $cookiePath $logFile
                    Test-Parallel $b.ToString() $logFile
                }
                    
            }			
	} catch {
		#Write-Error $_.Exception.Message	
	}
}
Function Test-Parallel {
        [CmdletBinding()]
	param(
        [Parameter()]
		[string] $file,
        [Parameter()]
		[string]$logFile
	)
    echo $file
    #Add-Content $logFile $file
    #Start-Sleep -s 10
    echo "end-----"
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
        $linkDownLoad = "http://leocdwiwf02.cloudapp.net:8080/imart/XXXXX"
        $linkDownLoad= $linkDownLoad -replace $replaceText,$linkFile          
	}
    process {        
        try {          
        & $exeProgram -o $logPath -P $outputPath --save-cookies=$cookiePath --keep-session-cookies --load-cookies=$cookiePath -p -k -E -r -l1 $linkDownLoad
        } catch {
            #Write-Output $linkDownLoad | Out-File $logFile
            #Add-Content $logFile $file $linkDownLoad 
        }   
    }
	end { 
    }
}
$exeProgram = "D:\leopalace\Programs\GnuWin32\bin\wget"
$logFile = "D:\wgetweb\powershell\domino\download_domino.log"
$loginUrl = 'http://leonotes09.leopalace21.com/names.nsf?Login'
$postData = '"im_user=80D13&im_password=d6fm4ky5eng3wjo7X5Z1tIhKv"'
$outputPath = "D:\wgetweb\powershell\domino"
$dirReadFile = "D:\wgetweb\powershell\domino\linked_files"
$logPath = "D:\wgetweb\powershell\domino\log.txt"
$cookiePath = "D:\wgetweb\powershell\domino\cookie.txt"
$replaceText = 'XXXXX$'
$start_time = Get-Date
# Run Parallel wget
try {  
   # & $exeProgram -o $logPath -P $outputPath --save-cookies=$cookiePath --keep-session-cookies --post-data=$postData $loginUrl
} catch {
    #Write-Error $_.Exception.Message
    #Write-Output $file | Out-File $logFile
}
#$PSVersionTable.PSVersion  
#Set-ExecutionPolicy RemoteSigned
#-throttlelimit $ThrottleLimit
RunDownloadHtml $exeProgram  $dirReadFile  $replaceText $logPath  $outputPath $cookiePath $logFile
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

