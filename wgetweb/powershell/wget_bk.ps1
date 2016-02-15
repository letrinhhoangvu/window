$outputPath = "D:\wgetweb\powershell\domino"
$inputDir = "D:\wgetweb\powershell\domino\linked_files"
$logPath = "D:\wgetweb\powershell\domino\log.txt"
$cookiePath = "D:\wgetweb\powershell\domino\cookie.txt" 
$reconizedUrl = "http"
$searchReplace = 'XXXXX$'
$loginUrl = 'http://leocdwiwf02.cloudapp.net:8080/imart/login'
$postData = '"im_user=80D13&im_password=d6fm4ky5eng3wjo7X5Z1tIhKv"'
$urlAfterReplace= "http://leocdwiwf02.cloudapp.net:8080/imart/home"

$exe='D:\leopalace\Programs\GnuWin32\bin\wget'
try {
&$exe -o $logPath -P $outputPath --save-cookies=$cookiePath --keep-session-cookies --post-data=$postData $loginUrl
} catch {
#Write-Error $_.Exception.Message
#continue
}
$FilesInFolder = Get-ChildItem  $inputDir -filter "*.txt"
 ForEach($File in $FilesInFolder) {
        $a = Get-Content $File.FullName
        $link = ""
        ForEach($b in $a) {
            try {
            if($link=="") $link = $b.ToString();
            $replaceFile = $link  -replace $searchReplace ,$b.ToString() 
            & $exe -o $logPath -P $outputPath --save-cookies=$cookiePath --keep-session-cookies --load-cookies=$cookiePath -p -k -E -r -l1 $replaceFile
            } catch {
                #Write-Error $_.Exception.Message
                #continue
            }
      }
}

<#
 $a = Get-Content D:\wgetweb\powershell\readfile.txt
ForEach($b in $a) {
    echo $b.ToString();
    $exe='D:\leopalace\Programs\GnuWin32\bin\wget'
    $path= 'http://dantri.com.vn/'
    & $exe -r -np -l 1  $path
}
wget -o D:\wgetweb\powershell\domino\log.txt -P D:\wgetweb\powershell\domino --save-cookies=D:\wgetweb\powershell\domino\cookie.txt --keep-session-cookies --post-data=im_user=80D13&im_password=d6fm4ky5eng3wjo7X5Z1tIhKv http://leocdwiwf02.cloudapp.net:8080/imart/login
#>