#!/bin/bash

TMP_DIR="tmp"
GNOME_EXT=()

on_exit() {
    rm -rf ${TMP_DIR}
}

log() {
    printf "$(date '+%Y-%m-%d %T.%6N') ${1}\n"
}

trap on_exit EXIT

mkdir $TMP_DIR

if [[ $EUID -ne 0 ]]; then
    echo "Please run script as root"
    exit 0
fi

log "APT update && upgrade"
sudo apt update -y > /dev/null
sudo apt upgrade -y > /dev/null

log "Install via APT"
sudo apt install -y curl git pass vim tmux heif-gdk-pixbuf heif-thumbnailer \
    wireguard jq zsh python3-pip python3-virtualenv gnome-extensions \
    flatpak gnome-software-plugin-flatpak chrome-gnome-shell > /dev/null

log "Install via snap"
sudo snap set system refresh.retain=1 > /dev/null
sudo snap install vlc spotify > /dev/null

log "Chrome browser"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $TMP_DIR > /dev/null
sudo dpkg -i "${TMP_DIR}/google-chrome-stable_current_amd64.deb" > /dev/null

log "VS Code"
curl -J -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o "${TMP_DIR}/vscode.deb" > /dev/null
sudo dpkg -i "${TMP_DIR}/vscode.deb" > /dev/null

log "DBeaver"
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -p "${TMP_DIR}" > /dev/null
sudo dpkg -i "${TMP_DIR}/dbeaver-ce_latest_amd64.deb" > /dev/null

log "Docker Engine"
sudo apt install -y ca-certificates curl gnupg lsb-release > /dev/null
sudo mkdir -p /etc/apt/keyrings > /dev/null
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg > /dev/null
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update > /dev/null
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin > /dev/null

log "AWS CLI 2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TMP_DIR}/awscliv2.zip" > /dev/null
unzip awscliv2.zip -d "${TMP_DIR}" > /dev/null
sudo "${TMP_DIR}/aws/install" > /dev/null

log "Postman"
curl -sOJL https://dl.pstmn.io/download/latest/linux_64
mv postman-linux-x64.tar.gz  "${TMP_DIR}" > > /dev/null
tar -xvzf "${TMP_DIR}/postman-linux-x64.tar.gz" -C ~ > /dev/null
username=$(whoami) envsubst '$username' < samples/postman.desktop > ~/.local/share/applications/postman.desktop

log "Golang"
read -p "Enter Golang version for install (1.22.2 for example): " golang_version
sudo rm -rf /usr/local/go > /dev/null
wget "https://go.dev/dl/go${golang_version}.linux-amd64.tar.gz" -P $TMP_DIR > /dev/null
if [[ -e "${TMP_DIR}/go${golang_version}.linux-amd64.tar.gz" ]]; then
    sudo tar -C /usr/local -xzf "${TMP_DIR}/go${golang_version}.linux-amd64.tar.gz" > /dev/null
else
    log "Golang wasn't installed, maybe incorrect version was passed"
fi

log "Add second in GNOME Shell Clock"
gsettings set org.gnome.desktop.interface clock-show-seconds true > /dev/null
log "increase GMOME window border width"
gsettings set org.gnome.mutter draggable-border-width 15 > /dev/null

flatpak --version
if [[ $? -eq 0 ]]; then
    flatfefs=( org.telegram.desktop org.gnome.clocks org.kde.kolourpaint app.drey.EarTag com.rafaelmardojai.Blanket de.haeckerfelix.Shortwave)
    for flref in ${flatfefs[@]}; docker
        log "Flatpak: ${flref}"
        flatpak install flathub $flref
    done
else
    log "flatpak missed so flatpak packages weren't installed"
fi

if [[ ! -e ~/.gitconfig ]]; then
    log "Add Git config file"
    read -p "Enter fullname: " git_name
    read -p "Enter fullname: " git_email
    git_name=$git_name git_email=$git_email envsubst '$git_name,$git_email' < samples/.gitconfig > ~/.gitconfig
fi

if [[ ! -d ~/.aws ]]; then
    echo "Add AWS config files"
    mkdir ~/.aws
    read -p "Enter aws region: " aws_region
    read -p "Enter output: " aws_output
    read -p "Enter aws access key: " aws_access
    read -p "Enter aws secret key: " aws_secret
    aws_access=$aws_access aws_secret=$aws_secret envsubst '$aws_access,$aws_secret' < samples/.aws/credentails > ~/.aws/credentails
fi

log "fix dual boot time error in Windows and Ubuntu"
timedatectl set-local-rtc 1 > /dev/null

# TODO: alises and exports to .zshrc (with yq)
# TODO: maybe instruction from TV (firewall) + ubuntu cleaners
log "Nekoray client"
nekoray_url=$(curl -s https://api.github.com/repos/MatsuriDayo/nekoray/releases/latest | jq ".assets[0].browser_download_url")
wget "${nekoray_url}" -P $TMP_DIR  -O nekoray_latest.deb > /dev/null
sudo dpkg -i "${TMP_DIR}/nekoray_latest.deb" > /dev/null

log "Copy vim & tmux configs"
cp -r samples/vim/ ~ > /dev/null
cp samples/tmux/.tmux.conf ~ > /dev/null
cp samples/tmux/.tmux.conf.local ~ > /dev/null

log "Check installed"
pass --version
git --version
jq --version
curl --version
vim --version
tmux --version
python --version
go version
aws --version
wg --version
zsh --version
flatpak --version
docker --version

echo "Next your manual steps:
1. Reboot;
2. Add VPN creds (wg & nekoray)
3. Install Slack, Discord from WEB;
4. Install in your Chrome-based browser GNOME Shell integration extension;
5. In CHROME install Gnome Extension install from README.md;
6. Apply dependencies in tmux and vim."
