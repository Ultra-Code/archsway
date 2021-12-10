#needed base system modules
systemd-boot as boot manager
packman hook for updating systemd-boot on systemd update
base , dosfstools , btrfs-progs ,exfatprogs,f2fs-tools,intel-ucode,iwd,kitty
linux-firmware,linux-zen,man-db,man-pages,lynx,neovim,sudo,zsh
In the freshly installed system use ttf-dejavu as the system font and ttf-iosevka-nerd and noto-font-emoji as prefered font
Use systemd-resolvd and netorkd for networking with it required configuration
configure dns for 1.1.1.1 but this might not be needed since it's the default on arch linux
enable DNSOverTLS for resolved
iwd for wifi and enable it dhcp client
symlink /run/systemd/resolve/stub-resolv.con to /etc/resolv.conf for dns resolution
disable unneeded services that run at boot like man-db.timer and mask ldconfig.service,systemd-rfkill*
disable journaling to persistent storage by setting Storage in journal.conf to volatile and masking systemd-journal-flush.service
link kitty to xterm
configure hardware acceleration and Intel_graphics and Intel_GVT-g
enable powersaving options
add resume kernel parameter to the boot loader and resume hook to to
mkinitcpio.conf and rebuild kernel for hibernation and it variant to work
modify relector configuration in /etc/xdg/reflector/reflector.conf to sort
based on download rate with --sort rate
add %ultracode ALL=(ALL) ALL and Defaults:ultracode timestamp_timeout=30 to
sudoers using visudo to allow ultracode access to all command and password
cache for 30 min

#INSTALLS
install mesa as dri userspace driver and intel-media-driver as va-api for intel
firefox-developer-edition for browsing
pulseaudio and libpulse for audio and controling audio
brightnessctl for controling backlight
fzf for fuzzy search
wl-clipboard for wayland clipboard
libreoffice-fresh for working with openoffice documents
gammastep for controlling nightlight
reflector for choosing fastest pacman server list
rsync and openssh for syncing file with remote over ssh
git for version control
gcc for c++ development
node and npm for ts development
nix package management for reproducible development
transmission/qbittorrent for torrent management
xorg-xwayland for runing x on wayland if need be
sway as window manager with swayidle and swaylock for idle and lock mangement
waybar for swaybar management
grim and slurp for screenshot
zathura as pdf viewer with poppler backend and foliate as epub reader
dictd serve with dict client and some dictionary sources for yay like dict-wikt-en-all dict-freedict-eng-spa dict-freedict-spa-eng dict-foldoc dict-gcide dict-wn
remove dictd online server in /etc/dict/dict.conf
yay for AUR packagem mangement
android-file-transfer with libmtp for connecting android phones mtp management
clangd with it extra-tools from the clang package for c++ text editor lsp support
compiledb for generating compile_commands.json
language servers for development vscode-langservers-extracted lua-language-server @tailwindcss/language-server typescript typescript-language-server @volar/server eslint cppcheck
stylua for lua formating
mpd for music deamon and ncmpcpp for ui interface and mpc for controlling playing
manual powermangement with config file in powersaving dir in .dotfiles
usb_modeswitch for enabling modem mode for zero-cd based modems
calc as terminal calculator
imv as image viewer
mpv as multimedia player
neofetch for displaying system information
intel-gpu-tools for monitoring gpu usage
nnn as filemanger
ffmpegthumbnailer gnome-epub-thumbnailer for thumbnails
imagemagick for use by kitty for terminal image preview
zoixide for efficient dir movement
advcpmv/advcp for cp/mv with progress information
qt5-wayland for runing qt5 apps under wayland
pip python package installer

#Configuring
#Firefox
look and verify hardware acceleration is working MOZ_LOG="PlatformDecoderModule:5" firefox-developer-edition
Enable WebRender by going to about:config and setting gfx.webrender.all to true
media.hardware-video-decoding.force-enabled to true for force-enabled hardware-video-decoding
set browser.cache.disk.parent_directory to /run/user/UID/firefox, where UID is
your user's ID which can be obtained by running id -u to move disk cache to ram
increase session save interval to 10 minutes (600000 milliseconds) by setting browser.sessionstore.interval to 600000
pref("media.ffmpeg.vaapi.enabled", true);
pref("media.ffvpx.enabled", false);
#pref("media.rdd-ffvpx.enabled", false)
#pref("media.rdd-vpx.enabled",false)
#pref("media.rdd-ffmpeg.enabled",true)
pref("media.rdd-process.enabled", false);
pref("media.navigator.mediadatadecoder_vpx_enabled",true)
#pref("security.sandbox.content.level", 0); vaapi can be enabled without this option

#Enable webrender compositor
pref("gfx.webrender.all",true)
pref("gfx.webrender.compositor",true)
#pref("gfx.webrender.compositor.force-enabled",true) //improve webrendering performance but causes ui gliches
Enable DNS over HTTPS in firefox
