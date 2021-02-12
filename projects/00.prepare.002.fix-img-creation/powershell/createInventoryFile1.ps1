param ($sumVersionString, $sumPlatformString)

# This script creates an inventory file for all products mentioned in this git project

## ATTENTION: This is not documented and may not work in the future!

$lines = Get-ChildItem -path ".." -Recurse | Select-String -pattern "InstallProducts="
$productsHash = @{} #using a hash for unique values
foreach ($line in $lines){
    if( $line -match ".*:InstallProducts=(?<products>.*)" ){
        foreach ($productString in $matches['products'].split(',')){
            $productCode=$productString.split('/')[-1]
            $productsHash["$productCode"] = "1"
        }
    }
}
if ($productsHash.Count -gt 0){
    $installedProducts = @()
    foreach ($productId in $productsHash.Keys){
        $installedProducts += (@{
            "productId" = $productId
            "displayName" = $productId
            "version" = $sumVersionString
        })
    }
    $document=@{
        "installedFixes" = @()
        "installedSupportPatches" = @()
        "envVariables" = @{
            "platformGroup" = @("UNX-ANY","LNX-ANY")
            "UpdateManagerVersion" = "11.0.0.0000-0117"
            "Hostname" = "localhost"
            "platform" = "$sumPlatformString"
        }
        "installedProducts" = $installedProducts
    }
    $document | ConvertTo-Json -depth 100 | Out-File -Encoding "ascii" "inventory_${sumVersionString}_$sumPlatformString.json"
}else{
    Write-Output "No products"
}
