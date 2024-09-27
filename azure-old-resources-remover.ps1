$resources = Get-AzResource|Where-Object {$_.tags.keys -match "TTL"}
$currentDate = Get-Date -format "dd-MM-yy"
$resources.foreach{
    $creationDate = Get-Date $PSItem.tags["CreationDate"]
    $days = (New-TimeSpan -Start $creationDate -End $currentDate).days
    $difDays = $PSItem.tags["TTL"] - $days
    if($difDays -le 0)
    {
        $resourceName = $PSItem.Name
        Write-Output "Remove the resource $resourceName"
        Remove-AzResource -ResourceId $PSItem.ResourceId -Force
    }
}