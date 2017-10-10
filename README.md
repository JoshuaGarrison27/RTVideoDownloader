# Rooster Teeth Video Downloader

## Important Notice
This script will get you started but it will give you a semi-broken video. However, I provide you with instructions on how to repair the video so that you have a fully working video.

## Disclaimer
I reached out to Rooster Teeth about a year ago to get their permission to post this. However, I was unsuccessful at getting a response. If someone from the RT team reaches out to me and asks me to remove it, I will happily comply after a short discussion of why. :)

Also, I am not responsible for what you do with the tool. RT First subscriptions are reasonably priced. You should not abuse this tool or I will remove it if I catch wind of anyone using for evil purposes. This is meant only to help people who may want take some sweet sweet RT goodness on the road or travel with them or in the dark and lonely nights when the internet is down...we will pray for those people.

## Getting started

### Part 1

1. Download the tools here (Duh!)
2. Unzip the tools (if you didnt clone using git)
3. Open the `RT-Vid-Downloader.ps1` file using a editor like Powershell (IDE). Any text editor will work though.
4. Locate the line near the end that starts with `DownloadRT-File ...`. It will be followed with a URL and a file name. This it the path to the videos location and the second is what YOU want the video to be named on your machine.
5. Next, open a web browser and navigate to a RT video that you want to download. Let it start playing...
6. Open the developer tools on your browser. This done normally by hitting F12. Look at the network tab and start capturing packets.
7. You should see a few of them coming in where the name starts with `NewHLS-` followed by the video quality and then a sequence number.
8. You need to get the URL of one of these and then trim off the end of the url that has the sequence number and `.ts` file extension.
9. Using that URL, plug that into the URL line of the .ps1 file from step 3 and 4.
10. Give it an appropriate name that you like in the second parameter.
11. Execute the powershell script and watch it download!

### Part 2

You may notice that video plays just fine when it is finished downloading. However, you will eventually learn that it isnt perfect. Espectially if you want to skip forward or go back. In VLC it tends to lead to crashing. So here is how to "repair" the video.

1. Download the [FFmpeg Tools](https://www.ffmpeg.org/)
2. Copy your new downloaded video into the `./bin/` folder of the FFmpef tools folder.
3. Open a command line and navigate to the bin folder.
4. Execute a command like this... `ffmpeg -i MyDownloadedRTVideo.mp4 -c copy MyFixedRTVideo.mp4` (The second name can be whatever you want.)
5. Now your video will be repaired and work as expected.

The FFmpeg tools just repairs the video index and does a better job of stitching things together than the basic binary concatenation that my script does. Only reason I dont include it in the download is because of licensing.

## Known Issues
On some older videos, this script does not work and has to be slightly modified. I have a copy that does support older videos that do not follow this current format. If there is enough interest, I will release that as well. Just wanted to minimize any confusion.

## Licenses
See the license in the repository