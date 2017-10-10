function DownloadRT-File (
    [parameter(Position=0,Mandatory=$true)]
    [string] $VidPathPreURL,
    [parameter(Position=1,Mandatory=$true)]
    [string] $RequestedFileName
)
{
Write-Host " "
$VideoFileName = "$PSScriptRoot\$RequestedFileName"
$SegmentTmp = "$PSScriptRoot\SegmentVideo.mp4"
$MergedTmpFile = "$PSScriptRoot\MergedVideo.tmp"
$GlobalCount = 0

#Set up headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("X-Requested-With","ShockwaveFlash/22.0.0.192")

#See if the file exists - Terminate if it does.
if (Test-Path $VideoFileName) {
    Write-Warning "$VideoFileName already exists!"
    Exit
}

#Create the new video file
New-Item -ItemType file "$VideoFileName" | Out-Null

#Loop though the downloads and begin merging
try{
    foreach($VidCount in 0..9999)
    {
        $VidCountPadded = $VidCount.ToString("00000")
        Write-Host "File Part $VidCount - Begin Download"
        #Download file into a temp file
        Invoke-WebRequest -Uri "$VidPathPreURL$VidCountPadded.ts" -Method Get -Headers $headers -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer) -OutFile $SegmentTmp
        #Append that tmp onto the final video and call that a temp for now
        Write-Host "File Part $VidCount - Starting Merge"

        Join-File $VideoFileName,$SegmentTmp $MergedTmpFile

        #Delete the file that is one segment behind
        Write-Host "File Part $VidCount - Cleaning Up"
        Remove-Item $VideoFileName
        Start-Sleep -Milliseconds 400
        #Rename the temp file as the new latest video
        Rename-Item $MergedTmpFile $VideoFileName
        Write-Host "File Part $VidCount - Complete"
        #Sleep for 1 second to prevent file lock errors
        Start-Sleep -Milliseconds 500
        $GlobalCount++
    }
} catch {
    If($_.Exception.Response.StatusCode.Value__ -eq "404" -and $GlobalCount -gt 0)
    {
        Write-Host " "
        Write-Host "***********************************************************************"
        Write-Host " All files are finished downloading for $RequestedFileName             "
        Write-Host "***********************************************************************"
    } Else {
        $_.Exception.Message
    }
    #Remove Temp File
    Remove-Item $SegmentTmp
}
}



function Join-File (
    [parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
    [string[]] $Path,
    [parameter(Position=1,Mandatory=$true)]
    [string] $Destination
)
{
    write-verbose "Join-File: Open Destination1 $Destination"
    $OutFile = [System.IO.File]::Create($Destination)
    foreach ( $File in $Path ) {
        write-verbose "   Join-File: Open Source $File"
        $InFile = [System.IO.File]::OpenRead($File)
        $InFile.CopyTo($OutFile)
        $InFile.Dispose()
    }
    $OutFile.Dispose()
    write-verbose "Join-File: finished"
}

DownloadRT-File "http://wpc.1765a.taucdn.net/801765A/video/uploads/videos/14ab8633-2e6d-4616-b92c-49c5526fc0ec/NewHLS-1080P" "RWBY-Vol5-Trailer.mp4"