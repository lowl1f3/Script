<div align="right">
  This page also in:
  <a title="Русский" href="README_ru-ru.md"><img src="https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg" height="11px"/></a>
  <a title="Українська" href="README_uk-ua.md"><img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/></a>
</div>

## About script

A PowerShell script for Windows that automates installation and configuration of programs

Supports `Windows 10` & `Windows 11`

## Donations

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lowlife)

## How to use

* <a href="https://github.com/lowl1f3/Script/archive/refs/heads/main.zip"><img src="https://img.shields.io/badge/Download-%20ZIP-green&?style=for-the-badge"/></a>
* Expand the archive;
* Open folder with the expanded archive;
* On `Windows 10` click `File` in File Explorer, hover over `Open Windows PowerShell`, and select `Open Windows PowerShell as Administrator` [(how-to with screenshots)](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/);
* On `Windows 11` right-click on the <kbd>Windows</kbd> icon and select `Windows Terminal (Admin)`;
* Then change the current location

  ```powershell
  Set-Location -Path "Path\To\Script\Folder"
  ```

* Set execution policy to be able to run scripts only in the current PowerShell session

  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
  ```

* Type `.\Script.ps1` <kbd>Enter</kbd> to run the script.

## Programs

> **Note**: Some of them have a silent installation

<details>
	<summary>List</summary>

* [Telegram](https://desktop.telegram.org)
* [Discord](https://discord.com/download)
  * [Better Discord](https://betterdiscord.app), [plugins](https://github.com/lowl1f3/Script/blob/main/src/Module/Source.psm1#L130) & [themes](https://github.com/lowl1f3/Script/blob/main/src/Module/Source.psm1#L237)
* [Steam](https://store.steampowered.com/about)
* [Chrome Enterprise](https://chromeenterprise.google/browser/download/#windows-tab)
* [7-Zip](https://www.7-zip.org/download.html) archiver
* [Custom](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) cursor
* [Notepad++](https://notepad-plus-plus.org/downloads)
* [GitHub Desktop](https://desktop.github.com)
* [Visual Stutio Code](https://code.visualstudio.com/Download)
* [Teamspeak 3](https://teamspeak.com/en/downloads)
* [qBittorrent](https://www.qbittorrent.org/download.php)
* [Customizable](https://github.com/farag2/Office) Microsoft Office
  * Word, Excel, PowerPoint, Outlook, Teams, OneDrive
* [Adobe Creative Cloud](https://creativecloud.adobe.com/en/apps/download/creative-cloud)
* [Java 8](https://www.java.com/en/download)(JRE) & [Java 19](https://www.oracle.com/java/technologies/downloads/#jdk19-windows)(JDK)
* [WireGuard](https://www.wireguard.com/install)
* [Sophia Script](https://github.com/farag2/Sophia-Script-for-Windows)
  * [System requirements](https://github.com/farag2/Sophia-Script-for-Windows#system-requirements)
</details>

## Links

* [Telegram](https://t.me/lowlif3)
* [Discord](https://discord.com/users/330825971835863042)
