
# monitor.ps1 - Monitors a web page for changes
# sends an  notification if the file change
# By:Octavis Jones 4/4/16
# v3 - 1/28/2018
#    - Ported to Powershell
#
##################################################

###
# PowerShell Module for displaying Windows 10 Toast Notifications
# https://github.com/Windos/BurntToast
###

function compare_sites(){
    Param($file1,$file2,$title)

    ## Compares the two files 
    Write-Host "Comparing site $title"
    if(Compare-Object -ReferenceObject $(Get-Content $file1) -DifferenceObject $(Get-Content $file2)){

        ## Uses BURNTOAST to pup-up notification of changes
        New-BurntToastNotification -Text "Title Statment", "Take a look at  $title , Something has changed"
    }
}

function check_site(){
    Param($url,$name)
## Creates new file if one does not exist. Prevents error of moving old to new
    if (-NOT (Test-Path .\monitorsites\$name"_new.txt")){
        echo " " >> .\monitorsites\$name"_new.txt"   }
    Copy-Item -path .\monitorsites\$name"_new.txt" -destination .\monitorsites\$name"_old.txt" 

## pulls down site to txt file

    Invoke-RestMethod -Uri $url -OutFile ".\monitorsites\$name.txt"
    Write-Host "Downloading site $name"

## Searchs txt doc for string and places output in new file
    sls "<search String to pull out and compare>" ".\monitorsites\$name.txt" | select -exp line > .\monitorsites\$name"_new.txt"

## Removes full downloaded site txt doc
    Remove-Item -path .\monitorsites\$name".txt"
    
    compare_sites -file1 .\monitorsites\$name"_old.txt" -file2 .\monitorsites\$name"_new.txt" -title $name
}

### Function calls - Check sites

check_site -url <site> -name <sitename>
