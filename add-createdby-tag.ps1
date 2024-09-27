$resources = Get-AzResource

$currentTime = Get-Date
$endTime = $currentTime.AddDays(-7 * $cnt)
$startTime = $endTime.AddDays(-7)

$resources.foreach{
    $untaggedResources = $PSItem.tags["CreatedBy"]
    if($untaggedResources -eq $null)
    {
        $owner = Get-AzLog -ResourceId $PSItem.ResourceId -StartTime $startTime -EndTime $endTime | Where {$_.Authorization.Action -like "*/write*"} |
        Select -ExpandProperty Caller |
        Group-Object |
        Sort-Object  |
        Select -ExpandProperty Name
        $PSItem.Tags.Add("CreatedBy", $owner)
        $PSItem | Set-AzResource -Force
    }

}