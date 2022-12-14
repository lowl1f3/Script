<#
	.SYNOPSIS
	A PowerShell script for Windows that automates installation and configuration of programs

	Copyright (c) 2022 lowl1f3

	Big thanks directly to farag2

	.NOTES
	Supported Windows 10 & 11 versions

	.LINK GitHub
	https://github.com/lowl1f3/Script

	.LINK Telegram
	https://t.me/lowlif3

	.LINK Discord
	https://discord.com/users/330825971835863042

	.NOTES
	https://github.com/farag2/Office
	https://github.com/farag2/Sophia-Script-for-Windows

	.LINK Author
	https://github.com/lowl1f3
#>

function Confirmation {
	# Startup confirmation
	$Title         = "Have you customized the preset file before running Script?"
	$Message       = ""
	$Options       = "&No", "&Yes"
	$DefaultChoice = 0
	$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

	switch ($Result)
	{
		"0" {
			Invoke-Item -Path "$PSScriptRoot\..\Script.ps1"
			exit
		}
		"1" {
			continue
		}
	}
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Script:DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$Script:DesktopFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop

function Telegram
{
	Write-Verbose -Message "Installing Telegram..." -Verbose

	# Downloading the latest Telegram Desktop
	$Parameters = @{
		Uri             = "https://telegram.org/dl/desktop/win64"
		OutFile         = "$DownloadsFolder\TelegramSetup.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\TelegramSetup.exe" -ArgumentList "/VERYSILENT"

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Telegram" -Direction Inbound -Program "$env:APPDATA\Telegram Desktop\Telegram.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Telegram" -Direction Outbound -Program "$env:APPDATA\Telegram Desktop\Telegram.exe" -Action Allow
}

function Discord
{
	Write-Verbose -Message "Installing Discord..." -Verbose

	# Downloading the latest Discord
	# https://discord.com/download
	$Parameters = @{
		Uri             = "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x86"
		OutFile         = "$DownloadsFolder\DiscordSetup.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\DiscordSetup.exe" -Wait

	# Remove Discord from autostart
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name Discord -Force -ErrorAction Ignore

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Discord" -Direction Inbound -Program "$env:LOCALAPPDATA\Discord\Update.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Discord" -Direction Outbound -Program "$env:LOCALAPPDATA\Discord\Update.exe" -Action Allow
}

function BetterDiscord
{
	Write-Verbose -Message "Installing Better Discord..." -Verbose

	# Downloading the latest BetterDiscord
	# https://github.com/BetterDiscord/Installer/releases/latest
	$Parameters = @{
		Uri             = "https://api.github.com/repos/BetterDiscord/Installer/releases"
		UseBasicParsing = $true
	}
	$LatestBetterDiscordTag = (Invoke-RestMethod @Parameters).tag_name | Select-Object -Index 0

	$Parameters = @{
		Uri             = "https://github.com/BetterDiscord/Installer/releases/download/$($LatestBetterDiscordTag)/BetterDiscord-Windows.exe"
		OutFile         = "$DownloadsFolder\BetterDiscordSetup.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Stop-Process -Name Discord -Force -ErrorAction Ignore

	Start-Process -FilePath "$DownloadsFolder\BetterDiscordSetup.exe" -Wait

	Stop-Process -Name BetterDiscord -Force -ErrorAction Ignore
}

function BetterDiscordPlugins
{
	if (Test-Path -Path "$env:APPDATA\BetterDiscord\")
	{
		# Installing Better Discord plugins
		$Plugins = @(
			# BDFDB
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Library/0BDFDB.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js",

			# BetterFriendList
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/BetterFriendList/BetterFriendList.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/BetterFriendList/BetterFriendList.plugin.js",

			# BetterMediaPlayer
			# https://github.com/unknown81311/BetterMediaPlayer/blob/main/BetterMediaPlayer.plugin.js
			"https://raw.githubusercontent.com/unknown81311/BetterMediaPlayer/main/BetterMediaPlayer.plugin.js",

			# BetterSearchPage
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/BetterSearchPage/BetterSearchPage.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/BetterSearchPage/BetterSearchPage.plugin.js",

			# CallTimeCounter
			# https://github.com/QWERTxD/BetterDiscordPlugins/blob/main/CallTimeCounter/CallTimeCounter.plugin.js
			"https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js",

			# CharCounter
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/CharCounter/CharCounter.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/CharCounter/CharCounter.plugin.js",

			# DoNotTrack
			# https://github.com/rauenzi/BetterDiscordAddons/blob/master/Plugins/DoNotTrack/DoNotTrack.plugin.js
			"https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js",

			# FileViewer
			# https://github.com/TheGreenPig/BetterDiscordPlugins/blob/main/FileViewer/FileViewer.plugin.js
			"https://raw.githubusercontent.com/TheGreenPig/BetterDiscordPlugins/main/FileViewer/FileViewer.plugin.js",

			# ImageUtilities
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/ImageUtilities/ImageUtilities.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ImageUtilities/ImageUtilities.plugin.js",

			# NitroEmoteAndScreenShareBypass
			# https://github.com/oSumAtrIX/BetterDiscordPlugins/blob/master/NitroEmoteAndScreenShareBypass.plugin.js
			"https://raw.githubusercontent.com/oSumAtrIX/BetterDiscordPlugins/master/NitroEmoteAndScreenShareBypass.plugin.js",

			# NoSpotifyPause
			# https://github.com/bepvte/bd-addons/blob/main/plugins/NoSpotifyPause.plugin.js
			"https://raw.githubusercontent.com/bepvte/bd-addons/main/plugins/NoSpotifyPause.plugin.js",

			# PluginRepo
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/PluginRepo/PluginRepo.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js",

			# ReadAllNotificationsButton
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/ReadAllNotificationsButton/ReadAllNotificationsButton.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ReadAllNotificationsButton/ReadAllNotificationsButton.plugin.js",

			# SplitLargeMessages
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Plugins/SplitLargeMessages/SplitLargeMessages.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/SplitLargeMessages/SplitLargeMessages.plugin.js",

			# SpotifyControls
			# https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/SpotifyControls/SpotifyControls.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/SpotifyControls/SpotifyControls.plugin.js",

			# StaffTag
			# https://github.com/mwittrien/BetterDiscordAddons/tree/master/Plugins/StaffTag/StaffTag.plugin.js
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/StaffTag/StaffTag.plugin.js",

			# TypingIndicator
			# https://github.com/l0c4lh057/BetterDiscordStuff/blob/master/Plugins/TypingIndicator/TypingIndicator.plugin.js
			"https://raw.githubusercontent.com/l0c4lh057/BetterDiscordStuff/master/Plugins/TypingIndicator/TypingIndicator.plugin.js",

			# TypingUsersAvatars
			# https://github.com/QWERTxD/BetterDiscordPlugins/blob/main/TypingUsersAvatars/TypingUsersAvatars.plugin.js
			"https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/TypingUsersAvatars/TypingUsersAvatars.plugin.js",

			# ZeresPluginLibrary
			# https://github.com/rauenzi/BDPluginLibrary/blob/master/release/0PluginLibrary.plugin.js
			"https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js"
		)

		Write-Verbose -Message "Installing BetterDiscord plugins..." -Verbose

		foreach ($Plugin in $Plugins)
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message $(Split-Path -Path $Plugin -Leaf) -Verbose

			if ($(Split-Path -Path $Plugin -Leaf))
			{
				$Parameters = @{
					Uri             = $Plugin
					OutFile         = "$env:APPDATA\BetterDiscord\plugins\$(Split-Path -Path $Plugin -Leaf)"
					UseBasicParsing = $true
				}
			}
			Invoke-Webrequest @Parameters
		}
	}
	else
	{
		Write-Verbose -Message "BetterDiscord isn't installed" -Verbose
	}
}

function BetterDiscordThemes
{
	if (Test-Path -Path "$env:APPDATA\BetterDiscord\")
	{
		# Installing Better Discord themes
		$Themes = @(
			# EmojiReplace
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Themes/EmojiReplace/EmojiReplace.theme.css
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Themes/EmojiReplace/EmojiReplace.theme.css",

			# RadialStatus
			# https://github.com/DiscordStyles/RadialStatus/blob/deploy/RadialStatus.theme.css
			"https://raw.githubusercontent.com/DiscordStyles/RadialStatus/deploy/RadialStatus.theme.css",

			# SettingsModal
			# https://github.com/mwittrien/BetterDiscordAddons/blob/master/Themes/SettingsModal/SettingsModal.theme.css
			"https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Themes/SettingsModal/SettingsModal.theme.css"
		)

		Write-Verbose -Message "Installing BetterDiscord themes..." -Verbose

		foreach ($Theme in $Themes)
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message $(Split-Path -Path $Theme -Leaf) -Verbose

			if ($(Split-Path -Path $Theme -Leaf))
			{
				$Parameters = @{
					Uri             = $Theme
					OutFile         = "$env:APPDATA\BetterDiscord\themes\$(Split-Path -Path $Theme -Leaf)"
					UseBasicParsing = $true
				}
			}
			Invoke-Webrequest @Parameters
		}
	}
	else
	{
		Write-Verbose -Message "BetterDiscord isn't installed" -Verbose
	}
}

function Steam
{
	Write-Verbose -Message "Installing Steam..." -Verbose

	# Downloading the latest Steam
	# https://store.steampowered.com/about/
	$Parameters = @{
		Uri             = "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe"
		OutFile         = "$DownloadsFolder\SteamSetup.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\SteamSetup.exe" -ArgumentList "/S" -Wait

	# Configuring Steam
	if (Test-Path -Path "${env:ProgramFiles(x86)}\Steam")
	{
		if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam.lnk"))
		{
			Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
		}
		Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Steam" -Recurse -Force -ErrorAction Ignore
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Steam" -Recurse -Force -ErrorAction Ignore
		Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name Steam -Force -ErrorAction Ignore
	}

	if (Test-Path -Path "${env:ProgramFiles(x86)}\Steam\userdata\*")
	{
		foreach ($folder in @(Get-ChildItem -Path "${env:ProgramFiles(x86)}\Steam\userdata" -Force -Directory))
		{
			# Do not notify me about additions or changes to my games, new releases, and upcoming releases
			(Get-Content -Path "$($folder.FullName)\config\localconfig.vdf" -Encoding UTF8) | ForEach-Object -Process {
				$_ -replace "`"NotifyAvailableGames`"		`"1`"", "`"NotifyAvailableGames`"		`"0`""
			} | Set-Content -Path "$($folder.FullName)\config\localconfig.vdf" -Encoding UTF8 -Force
		}
	}
	else
	{
		Write-Verbose -Message "User folders doesn't exist" -Verbose
	}

	# Remove Steam from autostart
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name Steam -Force -ErrorAction Ignore

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Steam" -Direction Inbound -Program "${env:ProgramFiles(x86)}\Steam\steam.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Steam" -Direction Outbound -Program "${env:ProgramFiles(x86)}\Steam\steam.exe" -Action Allow
}

function GoogleChromeEnterprise
{
	Write-Verbose -Message "Installing Google Chrome Enterprise..." -Verbose

	# Downloading the latest Chrome Enterprise x64
	# https://chromeenterprise.google/browser/download
	$Parameters = @{
		Uri     = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
		OutFile = "$DownloadsFolder\googlechromestandaloneenterprise64.msi"
		Verbose = [switch]::Present
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\googlechromestandaloneenterprise64.msi" -ArgumentList "/passive"

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Google Chrome" -Direction Inbound -Program "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Google Chrome" -Direction Outbound -Program "$env:ProgramFiles\Google\Chrome\Application\chrome.exe" -Action Allow
}

function 7Zip
{
	Write-Verbose -Message "Installing 7-Zip..." -Verbose

	# Get the latest 7-Zip download URL
	$Parameters = @{
		Uri             = "https://sourceforge.net/projects/sevenzip/best_release.json"
		UseBasicParsing = $true
	}
	$best7ZipRelease = (Invoke-RestMethod @Parameters).platform_releases.windows.filename.replace("exe", "msi")

	# Downloading the latest 7-Zip x64
	# https://www.7-zip.org/download.html
	$Parameters = @{
		Uri             = "https://nchc.dl.sourceforge.net/project/sevenzip$($best7ZipRelease)"
		OutFile         = "$DownloadsFolder\7Zip.msi"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\7Zip.msi" -ArgumentList "/passive" -Wait

	# Configuring 7Zip
	if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip File Manager.lnk"))
	{
		Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip\7-Zip File Manager.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip" -Recurse -Force -ErrorAction Ignore
	}

	if (-not (Test-Path -Path HKCU:\SOFTWARE\7-Zip\Options))
	{
		New-Item -Path HKCU:\SOFTWARE\7-Zip\Options -Force
	}
	New-ItemProperty -Path HKCU:\SOFTWARE\7-Zip\Options -Name ContextMenu -PropertyType DWord -Value 4192 -Force
	New-ItemProperty -Path HKCU:\SOFTWARE\7-Zip\Options -Name MenuIcons -PropertyType DWord -Value 1 -Force
}

function CustomCursor
{
	# https://github.com/farag2/Utilities/blob/master/Download/Cursor/Install_Cursor.ps1
	Write-Verbose -Message "Installing custom cursor..." -Verbose

	# Installing custom cursor
	# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356
	$Parameters = @{
		Uri             = "https://github.com/farag2/Utilities/raw/master/Download/Cursor/dark.zip"
		OutFile         = "$DownloadsFolder\dark.zip"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	if (-not (Test-Path -Path "$env:SystemRoot\Cursors\Windows_11_dark_v2"))
	{
		New-Item -Path "$env:SystemRoot\Cursors\Windows_11_dark_v2" -ItemType Directory -Force
	}

	$Parameters = @{
		Path            = "$DownloadsFolder\dark.zip"
		DestinationPath = "$env:SystemRoot\Cursors\Windows_11_dark_v2"
		Force           = $true
	}
	Expand-Archive @Parameters

	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "(default)" -PropertyType String -Value "Windows 11 Cursors Dark v2 by Jepri Creations" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name AppStarting -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\working.ani" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Arrow -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\pointer.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name ContactVisualization -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Crosshair -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\precision.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name CursorBaseSize -PropertyType DWord -Value 32 -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name GestureVisualization -PropertyType DWord -Value 31 -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Hand -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\link.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Help -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\help.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name IBeam -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\beam.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name No -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\unavailable.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name NWPen -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\handwriting.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Person -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\pin.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Pin -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\person.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name precisionhair -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\precision.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "Scheme Source" -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeAll -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\move.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNESW -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\dgn2.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNS -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\vert.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNWSE -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\dgn1.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeWE -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\horz.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name UpArrow -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\alternate.cur" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Wait -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\busy.ani" -Force

	if (-not (Test-Path -Path "HKCU:\Control Panel\Cursors\Schemes"))
	{
		New-Item -Path "HKCU:\Control Panel\Cursors\Schemes" -Force
	}
	New-ItemProperty -Path "HKCU:\Control Panel\Cursors\Schemes" -Name "Windows 11 Cursors Dark v2 by Jepri Creations" -PropertyType ExpandString -Value "%SYSTEMROOT%\Cursors\Windows_11_dark_v2\pointer.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\help.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\working.ani,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\busy.ani,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\precision.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\beam.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\handwriting.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\unavailable.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\vert.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\horz.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\dgn1.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\dgn2.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\move.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\alternate.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\link.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\person.cur,%SYSTEMROOT%\Cursors\Windows_11_dark_v2\pin.cur" -Force

	# Reload custom cursor on-the-fly
	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "SystemParamInfo"
		Language         = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
"@
	}
	if (-not ("WinAPI.SystemParamInfo" -as [type]))
	{
		Add-Type @Signature
	}
	[WinAPI.SystemParamInfo]::SystemParametersInfo(0x0057, 0, $null, 0)
}

function Notepad
{
	Write-Verbose -Message "Installing Notepad++..." -Verbose

	# Get the latest Notepad++
	# https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest
	$Parameters = @{
		Uri             = "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest"
		UseBasicParsing = $true
	}
	$LatestNotepadPlusPlusTag = (Invoke-RestMethod @Parameters).tag_name | Select-Object -Index 0
	$LatestNotepadPlusPlusVersion = (Invoke-RestMethod @Parameters).tag_name.replace("v", "") | Select-Object -Index 0

	# Downloading the latest Notepad++
	# https://github.com/notepad-plus-plus/notepad-plus-plus/releases/latest
	$Parameters = @{
		Uri             = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/$($LatestNotepadPlusPlusTag)/npp.$($LatestNotepadPlusPlusVersion).Installer.x64.exe"
		OutFile         = "$DownloadsFolder\NotepadPlusPlusSetup.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\NotepadPlusPlusSetup.exe" -ArgumentList "/S" -Wait

	Write-Warning -Message "Close 'Notepad++' window manually"
	
	Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe" -Wait

	# Configuring Notepad++
	if (Test-Path -Path "$env:ProgramFiles\Notepad++")
	{
		if (-not (Test-Path -Path "$env:APPDATA\Notepad++\config.xml"))
		{
			Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe"
			Write-Verbose -Message "`"$env:ProgramFiles\Notepad++\notepad++.exe`" doesn't exist. Re-run the script" -Verbose
			break
		}
		Stop-Process -Name notepad++ -Force -ErrorAction Ignore
		$Remove = @(
			"$env:ProgramFiles\Notepad++\change.log",
			"$env:ProgramFiles\Notepad++\LICENSE",
			"$env:ProgramFiles\Notepad++\readme.txt",
			"$env:ProgramFiles\Notepad++\autoCompletion",
			"$env:ProgramFiles\Notepad++\plugins"
			"$env:ProgramFiles\Notepad++\autoCompletion"
		)
		Remove-Item -Path $Remove -Recurse -Force -ErrorAction Ignore
		Remove-Item -Path "$env:ProgramFiles\Notepad++\localization" -Exclude russian.xml -Recurse -Force -ErrorAction Ignore
		if ((Get-WinSystemLocale).Name -eq "ru-RU")
		{
			if ($Host.Version.Major -eq 5)
			{
				New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\CLSID\{B298D29A-A6ED-11DE-BA8C-A68E55D89593}\Settings" -Name Title -PropertyType String -Value "?????????????? ?? ?????????????? &Notepad++" -Force
			}
		}
		New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" -Name "C:\Program Files\Notepad++\notepad++.exe.FriendlyAppName" -PropertyType String -Value "Notepad++" -Force
		cmd.exe --% /c ftype txtfile=%ProgramFiles%\Notepad++\notepad++.exe "%1"
		cmd.exe --% /c assoc .cfg=txtfile
		cmd.exe --% /c assoc .ini=txtfile
		cmd.exe --% /c assoc .log=txtfile
		cmd.exe --% /c assoc .nfo=txtfile
		cmd.exe --% /c assoc .ps1=txtfile
		cmd.exe --% /c assoc .xml=txtfile
		cmd.exe --% /c assoc txtfile\DefaultIcon=%ProgramFiles%\Notepad++\notepad++.exe,0

		# It is needed to use -Wait to make Notepad++ apply written settings
		Write-Warning -Message "Close 'Notepad++' window manually"

		Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe" -ArgumentList "$env:APPDATA\Notepad++\config.xml" -Wait

		[xml]$config = Get-Content -Path "$env:APPDATA\Notepad++\config.xml" -Force
		# Fluent UI: large
		$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "ToolBar"} | ForEach-Object -Process {$_."#text" = "large"}
		# Mute all sounds
		$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "MISC"} | ForEach-Object -Process {$_.muteSounds = "yes"}
		# Show White Space and TAB
		$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "ScintillaPrimaryView"} | ForEach-Object -Process {$_.whiteSpaceShow = "show"}
		# 2 find buttons mode
		$config.NotepadPlus.FindHistory | ForEach-Object -Process {$_.isSearch2ButtonsMode = "yes"}
		# Wrap around
		$config.NotepadPlus.FindHistory | ForEach-Object -Process {$_.wrap = "yes"}
		# Disable creating backups
		$config.NotepadPlus.GUIConfigs.GUIConfig | Where-Object -FilterScript {$_.name -eq "Backup"} | ForEach-Object -Process {$_.action = "0"}
		$config.Save("$env:APPDATA\Notepad++\config.xml")

		Start-Process -FilePath "$env:ProgramFiles\Notepad++\notepad++.exe" -ArgumentList "$env:APPDATA\Notepad++\config.xml" -Wait

		Start-Sleep -Seconds 1

		Stop-Process -Name notepad++ -ErrorAction Ignore
	}
}

function GitHubDesktop
{
	Write-Verbose -Message "Installing GitHub Desktop..." -Verbose

	# Downloading the latest GitHub Desktop
	# https://desktop.github.com/
	$Parameters = @{
		Uri             = "https://central.github.com/deployments/desktop/desktop/latest/win32?format=msi"
		OutFile         = "$DownloadsFolder\GitHubDesktop.msi"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\GitHubDesktop.msi" -ArgumentList "/passive"
}

function VSCode
{
	Write-Verbose -Message "Installing Visual Stutio Code..." -Verbose

	# Downloading the latest Visual Stutio Code
	# https://code.visualstudio.com/download
	$Parameters = @{
		Uri             = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
		OutFile         = "$DownloadsFolder\VisualStutioCodeSetup.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Write-Warning -Message "Close 'Visual Studio Code' window manually after installation"

	Start-Process -FilePath "$DownloadsFolder\VisualStutioCodeSetup.exe" -ArgumentList "/silent"
}

function TeamSpeak
{
	Write-Verbose -Message "Installing TeamSpeak 3..." -Verbose

	# Downloading the latest TeamSpeak 3 x64
	# https://www.teamspeak.com/en/downloads/
	$Parameters = @{
		Uri             = "https://files.teamspeak-services.com/releases/client/3.5.6/TeamSpeak3-Client-win64-3.5.6.exe"
		OutFile         = "$DownloadsFolder\TeamSpeakSetup.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\TeamSpeakSetup.exe" -ArgumentList "/S"

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "TeamSpeak 3" -Direction Inbound -Program "$env:ProgramFiles\TeamSpeak 3 Client\ts3client_win64.exe" -Action Allow
	New-NetFirewallRule -DisplayName "TeamSpeak 3" -Direction Outbound -Program "$env:ProgramFiles\TeamSpeak 3 Client\ts3client_win64.exe" -Action Allow
}

function qBittorent
{
	Write-Verbose -Message "Installing qBittorrent..." -Verbose

	# Get the latest qBittorrent x64
	$Parameters = @{
		Uri             = "https://sourceforge.net/projects/qbittorrent/best_release.json"
		UseBasicParsing = $true
	}
	$bestqBittorrentRelease = (Invoke-RestMethod @Parameters).platform_releases.windows.filename

	# Downloading the latest approved by maintainer qBittorrent x64
	# For example 4.4.3 e.g., not 4.4.3.1 
	$Parameters = @{
		Uri             = "https://nchc.dl.sourceforge.net/project/qbittorrent$($bestqBittorrentRelease)"
		OutFile         = "$DownloadsFolder\qBittorrentSetup.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\qBittorrentSetup.exe" -ArgumentList "/S" -Wait

	# Configuring qBittorrent
	if (Test-Path -Path "$env:ProgramFiles\qBittorrent")
	{
		Stop-Process -Name qBittorrent -Force -ErrorAction Ignore
		if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent.lnk"))
		{
			Copy-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent\qBittorrent.lnk" -Destination "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Force
		}
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent" -Recurse -Force -ErrorAction Ignore
		Remove-Item -Path "$env:ProgramFiles\qBittorrent\translations" -Exclude qt_ru.qm, qtbase_ru.qm -Recurse -Force -ErrorAction Ignore

		if (-not (Test-Path -Path "$env:APPDATA\qBittorrent\"))
		{
			New-Item -Path "$env:APPDATA\qBittorrent\" -ItemType Directory -Force
		}
		# Installing the settings file
		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/farag2/Utilities/master/qBittorrent/qBittorrent.ini"
			OutFile         = "$env:APPDATA\qBittorrent\qBittorrent.ini"
			UseBasicParsing = $true
		}
		Invoke-WebRequest @Parameters
		
		# Get the latest qBittorrent dark theme version
		$Parameters = @{
			Uri             = "https://api.github.com/repos/jagannatharjun/qbt-theme/releases/latest"
			UseBasicParsing = $true
		}
		$LatestqBittorrentThemeVersion = (Invoke-RestMethod @Parameters).assets.browser_download_url

		# Installing dark theme
		$Parameters = @{
			Uri     = $LatestqBittorrentThemeVersion
			OutFile = "$DownloadsFolder\qbt-theme.zip"
			Verbose = $true
		}
		Invoke-WebRequest @Parameters
		<#
			.SYNOPSIS
			Expand the specific file from ZIP archive. Folder structure will be created recursively

			.Parameter Source
			The source ZIP archive

			.Parameter Destination
			Where to expand file

			.Parameter File
			Assign the file to expand

			.Example
			ExtractZIPFile -Source "D:\Folder\File.zip" -Destination "D:\Folder" -File "Folder1/Folder2/File.txt"
		#>
		function ExtractZIPFile
		{
			[CmdletBinding()]
			param
			(
				[string]
				$Source,

				[string]
				$Destination,

				[string]
				$File
			)

			Add-Type -Assembly System.IO.Compression.FileSystem
			$ZIP = [IO.Compression.ZipFile]::OpenRead($Source)
			$Entries = $ZIP.Entries | Where-Object -FilterScript {$_.FullName -eq $File}
			$Destination = "$Destination\$(Split-Path -Path $File -Parent)"
			if (-not (Test-Path -Path $Destination))
			{
				New-Item -Path $Destination -ItemType Directory -Force
			}
			$Entries | ForEach-Object -Process {[IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$($Destination)\$($_.Name)", $true)}
			$ZIP.Dispose()
		}
		$Parameters = @{
			Source      = "$DownloadsFolder\qbt-theme.zip"
			Destination = "$env:APPDATA\qBittorrent"
			File        = "darkstylesheet.qbtheme"
		}
		ExtractZIPFile @Parameters

		# Enable dark theme
		$qbtheme = (Resolve-Path -Path "$env:APPDATA\qBittorrent\darkstylesheet.qbtheme").Path.Replace("\", "/")

		# Save qBittorrent.ini in UTF8-BOM encoding to make it work with non-latin usernames
		(Get-Content -Path "$env:APPDATA\qBittorrent\qBittorrent.ini" -Encoding UTF8) -replace "General\\CustomUIThemePath=", "General\CustomUIThemePath=$qbtheme" | Set-Content -Path "$env:APPDATA\qBittorrent\qBittorrent.ini" -Encoding UTF8 -Force

		# Adding to the Windows Defender Firewall exclusion list
		New-NetFirewallRule -DisplayName "qBittorent" -Direction Inbound -Program "$env:ProgramFiles\qBittorrent\qbittorrent.exe" -Action Allow
		New-NetFirewallRule -DisplayName "qBittorent" -Direction Outbound -Program "$env:ProgramFiles\qBittorrent\qbittorrent.exe" -Action Allow
	}
}

function Office
{
	Write-Verbose -Message "Installing Office..." -Verbose

	# Downloading the latest Office
	$Path = Join-Path -Path $PSScriptRoot -ChildPath "..\Office" -Resolve
	wt --window 0 new-tab --title Office --startingDirectory $Path powershell -Command "& {.\Download.ps1}"

	# Configuring Office
	if (Test-Path -Path "$env:ProgramFiles\Microsoft Office\root")
	{
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office Tools" -Recurse -Force -ErrorAction Ignore
	}
}

function AdobeCreativeCloud
{
	Write-Verbose -Message "Installing Adobe Creative Cloud..." -Verbose

	# Downloading the latest Adobe Creative Cloud
	# https://creativecloud.adobe.com/en/apps/download/creative-cloud
	$Parameters = @{
		Uri             = "https://prod-rel-ffc-ccm.oobesaas.adobe.com/adobe-ffc-external/core/v1/wam/download?sapCode=KCCC&productName=Creative%20Cloud&os=win"
		OutFile         = "$DownloadsFolder\CreativeCloudSetUp.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\CreativeCloudSetUp.exe" -ArgumentList "SILENT"
}

function Java8
{
	Write-Verbose -Message "Installing latest Java 8(JRE) x64..." -Verbose

	# Downloading the latest Java 8(JRE) x64
	# https://www.java.com/en/download/
	$Parameters = @{
		Uri             = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=247106_10e8cce67c7843478f41411b7003171c"
		OutFile         = "$DownloadsFolder\Java 8(JRE) for Windows x64.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\Java 8(JRE) for Windows x64.exe" -ArgumentList "INSTALL_SILENT=1"

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Java 8(JRE)" -Direction Inbound -Program "${env:ProgramFiles(x86)}\Java\jre1.8.0_351\bin\javaw.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Java 8(JRE)" -Direction Outbound -Program "${env:ProgramFiles(x86)}\Java\jre1.8.0_351\bin\java.exe" -Action Allow
}

function Java19
{
	Write-Verbose -Message "Installing latest Java 19(JDK) x64..." -Verbose

	# Downloading the latest Java 19(JDK) x64
	# https://www.oracle.com/java/technologies/downloads/#jdk19-windows
	$Parameters = @{
		Uri             = "https://download.oracle.com/java/19/latest/jdk-19_windows-x64_bin.msi"
		OutFile         = "$DownloadsFolder\Java 19(JDK) for Windows x64.msi"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\Java 19(JDK) for Windows x64.msi" -ArgumentList "/passive" -Wait

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Java 19(JDK)" -Direction Inbound -Program "$env:ProgramFiles\Java\jdk-19\bin\javaw.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Java 19(JDK)" -Direction Outbound -Program "$env:ProgramFiles\Java\jdk-19\bin\java.exe" -Action Allow

	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Java" -Force -Recurse -ErrorAction Ignore
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Java Development Kit" -Force -Recurse -ErrorAction Ignore
}

function WireGuard
{
	Write-Verbose -Message "Installing WireGuard..." -Verbose

	# Downloading the latest WireGuard
	# https://www.wireguard.com/install/
	$Parameters = @{
		Uri             = "https://download.wireguard.com/windows-client/wireguard-installer.exe"
		OutFile         = "$DownloadsFolder\WireGuardInstaller.exe"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	Start-Process -FilePath "$DownloadsFolder\WireGuardInstaller.exe" -Wait

	Stop-Process -Name WireGuard -Force -ErrorAction Ignore

	# Adding to the Windows Defender Firewall exclusion list
	New-NetFirewallRule -DisplayName "Wire Guard" -Direction Inbound -Program "$env:ProgramFiles\WireGuard\wireguard.exe" -Action Allow
	New-NetFirewallRule -DisplayName "Wire Guard" -Direction Outbound -Program "$env:ProgramFiles\WireGuard\wireguard.exe" -Action Allow
}

function DeleteInstallationFiles
# Remove Installation Files and shortcuts from Desktop
{
	Remove-Item -Path "$DownloadsFolder\TelegramSetup.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$DesktopFolder\Telegram.lnk" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\DiscordSetup.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$env:USERPROFILE\Desktop\Discord.lnk" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\BetterDiscordSetup.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\SteamSetup.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$env:PUBLIC\Desktop\Steam.lnk" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\googlechromestandaloneenterprise64.msi" -Force -ErrorAction Ignore
	Remove-Item -Path "$env:PUBLIC\Desktop\Google Chrome.lnk" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\7Zip.msi" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\dark.zip" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\NotepadPlusPlusSetup.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\GitHubDesktop.msi" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\VisualStutioCodeSetup.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\TeamSpeakSetup.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$env:PUBLIC\Desktop\TeamSpeak 3 Client.lnk" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\qBittorrentSetup.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\qbt-theme.zip" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\CreativeCloudSetUp.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$env:PUBLIC\Desktop\Adobe Creative Cloud.lnk" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\Java 8(JRE) for Windows x64.exe" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\Java 19(JDK) for Windows x64.msi" -Force -ErrorAction Ignore
	Remove-Item -Path "$DownloadsFolder\WireGuardInstaller.exe" -Force -ErrorAction Ignore
}

function SophiaScript
{
	Write-Verbose -Message "Starting Sophia Script..." -Verbose

	# Downloading the latest Sophia Script
	# https://github.com/farag2/Sophia-Script-for-Windows
	Invoke-WebRequest -Uri script.sophi.app -UseBasicParsing | Invoke-Expression

	Start-Process -FilePath powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoProfile -NoLogo -File `"$DownloadsFolder\Sophia Script for Windows *\Sophia.ps1`"" -Verb Runas -Wait

	Remove-Item -Path "$DownloadsFolder\Sophia Script for Windows *" -Recurse -Force -ErrorAction Ignore
}
