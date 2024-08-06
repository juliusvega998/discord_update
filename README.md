# Discord Cron Updater
Contains a bash script to automatically update your discord on boot on linux

## Installation
Clone this repository:
```
$ git clone https://github.com/juliusvega998/discord_update.git
```
Add the bash script to cron tab. Click (here)[https://www.linode.com/docs/guides/run-jobs-or-scripts-using-crontab-on-boot/#use-crontab-to-schedule-a-job-or-script-to-run-at-system-startup] if you want a more hands-on tutorial on crontab.
```
@reboot /path/to/discord_update/discord_update.sh > /path/to/discord_update/discord_update.log 2>&1
```
Done! The script now checks on every boot if there is an update and installs it.

## Disclaimer
This repository was created only for my personal use. Feel free to fork if you want to modify it. I will only maintain this repository as long as I use this.
