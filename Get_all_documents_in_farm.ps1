function Get-DocInventory() {
    [void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
    $x = 0 
    $xn = 0
    $farm = [Microsoft.SharePoint.Administration.SPFarm]::Local
    foreach ($spService in $farm.Services) {
        if (!($spService -is [Microsoft.SharePoint.Administration.SPWebService])) {
            continue;
        }

        foreach ($webApp in $spService.WebApplications) {
            if ($webApp -is [Microsoft.SharePoint.Administration.SPAdministrationWebApplication]) { continue }

            foreach ($site in $webApp.Sites) {
                foreach ($web in $site.AllWebs) {
                    foreach ($list in $web.Lists) {
                        if ($list.BaseType -ne "DocumentLibrary") {
                            continue
                        }
                        foreach ($item in $list.Items) {
                            $x = $x  + $item.File.Length
                            $xn = $xn + 1
                            $data = @{
                                "Web Application" = $webApp.ToString()
                                "Site" = $site.Url
                                "Web" = $web.Url
                                "list" = $list.Title
                                "Item ID" = $item.ID
                                "Item URL" = $item.Url
                                "Item Title" = $item.Title
                                "Item Created" = $item["Created"]
                                "Item Modified" = $item["Modified"]
                                "File Size" = $item.File.Length/1KB
                            }
                            New-Object PSObject -Property $data
                        }
                    }
                    $web.Dispose();
                }
                $site.Dispose()
                Write-Host $site "   Total Files: " $xn " |     Total Size : " $x
            }
        }
    }
    Write-Host "Total Files: " $xn " |     Total Size : " $x "Bytes"
}
