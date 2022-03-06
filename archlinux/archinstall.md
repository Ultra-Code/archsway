#needed base system modules
systemd-boot as boot manager
packman hook for updating systemd-boot on systemd update
sway as window manager with swayidle and swaylock for idle and lock mangement and waybar for swaybar management
- base
- btrfs-progs
- dosfstools
- exfatprogs
- f2fs-tools
- intel-ucode
- iwd
- kitty
- linux-firmware
- linux-zen
- man-db man-pages
- neovim
- sudo
- zsh
- lynx
On the freshly installed system use ttf-liberation for serif and sans-serif and ttf-iosevka-nerd for monospace and noto-font-emoji for emoji
Use systemd-resolvd and netorkd for networking with it required configuration in https://github.com/Ultra-Code/dotfiles/blob/master/archlinux/networking/resolve.conf and https://github.com/Ultra-Code/dotfiles/blob/master/archlinux/networking/network
configure dns for 1.1.1.1 but this might not be needed since it's the default on arch linux
enable DNSOverTLS for resolved
iwd for wifi and enable it dhcp client
symlink /run/systemd/resolve/stub-resolv.con to /etc/resolv.conf for dns resolution
disable unneeded services that run at boot like man-db.timer and mask ldconfig.service,systemd-rfkill*
disable journaling to persistent storage by setting Storage in journal.conf to volatile and masking systemd-journal-flush.service
link kitty to xterm
configure hardware acceleration and Intel_graphics and Intel_GVT-g
enable powersaving options https://wiki.archlinux.org/title/Power_management
add resume kernel parameter to the boot loader and resume hook to to
add systemd to HOOKS in /etc/mkinitcpio.conf and rebuild kernel for hibernation and it variant to work
modify relector configuration in /etc/xdg/reflector/reflector.conf to sort based on download rate with --sort rate
add %ultracode ALL=(ALL) ALL and Defaults:ultracode timestamp_timeout=30 to sudoers using visudo to allow ultracode access to all command and password cache for 30 min
manual powermangement with config file in powersaving dir in .dotfiles
configure what powerbutton and lidclose does with /etc/systemd/logind.conf

#INSTALLS
advcpmv/advcp for cp/mv with progress information
android-file-transfer with libmtp for connecting android phones mtp management
aria2c as download manager
install tools in the base-devel group ,this can be found out with pacman -Qg base-devel
brightnessctl for controling backlight
calc as terminal calculator
clang for c++ development
language servers for development
    - vscode-langservers-extracted
    - lua-language-server
    - @tailwindcss/language-server
    - typescript
    - typescript-language-server
    - @volar/server
    - eslint
    - cppcheck
    - stylua for lua formating
dictd serve with dict client and some dictionary sources for yay like dict-wikt-en-all dict-freedict-eng-spa dict-freedict-spa-eng dict-foldoc dict-gcide dict-wn NOTE: remove dictd online server in /etc/dict/dict.conf
ffmpegthumbnailer & gnome-epub-thumbnailer for thumbnails
firefox as pdf reader or zathura and firefox-ublock-origin as adblocker and foliate as epub reader
fzf for fuzzy search
gammastep for controlling nightlight
git for version control
grim and slurp for screenshot
imagemagick for use by kitty for terminal image preview
imv as image viewer
intel-gpu-tools for monitoring gpu usage
install mesa as dri userspace driver and intel-media-driver as va-api for intel
libreoffice-fresh for working with openoffice documents
lldb for debuging zig c and c++
mpd for music deamon and ncmpcpp for ui interface and mpc for controlling playing
mpv as multimedia player
neofetch for displaying system information
nnn as filemanger
node and npm for ts development
rsync and openssh for syncing file with remote over ssh
pulseaudio and libpulse for audio and controling audio
wl-clipboard for wayland clipboard
reflector for choosing fastest pacman server list
qt5-wayland for runing qt5 apps under wayland
usb_modeswitch for enabling modem mode for zero-cd based modems
yay for AUR packagem mangement
yt-dlp youtube downloader
zig zls-bin for zig development
zoxide for efficient dir movement
nix package management for reproducible development

#Configuring
#Firefox
LINK: https://wiki.archlinux.org/title/Firefox#Hardware_video_acceleration
Configuration for firefox Hardware video acceleration
pref("media.ffmpeg.vaapi.enabled",true);
look and verify hardware acceleration is working MOZ_LOG="PlatformDecoderModule:5" firefox
LINK: https://wiki.archlinux.org/title/Firefox/Tweaks#Move_disk_cache_to_RAM
pref("browser.cache.disk.parent_directory","/run/user/UID/firefox"); where UID is your user's ID which can be obtained by running id -u to move disk cache to ram
increase session save interval to 6 minutes (360000 milliseconds) by setting pref("browser.sessionstore.interval",360000)
Enable DNS over HTTPS in firefox