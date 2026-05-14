# Ubuntu 26.04 Media Box Apple Screen Saver

This project contains scripts for Ubuntu 26 to help run the apple screen saver videos after 60 seconds of idle. I use this on my TV media computer to give a nice asthetic to my living room. Thanks Apple!

1. Install pre-requisite software
```
sudo apt update
sudo apt install curl
sudo apt install mpv libglib2.0-bin
```
2. Do everyting possible to turn off features in Gnome that cause the screen to turn off
```
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power power-saver-profile-on-low-battery false
```
3. Run download-vids.sh to downlaod the full set of apple screensaver videos in .mov format. They will be placed in a relative folder called ./aerials. Note: my media pc is not very powerful so I've specified the HD versions, if you want 4k you can modify the script to download those ones. Check the variables at the top of the script.
4. Modify VIDEO_DIR= in the idle-vieo.sh script to the location of your apple vidoes downloaded in the step above.
5. execute the following commands
```
systemctl --user daemon-reload
systemctl --user enable --now idle-video.service
```
