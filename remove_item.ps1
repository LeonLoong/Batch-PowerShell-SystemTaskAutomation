# directory
$LocalDirectory = join-path -path $env:USERPROFILE -childpath "Demo\"
$DemoShortcut = join-path -path $env:USERPROFILE -childpath "Desktop\Demo.lnk"

# remove local folder 
if ((Test-Path $LOCALDIRECTORY)) {
	Remove-Item –path $LocalDirectory –Recurse
} 
if ((Test-Path $DemoShortcut)) {
	Remove-Item –path $DemoShortcut –Recurse
}
else { 
	Write-Host "Demo is not existed"
}

if (-not (Test-Path $LOCALDIRECTORY) -and -not (Test-Path $DemoShortcut)) {
	Write-Host "Demo is removed"
}

pause