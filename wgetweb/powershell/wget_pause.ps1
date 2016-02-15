$a = Get-Content D:\wgetweb\powershell\readfile.txt
$exe='D:\leopalace\Programs\GnuWin32\bin\wget'
$path= 'http:d/'
echo $exe$path
$HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | OUT-NULL
$HOST.UI.RawUI.Flushinputbuffer()
ForEach($b in $a) {
    echo $b.ToString();
    $exe='D:\leopalace\Programs\GnuWin32\bin\wget'
    $path= 'http://dantri.com.vn/'
    & $exe -r -np -l 1  $path
}