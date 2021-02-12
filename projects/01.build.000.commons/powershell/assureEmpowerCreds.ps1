if ( $env:H_WMLAB_EMPOWER_USER -eq $null ){
    $env:H_WMLAB_EMPOWER_USER = Read-Host 'Enter empower user'
}else{
    Write-Host "Considering empower user $env:H_WMLAB_EMPOWER_USER already given in the environment"
}

while ( $env:H_WMLAB_EMPOWER_PASS -eq $null ){

    $pword = read-host "Enter Password for empower user $env:H_WMLAB_EMPOWER_USER" -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword)
    $pword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    $pword2 = read-host "Enter Password for empower user $env:H_WMLAB_EMPOWER_USER again" -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword2)
    $pword2 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    if ($pword = $pword2){
        $env:H_WMLAB_EMPOWER_PASS = $pword
    }else{
        Write-Host "Passwords do not match! Asking again..."
    }
    
}
