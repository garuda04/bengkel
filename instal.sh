#!/bin/bash

# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

finish() {
  local ret=$?
  if [ ${ret} -ne 0 ] && [ ${ret} -ne 130 ]; then
    echo
    echo "ERROR: Failed to setup on Termux."
    echo "Internet bermasalah/Terputus, Silahkan chat kembali saya untuk instalasi ulang"
  fi
}

trap finish EXIT

clear

# Display header
echo -e "\n===================================="
echo "   Script Instalasi Cepat Di Termux   "
echo "===================================="
echo " Selamat Mencoba Aplikasi Ini "
echo " Developer  : Wahyu Pratama Purba "
echo " My Number  : 082282719563 "
echo " My YouTube : Wahyu_Prb "
echo "===================================="
echo ""

# Set the correct password here
correct_password=".."  # Ganti dengan kata sandi yang hanya Anda tahu

# Function to prompt for password
prompt_for_password() {
    echo -n "Masukkan kata sandi untuk melanjutkan: "
    read -s entered_password  # Read password input silently
    echo  # Print a new line after password input
}

# Main logic for password check
attempts=0
max_attempts=5

while [ $attempts -lt $max_attempts ]; do
    prompt_for_password

    if [[ "$entered_password" == "$correct_password" ]]; then
        echo -e "\nKata sandi benar. Akses diberikan!"
        break  # Exit the loop if correct password is entered
    else
        attempts=$((attempts + 1))
        echo -e "\nKata sandi salah. Silakan coba lagi. (Percobaan: $attempts/$max_attempts)"
    fi

    if [ $attempts -eq $max_attempts ]; then
        echo "Anda telah mencapai jumlah percobaan maksimum. Silahkan mencoba dalam 24 jam lagi."
        exit 1
    fi
done

# Prompt for username
read -r -p "Please enter username for debian installation: " username </dev/tty

# Update Termux repositories
termux-change-repo
pkg update -y -o Dpkg::Options::="--force-confold"
pkg upgrade -y -o Dpkg::Options::="--force-confold"
sed -i '12s/^#//' $HOME/.termux/termux.properties

# Setup Termux storage access
clear -x
echo -e "\nSetting up Termux Storage Access."
read -n 1 -s -r -p "Press any key to continue..."
termux-setup-storage

# Install required packages
pkgs=( 'wget' 'ncurses-utils' 'dbus' 'proot-distro' 'x11-repo' 'tur-repo' 'android-tools' 'pulseaudio' )
pkg uninstall dbus -y
pkg update
pkg install "${pkgs[@]}" -y -o Dpkg::Options::="--force-confold"
pkg install rofi -y

# Download Termux X11
echo "Downloading Termux-X11..."
wget https://github.com/termux/termux-x11/releases/download/nightly/app-arm64-v8a-debug.apk
mv app-arm64-v8a-debug.apk $HOME/storage/downloads/

# Create default directories
mkdir -p Desktop Downloads



#XFCE SETTINGS.....
pkgs=('git' 'neofetch' 'virglrenderer-android' 'papirus-icon-theme' 'xfce4' 'xfce4-goodies' 'eza' 'pavucontrol-qt' 'bat' 'jq' 'nala' 'wmctrl' 'firefox' 'netcat-openbsd' 'termux-x11-nightly' 'eza')

#Install xfce4 desktop and additional packages
pkg install "${pkgs[@]}" -y -o Dpkg::Options::="--force-confold"

#Put Firefox icon on Desktop
cp $PREFIX/share/applications/firefox.desktop $HOME/Desktop 
chmod +x $HOME/Desktop/firefox.desktop

#Set aliases
echo "
alias bengkel='proot-distro login bengkel --user $username --shared-tmp'
#alias zrun='proot-distro login bengkel --user $username --shared-tmp -- env DISPLAY=:1.0 MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform '
#alias zrunhud='proot-distro login bengkel --user $username --shared-tmp -- env DISPLAY=:1.0 MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform GALLIUM_HUD=fps '
alias hud='GALLIUM_HUD=fps '
alias ls='eza -lF --icons'
alias cat='bat '
alias apt='nala '
alias install='nala install -y '
alias uninstall='nala remove -y '
alias search='nala search '
alias list='nala list --upgradeable'
alias show='nala show'
" >> $PREFIX/etc/bash.bashrc

#Download Wallpaper
wget https://raw.githubusercontent.com/garuda04/bengkel/main/peakpx.jpg
wget https://raw.githubusercontent.com/garuda04/bengkel/main/dark_waves.png
mv peakpx.jpg $PREFIX/share/backgrounds/xfce/
mv dark_waves.png $PREFIX/share/backgrounds/xfce/

#Install WhiteSur-Dark Theme
wget https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/refs/tags/2023-04-26.zip
unzip 2023-04-26.zip
tar -xf WhiteSur-gtk-theme-2023-04-26/release/WhiteSur-Dark-44-0.tar.xz
mv WhiteSur-Dark/ $PREFIX/share/themes/
rm -rf WhiteSur*
rm 2023-04-26.zip

#Install Fluent Cursor Icon Theme
wget https://github.com/vinceliuice/Fluent-icon-theme/archive/refs/tags/2023-02-01.zip
unzip 2023-02-01.zip
mv Fluent-icon-theme-2023-02-01/cursors/dist $PREFIX/share/icons/ 
mv Fluent-icon-theme-2023-02-01/cursors/dist-dark $PREFIX/share/icons/
rm -rf $HOME//Fluent*
rm 2023-02-01.zip

#Setup Fonts
wget https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip
mkdir .fonts 
unzip CascadiaCode-2111.01.zip
mv otf/static/* .fonts/ && rm -rf otf
mv ttf/* .fonts/ && rm -rf ttf/
rm -rf woff2/ && rm -rf CascadiaCode-2111.01.zip

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip
unzip Meslo.zip
mv *.ttf .fonts/
rm Meslo.zip
rm LICENSE.txt
rm readme.md

wget https://github.com/garuda04/bengkel/raw/main/NotoColorEmoji-Regular.ttf
mv NotoColorEmoji-Regular.ttf .fonts

wget https://github.com/garuda04/bengkel/raw/main/font.ttf
mv font.ttf .termux/font.ttf

#Setup Fancybash Termux
wget https://raw.githubusercontent.com/garuda04/bengkel/main/fancybash.sh
mv fancybash.sh .fancybash.sh
echo "source $HOME/.fancybash.sh" >> $PREFIX/etc/bash.bashrc
sed -i "326s/\\\u/$username/" $HOME/.fancybash.sh
sed -i "327s/\\\h/termux/" $HOME/.fancybash.sh

#Autostart Conky
wget https://github.com/garuda04/bengkel/raw/main/config.tar.gz
tar -xvzf config.tar.gz
rm config.tar.gz
chmod +x .config/autostart/conky.desktop



#ROOT SETTINGS.....
# Unofficial Bash Strict Mode
set -euo pipefail
IFS=$'\n\t'

finish() {
  local ret=$?
  if [ ${ret} -ne 0 ] && [ ${ret} -ne 130 ]; then
    echo
    echo "ERROR: Failed to setup XFCE on Termux."
    echo "Please refer to the error message(s) above"
  fi
}

trap finish EXIT

username="$1"

pkgs_proot=('sudo' 'wget' 'nala' 'jq' 'conky-all')

#Install Debian proot
pd install debian
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt update
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt upgrade -y
pd login debian --shared-tmp -- env DISPLAY=:1.0 apt install "${pkgs_proot[@]}" -y -o Dpkg::Options::="--force-confold"

#Create user
pd login debian --shared-tmp -- env DISPLAY=:1.0 groupadd storage
pd login debian --shared-tmp -- env DISPLAY=:1.0 groupadd wheel
pd login debian --shared-tmp -- env DISPLAY=:1.0 useradd -m -g users -G wheel,audio,video,storage -s /bin/bash "$username"

#Add user to sudoers
chmod u+rw $PREFIX/var/lib/proot-distro/installed-rootfs/debian/etc/sudoers
echo "$username ALL=(ALL) NOPASSWD:ALL" | tee -a $PREFIX/var/lib/proot-distro/installed-rootfs/debian/etc/sudoers > /dev/null
chmod u-w  $PREFIX/var/lib/proot-distro/installed-rootfs/debian/etc/sudoers

#Set proot DISPLAY
echo "export DISPLAY=:1.0" >> $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.bashrc

#Set proot aliases
echo "
alias zink='MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform '
alias hud='GALLIUM_HUD=fps '
alias ls='eza -lF --icons'
alias cat='bat '
alias apt='sudo nala '
alias install='sudo nala install -y '
alias remove='sudo nala remove -y '
alias list='nala list --upgradeable'
alias show='nala show '
alias search='nala search '
alias start='echo please run from termux, not Debian proot.'
" >> $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.bashrc

#Set proot timezone
timezone=$(getprop persist.sys.timezone)
pd login debian --shared-tmp -- env DISPLAY=:1.0 rm /etc/localtime
pd login debian --shared-tmp -- env DISPLAY=:1.0 cp /usr/share/zoneinfo/$timezone /etc/localtime

#Setup Fancybash Proot
cp .fancybash.sh $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username
echo "source ~/.fancybash.sh" >> $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.bashrc
sed -i '327s/termux/proot/' $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.fancybash.sh

wget https://github.com/garuda04/bengkel/raw/main/conky.tar.gz
tar -xvzf conky.tar.gz
rm conky.tar.gz
mkdir $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.config
mv .config/conky/ $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.config
mv .config/neofetch $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.config

#Set theming from xfce to proot
cp -r $PREFIX/share/icons/dist-dark $PREFIX/var/lib/proot-distro/installed-rootfs/debian/usr/share/icons/dist-dark

cat <<'EOF' > $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.Xresources
Xcursor.theme: dist-dark
EOF

mkdir $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.fonts/
cp .fonts/NotoColorEmoji-Regular.ttf $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/$username/.fonts/ 

#Setup Hardware Acceleration
pd login debian --shared-tmp -- env DISPLAY=:1.0 wget https://github.com/garuda04/bengkel/raw/main/mesa-vulkan-kgsl_24.1.0-devel-20240421_arm64.deb
pd login debian --shared-tmp -- env DISPLAY=:1.0 sudo apt install -y ./mesa-vulkan-kgsl_24.1.0-devel-20240421_arm64.deb


#UTILS SETTINGS.....
cat <<'EOF' > $PREFIX/bin/prun
#!/bin/bash
varname=$(basename $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/*)
pd login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 $@

EOF
chmod +x $PREFIX/bin/prun

cat <<'EOF' > $PREFIX/bin/zrun
#!/bin/bash
varname=$(basename $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/*)
pd login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform $@

EOF
chmod +x $PREFIX/bin/zrun

cat <<'EOF' > $PREFIX/bin/zrunhud
#!/bin/bash
varname=$(basename $PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/*)
pd login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform GALLIUM_HUD=fps $@

EOF
chmod +x $PREFIX/bin/zrunhud

#copy utility ... Allows copying of Debian proot desktop menu items into Termux xfce menu to allow for launching programs from Debian proot from within the xfce menu rather than launching from terminal. 

cat <<'EOF' > $PREFIX/bin/copy
#!/bin/bash

cd

user_dir="$PREFIX/var/lib/proot-distro/installed-rootfs/debian/home/"

# Get the username from the user directory
username=$(basename "$user_dir"/*)

action=$(zenity --list --title="Choose Action" --text="Select an action:" --radiolist --column="" --column="Action" TRUE "Copy .desktop file" FALSE "Remove .desktop file")

if [[ -z $action ]]; then
  zenity --info --text="No action selected. Quitting..." --title="Operation Cancelled"
  exit 0
fi

if [[ $action == "Copy .desktop file" ]]; then
  selected_file=$(zenity --file-selection --title="Select .desktop File" --file-filter="*.desktop" --filename="$PREFIX/var/lib/proot-distro/installed-rootfs/debian/usr/share/applications")

  if [[ -z $selected_file ]]; then
    zenity --info --text="No file selected. Quitting..." --title="Operation Cancelled"
    exit 0
  fi

  desktop_filename=$(basename "$selected_file")

  cp "$selected_file" "$PREFIX/share/applications/"
  sed -i "s/^Exec=\(.*\)$/Exec=pd login debian --user $username --shared-tmp -- env DISPLAY=:1.0 \1/" "$PREFIX/share/applications/$desktop_filename"

  zenity --info --text="Operation completed successfully!" --title="Success"
elif [[ $action == "Remove .desktop file" ]]; then
  selected_file=$(zenity --file-selection --title="Select .desktop File to Remove" --file-filter="*.desktop" --filename="$PREFIX/share/applications")

  if [[ -z $selected_file ]]; then
    zenity --info --text="No file selected for removal. Quitting..." --title="Operation Cancelled"
    exit 0
  fi

  desktop_filename=$(basename "$selected_file")

  rm "$selected_file"

  zenity --info --text="File '$desktop_filename' has been removed successfully!" --title="Success"
fi

EOF
chmod +x $PREFIX/bin/copy

echo "[Desktop Entry]
Version=1.0
Type=Application
Name=copy
Comment=
Exec=copy
Icon=edit-move
Categories=System;
Path=
Terminal=false
StartupNotify=false
" > $PREFIX/share/applications/copy.desktop 
chmod +x $PREFIX/share/applications/copy.desktop 


#Start script
cat <<'EOF' > start
#!/bin/bash

# Enable PulseAudio over Network
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 > /dev/null 2>&1

XDG_RUNTIME_DIR=${TMPDIR} termux-x11 :1.0 & > /dev/null 2>&1
sleep 1

am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
sleep 1

MESA_NO_ERROR=1 MESA_GL_VERSION_OVERRIDE=4.3COMPAT MESA_GLES_VERSION_OVERRIDE=3.2 virgl_test_server_android --angle-gl & > /dev/null 2>&1

#GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=4.0 program

#MESA_LOADER_DRIVER_OVERRIDE=zink TU_DEBUG=noconform program

env DISPLAY=:1.0 GALLIUM_DRIVER=virpipe dbus-launch --exit-with-session xfce4-session & > /dev/null 2>&1
# Set audio server
export PULSE_SERVER=127.0.0.1 > /dev/null 2>&1

sleep 5
process_id=$(ps -aux | grep '[x]fce4-screensaver' | awk '{print $2}')
kill "$process_id" > /dev/null 2>&1


EOF

chmod +x start
mv start $PREFIX/bin

#Shutdown Utility
cat <<'EOF' > $PREFIX/bin/kill_termux_x11
#!/bin/bash

# Check if Apt, dpkg, or Nala is running in Termux or Proot
if pgrep -f 'apt|apt-get|dpkg|nala'; then
  zenity --info --text="Software is currently installing in Termux or Proot. Please wait for these processes to finish before continuing."
  exit 1
fi

# Get the process IDs of Termux-X11 and XFCE sessions
termux_x11_pid=$(pgrep -f /system/bin/app_process.*com.termux.x11.Loader)
xfce_pid=$(pgrep -f "xfce4-session")

# Add debug output
echo "Termux-X11 PID: $termux_x11_pid"
echo "XFCE PID: $xfce_pid"

# Check if the process IDs exist
if [ -n "$termux_x11_pid" ] && [ -n "$xfce_pid" ]; then
  # Kill the processes
  kill -9 "$termux_x11_pid" "$xfce_pid"
  zenity --info --text="Termux-X11 and XFCE sessions closed."
else
  zenity --info --text="Termux-X11 or XFCE session not found."
fi

info_output=$(termux-info)
pid=$(echo "$info_output" | grep -o 'TERMUX_APP_PID=[0-9]\+' | awk -F= '{print $2}')
kill "$pid"

exit 0


EOF

chmod +x $PREFIX/bin/kill_termux_x11

#Create kill_termux_x11.desktop
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Kill Termux X11
Comment=
Exec=kill_termux_x11
Icon=system-shutdown
Categories=System;
Path=
StartupNotify=false
" > $HOME/Desktop/kill_termux_x11.desktop
chmod +x $HOME/Desktop/kill_termux_x11.desktop
mv $HOME/Desktop/kill_termux_x11.desktop $PREFIX/share/applications

# Final message
clear -x
echo -e "\nPastikan Internet Berjalan Dengan Baik."
source $PREFIX/etc/bash.bashrc
termux-reload-settings

# Prompt for confirmation
read -p "Do you want to install VSC? (y/n): " choice

if [[ "$choice" == "yes" ]]; then
    varname=$(basename $HOME/../usr/var/lib/proot-distro/installed-rootfs/debian/home/*)

    proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 apt update
    proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install gpg software-properties-common apt-transport-https -y
    proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 wget https://packages.microsoft.com/repos/code/pool/main/c/code/code_1.95.3-1731512059_arm64.deb -O code.deb
    proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install ./code.deb -y
    proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 rm code.deb
    proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | proot-distro login debian --shared-tmp -- env DISPLAY=:1.0 sudo apt-key add -

    echo "[Desktop Entry]
Version=1.0
Type=Application
Name=Visual Studio Code
Comment=Code Editing. Redefined.
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /usr/share/code/code --no-sandbox
Icon=visual-studio-code
Categories=Development;
Path=
Terminal=false
StartupNotify=false

" > $HOME/Desktop/code.desktop

    chmod +x $HOME/Desktop/code.desktop
    cp $HOME/Desktop/code.desktop $HOME/../usr/share/applications/code.desktop

    echo "VSC has been installed successfully."
else
    echo "Installation of VSC has been skipped."
fi

#install libreoffice dan wpsoffice
read -p "Do you want to install WO (y/n): " choice

if [[ "$choice" == "yes" ]]; then

    pd login debian --shared-tmp -- env DISPLAY=:1.0 sudo apt install gdebi libreoffice -y
    pd login debian --shared-tmp -- env DISPLAY=:1.0 clear; echo "Lagi Proses Silahkan Ditunggu.. "; wget -q https://kantor.wahyupratama-purba2004.workers.dev/0:/WO.deb
    pd login debian --shared-tmp -- env DISPLAY=:1.0 sudo -S apt install ./WO.deb -y
    pd login debian --shared-tmp -- env DISPLAY=:1.0 rm -rf WO.deb

    echo "[Desktop Entry]
Version=1.0
Type=Application
Name=WPS OFFICE
Comment=WPS OFFICE TO WORK
Exec=proot-distro login debian --user $varname --shared-tmp -- env DISPLAY=:1.0 /usr/bin/wps %F
Icon=wps-office2019-2019-kpromotheus
Categories=Office;
Path=
Terminal=false
StartupNotify=false

" > $HOME/Desktop/wps-office-promotheus.desktop

    chmod +x $HOME/Desktop/wps-office-promotheus.desktop
    cp $HOME/Desktop/wps-office-promotheus.desktop $HOME/../usr/share/applications/wps-office-promotheus.desktop

   
    echo "WO has been installed successfully ."
else
    echo "Installation of WO has been skipped."
fi

# Clean up
rm instal.sh instal.sh.enc

clear -x
echo -e "\n===================================="
echo "      Instalasi Telah Selesai!      "
echo "===================================="
echo " Jangan Pernah Mencoba Untuk Instalasi "
echo " Mandiri Tanpa Pengawasan Saya       "
echo " WAHYU PRATAMA PURBA                "
echo "===================================="
echo ""