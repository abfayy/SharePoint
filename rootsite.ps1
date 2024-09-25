$site_url = "" # site URL 
$site = get-SPSite $site_url
$web = $site.rootweb
Write-Host $web.Title
$temp = $web.WebTemplate
Write-Host $web.WebTemplate
Write-Host $temp.Name
Write-Host $web.WebTemplateID
$site.close()
