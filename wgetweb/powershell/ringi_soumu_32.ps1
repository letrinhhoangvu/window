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
		[string]$outputPath,
        [Parameter()]
		[string]$cookiePath,
        [Parameter()]
		[string]$postData,
        [Parameter()]
		[string]$loginUrl,
        [Parameter()]
        [string] $linkDownLoad
	 )
     
     try {              
            $FilesInFolder = Get-ChildItem  $dirReadFile
            ForEach($File in $FilesInFolder) {
                Wget-Cookie $exeProgram $outputPath $cookiePath $postData $loginUrl
                echo $File.FullName
                $rows = Get-Content $File.FullName
                #-throttlelimit 100
                ForEach -Parallel  ($row in $rows) {
                    Download-HTML $exeProgram $row.ToString() $replaceText $outputPath $cookiePath $linkDownLoad
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
		[string]$outputPath,
        [Parameter()]
		[string]$cookiePath,
        [Parameter()]
        [string] $linkDownLoad
	)
	begin {
        $linkDownLoad= $linkDownLoad -replace $replaceText,$linkFile
        #echo  $linkDownLoad      
	}
    process {        
        try {          
        & $exeProgram -q -P $outputPath --keep-session-cookies --load-cookies=$cookiePath -p -k -E -r -l1 $linkDownLoad
        } catch {
            #Write-Output $linkDownLoad | Out-File $logFile
        }   
    }
	end { 
    }
}
Function Wget-Cookie {
	[CmdletBinding()]
	param(
        [Parameter()]
		[string]$exeProgram,
        [Parameter()]
		[string]$outputPath,
        [Parameter()]
		[string]$cookiePath,
        [Parameter()]
		[string]$postData,
        [Parameter()]
		[string]$loginUrl
	)
    try {         
    & $exeProgram -q -P $outputPath --save-cookies=$cookiePath --keep-session-cookies --post-data=$postData $loginUrl
    } catch {
        #Write-Output $linkDownLoad | Out-File $logFile
    }   
   
}
$fileName= $MyInvocation.MyCommand.Name  -replace '.ps1$',''
$exeProgram = "C:\Program Files\GnuWin32\bin\wget"
$dirReadFile = $outputPath+".\"+$fileName
$outputPath =  Split-Path $script:MyInvocation.MyCommand.Path
$cookiePath =   $outputPath+"\"+$fileName+"_cookie.txt"
$loginUrl = "http://leonotes09.leopalace21.com/names.nsf?Login"
$postData = '"username=admin&password=password&redirectto=%2Ftop.nsf%3FOpen"'
$replaceText = 'XXXXX'
$linkDownLoad = "http://leonotes09.leopalace21.com/SoumuJin/Archivedata/ringi_soumu_32.nsf/569DE1E70D3FD5EB49256BBB003B7467/XXXXX?OpenDocument"
$start_time =  Get-Date
RunDownloadHtml $exeProgram  $dirReadFile  $replaceText  $outputPath $cookiePath  $postData $loginUrl $linkDownLoad
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"