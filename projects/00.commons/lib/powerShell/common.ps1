Add-Type -AssemblyName System.Windows.Forms

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
function lookupForLocalFile{
    param (
        $WindowTitle
    )
	
	$FileBrowser =  New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop'); Title = $WindowTitle }
	
	$null = $FileBrowser.ShowDialog()
	
	$FileBrowser.FileName
}

function generateEnvLineForFileRef($ParameterName, $WindowTitle){
    $f=lookupForLocalFile($WindowTitle)
    "$ParameterName=$f" 
}