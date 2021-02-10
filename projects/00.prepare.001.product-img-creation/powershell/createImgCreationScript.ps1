param ($frmkVersionString, $installerPlatformString)

# This script creates an inventory file for all products mentioned in this git project

## ATTENTION: This is not documented and may not work in the future!


$lines = Get-ChildItem -path ".." -Recurse | Select-String -pattern "InstallProducts="
$productsHash = @{} #using a hash for unique values
foreach ($line in $lines){
    if( $line -match ".*$env:H_WMLAB_PRODUCTS_VERSION.*" ){
        if( $line -match ".*:InstallProducts=(?<products>.*)" ){
            foreach ($productString in $matches['products'].split(',')){
                $productsHash["$productString"] = "1"
            }
        }
    }
}
if ($productsHash.Count -gt 0){
    $ofs=","
    $instProdString="InstallProducts="+[string][array]$productsHash.Keys
    Write-Output "### GENERATED"
    Write-Output "LicenseAgree=Accept"
    $instProdString
}else{
    Write-Output "No products"
}
