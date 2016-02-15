
$outputPath = "D:\wgetweb\powershell\domino"
$inputDir = "D:\wgetweb\powershell\domino\linked_files"
$logPath = "D:\wgetweb\powershell\domino\log.txt"
$cookiePath = "D:\wgetweb\powershell\domino\cookie.txt" 
$reconizedUrl = "http"
$searchReplace = 'XXXXX$'
$loginUrl = 'http://leocdwiwf02.cloudapp.net:8080/imart/login'
$certification = 'http://leocdwiwf02.cloudapp.net:8080/imart/certification'
$postData = '"im_user=80D13&im_password=d6fm4ky5eng3wjo7X5Z1tIhKv"'
$urlAfterReplace= "http://leocdwiwf02.cloudapp.net:8080/imart/menu/common/iframe_sender?menuId=5ibgsbzotsx7v"
$dest = "D:\wgetweb\powershell\domino\login.html"
$exe='D:\leopalace\Programs\GnuWin32\bin\wget'
$TeamCitySession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
try {
$formAuth=Invoke-WebRequest $loginUrl -SessionVariable session
$formAuth.Forms["login_form"].Fields["im_user"] = "80D13"
$formAuth.Forms["login_form"].Fields["im_password"] = "d6fm4ky5eng3wjo7X5Z1tIhKv"
#echo ($loginUrl +'/'+ $formAuth.Forms["login_form"].Action) 
$Log = Invoke-WebRequest -method POST -URI ($certification) -Body $formAuth.Forms["login_form"].Fields -WebSession $session
Invoke-WebRequest -Uri $urlAfterReplace -WebSession $session -UseBasicParsing -OutFile $dest
} catch {
Write-Error $_.Exception.Message
#continue
}
#echo $session
 workflow Run-Workflow 
{
     
    Param
    (
        $session
    )
     
     $inputDir = "D:\wgetweb\powershell\domino\linked_files"
     $FilesInFolder = Get-ChildItem  $inputDir -filter "*.txt"
     $urlAfterReplace= "http://leocdwiwf02.cloudapp.net:8080/imart/menu/sitemap"
     $dest = "D:\wgetweb\powershell\domino\"
     
     ForEach  ($File in $FilesInFolder) {
            $a = Get-Content $File.FullName
            $link = ""
            $dem =0
            ForEach -Parallel ($b in $a) {
                try {
                    $WORKFLOW:dem +=1 
                    #echo $WORKFLOW:dem
                    $link1 = $dest + $dem + ".html"
                    echo $link1
                    #if($link){ $link = $b.ToString()}
                    #$replaceFile = $link  -replace $searchReplace ,$b.ToString() 
                    Invoke-WebRequest -Uri $urlAfterReplace -WebSession $session -UseBasicParsing -OutFile $link1
                    echo $dem
                    #echo $replaceFile
                } catch {
                    Write-Error $_.Exception.Message
                    #$WORKFLOW:Host.UI.WriteErrorLine("This is an error")
                    #continue
                }
          }
    }
}
echo "start"
Run-Workflow $session
echo "complete"
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