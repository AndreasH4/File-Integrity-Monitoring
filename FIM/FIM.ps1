


#----------
#variables
#----------
$global:displayWidth = 107
$global:displayHeight = 52


$baselinePath = ".\Baseline.txt"
$TitlePath = ".\ASCII_Images\Title.txt"
$MenuPath = ".\ASCII_Images\Menu.txt"
$CollectBaselinePath = ".\ASCII_Images\CollectBaseline.txt"
$MonitoringPath = ".\ASCII_Images\Monitoring.txt"
$LoadingPath = ".\ASCII_Images\Loading.txt"

#Progress Bar
[int]$xPosition = 10
[int]$yPosition = 10

[string]$load = "8888"
[Array]$loadChar = $load.ToCharArray()
[int]$loadLength = $loadChar.Count
[string]$progressBar = "itG8888............................................ii"
[Array]$progressBarChar = $progressBar.ToCharArray()
[int]$progressBarLength = $progressBarChar.Count

[Array]$static = $progressBarChar[0..6]
[int]$staticLength = $static.Count
[int]$xPosi = $xPosition + $staticLength
[string]$load2 = "@@@@"

[double]$loadTime = 0.8
[double]$loadTimeDecrease = 0.85
[double]$loadTimeIncrease = 7

#---------
#Functions
#---------

#Progress Bar

function Move-Cursor([int]$x, [int] $y) {
  $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $x , $y
}

function Draw-Character() {
  Clear-Host


  Load-txt $LoadingPath
  
  Move-Cursor $xPosition ($yPosition - 1)
  Write-Host " ,:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::, "
  Move-Cursor $xPosition $yPosition
  Write-Host "itG8888............................................ii"
  Move-Cursor $xPosition ($yPosition + 1)
  Write-Host "1t0@@@@                                            i1"
  Move-Cursor $xPosition ($yPosition + 2)
  Write-Host " ;;iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii;;; "


  Drawing

}



function Drawing() {
  

  while ($xPosi -gt $staticLength -and $xPosi -lt ($progressBarLength + ( 2 * $loadLength))) {
    Start-Sleep -Seconds $loadTime
    Move-Cursor $xPosi ($yPosition + 1)
    Write-Host $load2
    Move-Cursor $xPosi $yPosition
    Write-Host $load
    
    
    if ($xPosi -ge 46 -and $xPosi -lt 50) {
      $loadTime = $loadTime * $loadTimeIncrease
    }

    $loadTime = $loadTime * $loadTimeDecrease
    $xPosi = $xPosi + $loadLength
  }

  Start-Sleep -Seconds ($loadTime)

  Menu-Screen
  
}


# /Progress Bar

function Setup-Display([int]$width, [int] $height) {
  $psHost = Get-Host
  $window = $psHost.ui.rawui
  $newSize = $window.windowsize
  $newSize.height = $height
  $newSize.width = $width
  $window.windowsize = $newSize
}

function Calculate-File-Hash($filepath) {
  $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
  return $filehash
}

function Load-txt([string]$txt) {
  return Get-Content $txt
}

function Read-NextKey() {
  return $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
}

function Title-Screen() {
  #Clear any pre existing key presses
  $host.UI.RawUI.FlushInputBuffer()
  
  Clear-Host
  
  Load-txt $TitlePath
  
  Write-Host ""
  Write-Host "              Press Any Key to Start"

  $continue = Read-NextKey

  if ($continue) {
    Draw-Character
  }

}

function Menu-Screen() {
  Clear-Host
  
  Load-txt $MenuPath

  Write-Host "      What would you like to do?"
  Write-Host ""
  Write-Host "      A) Collect new Baseline"
  Write-Host "      B) Quit"
  Write-Host ""

  do {
    $userResponse = Read-Host -Prompt "      Answer (A or B)"
  } while ($userResponse -notlike "A" -and $userResponse -notlike "B")

  Write-Host ""

  Switch ($userResponse) {
    "A" { Collect-Baseline }
    "B" { $host.Exit }
  }
}


function Collect-Baseline() {
  Clear-Host
  
  Load-txt $CollectBaselinePath
  
  Write-Host ""
  Write-Host "      Collecting..."

  #No old content
  Clear-Content $baselinePath

  $files = Get-ChildItem -Path .\Files

  foreach ($f in $files) {
    $hash = Calculate-File-Hash $f.FullName
    "$($hash.Path)|$($hash.Hash)" | Add-Content -Path $baselinePath
  }


  Write-Host ""
  Write-Host "      Press any key to move on"
  $continue = Read-NextKey

  if ($continue) {
    Collect-BaselineEnd
  }
}

function Collect-BaselineEnd() {
  Start-Sleep -Seconds 1
  
  Clear-Host
  
  Load-txt $CollectBaselinePath
  
  
  Write-Host ""
  Write-Host "      What would you like to do?"
  Write-Host ""
  Write-Host "      A) Monitoring files"
  Write-Host "      B) Menu"
  Write-Host ""

  do {
    $userResponse = Read-Host -Prompt "      Answer (A or B)"
  } while ($userResponse -notlike "A" -and $userResponse -notlike "B")

  Write-Host ""

  Switch ($userResponse) {
    "A" { Monitoring-Files }
    "B" { Menu-Screen }
  }
}

function Read-Character() {
  if ($host.UI.RawUI.KeyAvailable) {
    return $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
  }

  return $null
}

Function timer () {
  Start-Sleep -Seconds 1
  Clear-Host

  Load-txt $MonitoringPath
  
  Write-Host ""

  [double]$minutes = Read-Host -Prompt "      Enter minutes"
  [double]$secondsDouble = $minutes * 60
  [int]$seconds = [math]::Round($secondsDouble)
  

  Write-Host ""
  Write-Host "      Press Q to interrupt"



  for ($counter = 1; $counter -le $seconds; $counter++) {
    search

    $interrupt = Read-Character

    if ($interrupt -like "Q") {
      $counter = $seconds
    }
    else {
      Start-Sleep -Seconds 1
      Write-Host "      Monitoring..."
    }
  }

  Write-Host ""
  Write-Host "      Press any key to move on"
  $continue = Read-NextKey

  if ($continue) {
    MonitoringEnd
  }
}

function once () {

  Start-Sleep -Seconds 1

  Clear-Host

  Load-txt $MonitoringPath

  Write-Host ""
  Write-Host "      Monitoring..."

  search

  Write-Host ""
  Write-Host "      Press any key to move on"
  $continue = Read-NextKey

  if ($continue) {
    MonitoringEnd
  }
}


function MonitoringTime() {

  Write-Host ""
  Write-Host "      What would you like to do?"
  Write-Host ""
  Write-Host "      A) Monitoring once"
  Write-Host "      B) Monitoring certain time"
  Write-Host ""


  do {
    $userResponse = Read-Host -Prompt "      Answer (A or B)"
  } while ($userResponse -notlike "A" -and $userResponse -notlike "B")

  Switch ($userResponse) {
    "A" { once }
    "B" { timer }
  }
}

function Monitoring-Files() {
  Start-Sleep -Seconds 1
  Clear-Host

  Load-txt $MonitoringPath


  $fileHashDictionary = @{}
  $filePathsAndHashes = Get-Content -Path $baselinePath
  
  foreach ($f in $filePathsAndHashes) {
    ##$f.Split("|")[0] ist key
    ##$f.Split("|")[1] ist value
    $fileHashDictionary.add($f.Split("|")[0], $f.Split("|")[1])
  }

  MonitoringTime

}


function search() {

  ##Get all files
  $files = Get-ChildItem -Path .\Files
  
  
  foreach ($f in $files) {
    $hash = Calculate-File-Hash $f.FullName
    
    # Notify if a new file has been created
    if ($fileHashDictionary[$hash.Path] -eq $null) {
      # A new file has been created!
      Write-Host "      $($hash.Path) has been created!" -ForegroundColor Green
    }      
    # Notify if a new file has been changed
    elseif ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
      # The file has not changed
    }
    else {
      # File has been compromised!
      Write-Host "      $($hash.Path) has changed!" -ForegroundColor Yellow
    }
  

  }
    
  foreach ($key in $fileHashDictionary.Keys) {
    $baselineFileStillExists = Test-Path -Path $key
    if (-Not $baselineFileStillExists) {
      # One of the baseline files must have been deleted, notify the user
      Write-Host "      $($key) has been deleted!" -ForegroundColor Red
    }
  }
}


function MonitoringEnd {
  Start-Sleep -Seconds 1
  
  Clear-Host

  Load-txt $MonitoringPath
    
  Write-Host ""
  Write-Host "      What would you like to do?"
  Write-Host ""
  Write-Host "      A) Monitoring again"
  Write-Host "      B) Menu"
  Write-Host ""

  
  do {
    $userResponse = Read-Host -Prompt "      Answer (A or B)"
  } while ($userResponse -notlike "A" -and $userResponse -notlike "B")
  
  Switch ($userResponse) {
    "A" { Monitoring-Files }
    "B" { Menu-Screen }
  }
}






#-----
#Main
#-----

Setup-Display $global:displayWidth $global:displayHeight

Title-Screen

