# ArchSway
Archlinux on sway from scratch with the most minimal dependencies. DIY is awesome

# basic setup
for new setup home should be a subvolume/partition mounted on the /root which is preferably btrfs/f2fs
and FILES partition mounted to home/{data,/files} FILES should be 120-140GiB and root should have a max of 60GiB
export ZDOTDIR in /etc/zsh/zshenv to $HOME/.config/dotfiles
NOTE: make sure to mount btfs with compression zstd on first mount on live iso

## needed base system modules

- systemd-boot as boot manager
- enabling systemd-boot-update service to update systemd-boot on systemd upgrade
- sway as window manager with swayidle and swaylock for idle and lock management and waybar for swaybar management
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
    - man-db [man-pages](https://wiki.archlinux.org/title/Man_page)
    - neovim
    - sudo
    - zsh (make zsh the default shell `chsh -s $(which zsh)`)

### basic configuration

- since networking bits are already setup in the iso , You can just copy them .ie /etc/systemd/network/* to the mounted partition and start the necessary services iwd,systemd-networkd,systemd-resolvd
  Or use configuration in [networking/resolve.conf](https://github.com/Ultra-Code/archsway/blob/master/networking/resolve.conf) and  [networking/network](https://github.com/Ultra-Code/archsway/blob/master/networking/network)
- Enable synchronizing the system clock across the network by enabling [systemd-timesyncd.service](https://wiki.archlinux.org/title/Systemd-timesyncd)
- On the freshly installed system use the following fonts
    + use fonts with great unicode support like noto-fonts or ttf-dejavu or gnu-free-fonts as system default font
    + ttf-jetbrains-mono or ttc-iosevka for monospace,
    + ttf-nerd-fonts-symbols-1000-em for nerd font symbols and noto-font-emoji for emoji
    >_NOTE_: don't forget to `ln -s /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf /etc/fonts/conf.d/`
- configure dns for 1.1.1.1 but this might not be needed since it's the default on arch linux
- enable DNSOverTLS for resolved
- iwd for wifi and enable it dhcp client
- symlink /run/systemd/resolve/stub-resolv.con to /etc/resolv.conf for dns resolution
- disable unneeded services that run at boot like man-db.timer and mask ldconfig.service,systemd-rfkill*
- disable journaling to persistent storage by setting Storage in journal.conf to volatile and masking systemd-journal-flush.service
- link kitty to xterm
- configure hardware acceleration and [Intel_graphics and Intel_GVT-g](https://wiki.archlinux.org/title/Intel_graphics)
- manual powermangement with udev rules and modprobe config files in [powersaving](https://github.com/Ultra-Code/archsway/blob/master/powersaving) .udev rules go to /etc/udev/rules.d
- and modprobe [configs](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate) in /etc/modprobe.d
- add resume kernel parameter to the boot loader and resume hook to mkinitcpio
- add resume to HOOKS in /etc/mkinitcpio.conf and rebuild kernel for hibernation and it variant to work
- enable powersaving options [power management](https://wiki.archlinux.org/title/Power_management) [laptop](https://wiki.archlinux.org/title/Laptop)
- [cpu frequency scaling](https://wiki.archlinux.org/title/CPU_frequency_scaling) and  [udev rules](https://wiki.archlinux.org/title/Udev)
- [Active State Power Management](https://wiki.archlinux.org/title/Power_management#Active_State_Power_Management) check
  if asmp is [supported ](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/power_management_guide/aspm) and add or remove `powersave > /sys/module/pcie_aspm/parameters/policy` from udev powersave rules based on that
- modify relector configuration in /etc/xdg/reflector/reflector.conf to sort based on download rate with --sort rate
- modify sudoers with visudo using example in [suders file](https://github.com/Ultra-Code/archsway/blob/master/sudoers)
- configure what powerbutton and lidclose does with /etc/systemd/logind.conf
- For [pacman](https://wiki.archlinux.org/title/Pacman) enable the following options under option section in /etc/pacman.conf
```zsh
[options]
Color
CheckSpace
VerbosePkgLists
ParallelDownloads = 5
```
- configure /etc/motd with the Message Of The Day Eg.`WELCOME MASTER MALPHA! WE ARE READY TO SERVE YOU!!!`
- after installation make sure to go through [Archlinux General Recommendation](https://wiki.archlinux.org/title/General_recommendations)

## Configuring Firefox
- Enable firefox [Hardware video acceleration](https://wiki.archlinux.org/title/Firefox#Hardware_video_acceleration) by setting media.ffmpeg.vaapi.enabled to true and Hardware WebRender by setting gfx.webrender.all to true
- [move disk cache to ram](https://wiki.archlinux.org/title/Firefox/Tweaks#Move_disk_cache_to_RAM) by setting browser.cache.disk.parent_directory to /run/user/UID/firefox
- where UID is your user's ID which can be obtained by running id -u
- increase session save interval to 6 minutes (360000 milliseconds) by setting browser.sessionstore.interval to 360000
- Enable DNS over HTTPS in firefox

## INSTALLS
- android-file-transfer with libmtp for connecting android phones mtp management
- aria2c as download manager
- install tools in the base-devel group ,this can be found out with pacman -Qg base-devel
- bat is a Cat clone with syntax highlighting and git integration
- bluez and bluez-utils for bluetooth
- brightnessctl for controling backlight
- clang/gcc for c++ development
- c/c++ build tools make,pkgconf,patch,fakeroot
- language servers for
    - cpp development
        - cppcheck
    - web development
        - vscode-langservers-extracted
        - @tailwindcss/language-server
        - typescript
        - typescript-language-server
        - @volar/server
        - eslint
    - lau development
        - lua-language-server
- dictd server with dict client and some dictionary sources for yay like dict-wikt-en-all dict-freedict-eng-spa dict-freedict-spa-eng dict-foldoc dict-gcide dict-wn
    - NOTE: to disable online mode comment out `server dict.org` in  /etc/dict/dict.conf
    - Make sure locale is properly configured in `DICTD_ARGS` of /etc/conf.d/dictd else the service unit will fail
- ffmpegthumbnailer & gnome-epub-thumbnailer for thumbnails
- firefox as pdf reader or zathura and firefox-ublock-origin as adblocker and foliate/fbreader as epub reader
- fzf for fuzzy search
- gammastep for controlling nightlight
- git for version control
- grim and slurp for screenshot
- imagemagick for use by kitty for terminal image preview
- imv as image viewer
- install mesa for opengl and as dri userspace driver and intel-media-driver as va-api for intel
- jq a Command-line JSON processor
- libreoffice-fresh for working with openoffice documents and hunspell-en_us for spellcheck, [for help setting up spellcheck](https://ask.libreoffice.org/t/how-do-you-get-the-spell-checker-to-work/28998)
- lldb for debugging zig c and c++
- mpd for music daemon and ncmpcpp for ui interface and mpc for controlling playing
- mpv as multimedia player
- neofetch for displaying system information
- lf as filemanger
- openssh and rsync for syncing file with remote over ssh
- pipewire and pipewire-audio for audio/video routing and processing and WirePlumber as pipewire session manager
- reflector for choosing fastest pacman server list
- texinfo for info pages
- usb_modeswitch for enabling modem mode for zero-cd based modems
- wl-clipboard for wayland clipboard
- qt5-wayland for runing qt5 apps under wayland
- xdg-desktop-portal-wrl for WebRTC screen sharing
- yay for AUR packagem mangement
- yt-dlp YouTube downloader
- zig zls-bin for zig development
- zoxide for efficient directory movement
- zsh-autosuggestions zsh-completions zsh-fast-syntax-highlighting zsh-theme-powerlevel10k-bin-git
zsh-history-substring-search complements zsh
