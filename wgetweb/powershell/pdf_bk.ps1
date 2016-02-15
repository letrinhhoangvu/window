<#
  #Vulth
#>
[CmdletBinding()]
[OutputType()]
param (
    [Parameter()]
	[string]$PSScriptRoot = "D:\wgetweb\powershell\Random Stuff\New-Invoice",
    [Parameter()]
    $HtmlOutput = "$PsScriptRoot\0de3f8ebe92dea15492575380019b1f9@OpenDocument.Html",
    [Parameter()]
    $exe="C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf"
)

begin {
	$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
	Set-StrictMode -Version Latest
	try {
		
		
	    Function Convert-PDF {
			[CmdletBinding()]
			param(
				[Parameter()]
				[string]$HtmlFile
			)
			begin {
				
				try {
                    $PdfFile= $HtmlFile -replace '.html$','.pdf' 
					& $exe  --encoding shift_jis  $HtmlFile $PdfFile 
				} catch {
					#Write-Error ('Convert-PDF: Issue loading or using NReco.PdfGenerator.dll: {0}' -f $_.Exception.Message)
				}
				
			}
			END { }
		}
        
	
    } catch {
	    Write-Error $_.Exception.Message
	    break
    }
}
process {
}
end {
	try {
				Write-Verbose "Converting '$HtmlOutput' content to PDF file '$InvoiceFilePath'"
                $FilesInFolder = Get-ChildItem  $PSScriptRoot -filter "*.html"
                ForEach($File in $FilesInFolder) {
                echo $File.FullName
                     Convert-PDF $File.FullName
                }
			
	} catch {
		Write-Error $_.Exception.Message	
	}
}