# directory
$GlobalDirectory = "A:\Demo\Global\"
$LocalDirectory = join-path -path $env:USERPROFILE -childpath "Demo\"

# variable folder to copy from global to local
$GlobalProjects = join-path -path $GlobalDirectory -childpath "Projects\Demo\dist"

# variable folder to delete
$LocalProjects = join-path -path $LocalDirectory -childpath "Projects\Demo\dist"

# get Demo process
$Demo = Get-Process Demo -ErrorAction SilentlyContinue

if ($decision -eq 0) {
  Write-Host 'confirmed'
} else {
  Write-Host 'cancelled'
}
 

if ($Demo) {
	$message  = 'Demo.exe is running...'
	$prompt = '[Y}es to terminate Demo process and continue or [N]o to abort current update'
	$yes = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes','Terminate Demo process and continue'
	$no = New-Object System.Management.Automation.Host.ChoiceDescription '&No','Abort current update'
	$options = [System.Management.Automation.Host.ChoiceDescription[]] ($yes,$no)
	$decision = $host.ui.PromptForChoice($title,$prompt,$options,0)
	if ($decision -eq 0) {
		# try gracefully first
		$Demo.CloseMainWindow()
		# kill after five seconds
		Sleep 5
		if (!$Demo.HasExited) {
			#Stop-Process -processname Demo
			$Demo | Stop-Process -Force
			Write-Host 'Demo.exe is terminated, Demo updating...'
		}
	} else {
	  Write-Host 'Update Aborted'
	}
}

Remove-Variable Demo

if ((Test-Path $LocalProjects)) {
	Remove-Item –path $LocalProjects –Recurse
}

if (!(Test-Path $LocalProjects))
{
	Write-Host "Creating" $LocalProjects "..."
	Copy-Item $GlobalProjects -Destination $LocalProjects -Recurse
	Write-Host $LocalProjects "is up-to-date."
}
	
pause