function Split-array 
{

<#  
  .SYNOPSIS   
    Split an array 
  .PARAMETER inArray
   A one dimensional array you want to split
  .EXAMPLE  
   Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -parts 3
  .EXAMPLE  
   Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -size 3
#> 

  param($inArray,[int]$parts,[int]$size)
  
  if ($parts) {
    $PartSize = [Math]::Ceiling($inArray.count / $parts)
  } 
  if ($size) {
    $PartSize = $size
    $parts = [Math]::Ceiling($inArray.count / $size)
  }

  $outArray = @()
  for ($i=1; $i -le $parts; $i++) {
    $start = (($i-1)*$PartSize)
    $end = (($i)*$PartSize) - 1
    if ($end -ge $inArray.count) {$end = $inArray.count}
    $outArray+=,@($inArray[$start..$end])
  }
  return ,$outArray

}
$a = @(1,2,3,4,5,6,7,8,9,10) 
$b = Split-array -inArray $a -parts 3 
#echo $b[2]
$c =9001/1000
$d= [Math]::Ceiling($c)
echo $d