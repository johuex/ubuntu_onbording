#!usr/bin/bash

echo "APT update && upgrade"
sudo apt update -y
sudo apt upgrade -y

echo "Another DEV tools"
sudo apt install -y curl git

echo "Python tools install"
sudo apt install -y python3-pip python3-virtualenv

echo "Opera browser"
curl -fsSL https://deb.opera.com/archive.key | sudo gpg --dearmor -o /usr/share/keyrings/operabrowser-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/operabrowser-keyring.gpg] https://deb.opera.com/opera-stable/ stable non-free" | sudo tee /etc/apt/sources.list.d/opera-stable.list
sudo apt update
sudo apt install -y opera-stable

echo "Chrome browser"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo "Opera libffmpeg fix"
sudo snap install chromium-ffmpeg
sudo cp /snap/chromium-ffmpeg/current/chromium-ffmpeg-107578/chromium-ffmpeg/libffmpeg.so /usr/lib/x86_64-linux-gnu/opera/libffmpeg.so

echo "PyCharm Community"
sudo snap install pycharm-community --classic

echo "Intellij IDEA Community"
sudo snap install intellij-idea-community --classic

echo "VS Code"
curl -J -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o "vscode.deb"
sudo dpkg -i vscode.deb

echo "DBeaver"
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo dpkg -i dbeaver-ce_latest_amd64.deb

echo "Docker Engine"
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "AWS CLI 2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws
rm awscliv2.zip


echo "Chrome GNOME shell"
sudo apt -y install chrome-gnome-shell

#echo "Imwheel + Config + Start"
#sudo apt install -y imwheel
#echo '".*"             
#    None, Up, Button4, 5
#    None, Down, Button5, 5
#    Shift_L,   Up,   Shift_L|Button4, 4
#    Shift_L,   Down, Shift_L|Button5, 4
#    Control_L, Up,   Control_L|Button4
#    Control_L, Down, Control_L|Button5' > ~/.imwheelrc
#imwheel

echo "Add second in GNOME Shell Clock"
gsettings set org.gnome.desktop.interface clock-show-seconds true

echo "increase GMOME window border width"
gsettings set org.gnome.mutter draggable-border-width 15

echo "Flatpak"
sudo apt install -y flatpak gnome-software-plugin-flatpak

echo "L2TP/IPSec client libraries"
sudo apt install -y network-manager-l2tp  network-manager-l2tp-gnome

echo "Telegram"
wget https://dl.flathub.org/repo/appstream/org.telegram.desktop.flatpakref
sudo flatpak install -y org.telegram.desktop.flatpakref

echo "KDE Clocks"
wget https://dl.flathub.org/repo/appstream/org.gnome.clocks.flatpakref
sudo flatpak install -y org.gnome.clocks.flatpakref

echo "Pinta"
wget https://dl.flathub.org/repo/appstream/com.github.PintaProject.Pinta.flatpakref
sudo flatpak install -y com.github.PintaProject.Pinta.flatpakref

echo "Postman"
curl -O -J -L https://dl.pstmn.io/download/latest/linux_64
tar -xvzf postman-linux-x64.tar.gz -C ~

# problems with autocomplete downloadnig in curl
#echo "Discord"
#curl -o discrod.deb O -J -L https://discord.com/api/download?platform=linux&format=deb
#sudo dpkg -i discord
#sudo apt install -f

echo "Pass"
sudo apt install -y pass

if [ -e ~/.gitconfig ]; then
echo "Well, Git config file exists!"
else
echo "Add Git config file (not filled)"
echo '[user]
        name=
        email=' > ~/.gitconfig
fi

echo "Add AWS config files (not filled)"
mkdir ~/.aws
echo '[default]
region = 
output = ' > ~/.aws/config

echo '[default]
aws_access_key_id = 
aws_secret_access_key = ' > ~/.aws/credentials

echo "fix dual boot time error in Windows and Ubuntu"
timedatectl set-local-rtc 1

echo "*.heic support"
sudo apt install heif-gdk-pixbuf heif-thumbnailer

echo "Next your manual steps: 
1. Reboot;
2. Add VPN creds;
3. Install Slack, Discord, Postman(add Desktop link) from WEB;
4. Fill in creds for AWS;
5. Fill in creds for git;
6. Install in your Chrome-based browser GNOME Shell integration extension;
7. In Gnome Extension install: ... ;
8. Add imwheel as startup application."
