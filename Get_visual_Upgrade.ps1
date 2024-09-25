# Get all sites and the visual upgrade.

$contentWebAppServices = (Get-SPFarm).services |
? {$_.typename -eq "Microsoft SharePoint Foundation Web Application"}

foreach($webApp in $contentWebAppServices.WebApplications)
{
    Write-Host "Web Application  : " $webApp.name
    Write-Host "Application Pool : " $webApp.ApplicationPool.Name
    
    foreach ($SPSiteCollection in $webApp.Sites)
    {
        Write-Host "******Site Collection: "$SPSiteCollection.URL 
        foreach($SPWeb in $SPSiteCollection.AllWebs)
        {
            Write-Host $SPWeb.URL "|" $SPWeb.UIversion
        }
    }
    
    Get-SPSolution | ForEach-Object {
        if ($_.LastOperationDetails.IndexOf($webApp.url) -gt 0)
        {
            Write-Host "    Solutions:"
            Write-Host "   " $_.DisplayName
        }
    }
} 
