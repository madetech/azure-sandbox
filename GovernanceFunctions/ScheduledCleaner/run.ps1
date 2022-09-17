# Input bindings are passed in via param block.
param($Timer)

$expResources = Search-AzGraph -Query 'Resources | where tags.Expires=~"True" | project id'
foreach ($r in $expResources) {
    Write-Information  "Expired Resource ID=$r.id"
    Remove-AzResource -ResourceId $r.id -Force
}

$rgs = Get-AzResourceGroup;
foreach ($resourceGroup in $rgs) {
    $name = $resourceGroup.ResourceGroupName;
    $count = (Get-AzResource -ResourceGroupName $name).Count;
    if ($count -eq 0) {
        Write-Information  "==> $name is empty. Deleting it...";
        Remove-AzResourceGroup -Name $name -Force
    }
}