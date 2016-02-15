Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & "D:\virtualbox\start_centos7.bat" & Chr(34), 0
Set WshShell = Nothing