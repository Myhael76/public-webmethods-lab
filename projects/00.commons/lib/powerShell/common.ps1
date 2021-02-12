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

Function lookupForLocalFolder([String] $WindowTitle="Select a folder", [String] $initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = $WindowTitle
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

function generateEnvLineForFolderRef($ParameterName, $WindowTitle){
    $f=lookupForLocalFolder($WindowTitle)
    "$ParameterName=$f" 
}