# ArchSway
Archlinux on sway from scratch with the most minimal dependencies. DIY is awesome

# Standard Installation Steps
[Arch Linux Installation Guide](https://wiki.archlinux.org/title/Installation_guide)

# Filesystem Setup
For a new setup, **ROOT** & **HOME** should be a _f2fs_ | _Bcachefs_ | _btrfs_ | _xfs_ partition. **ROOT** is mounted on / with the dedicated **HOME** |& **FILES**
_subvolume_ | _partition_ mounted to `/home` and `/home/${username}/files` repectively. **ROOT** should have a max size of **60-120GiB**
with **HOME** between **120-240GiB** and **FILES** of __arbitrary size__ for multimedia content. Setup [**zram**](https://wiki.archlinux.org/title/Zram) for 
efficient ram usage with a backing device of min size **16GiB**

**NOTE:**
- **make sure to create and mount bcachefs/btrfs with zstd compression on first mount during installation**
- **format & mount all drive with a [logical sector or block size](https://wiki.archlinux.org/title/Advanced_Format) of 4096**

## needed base system modules

- configure mkinitcpio
- Enable systemd-boot as boot manager (`bootctl install`)
- Start iwd, systemd-networkd, systemd-resolved system services
- enabling systemd-boot-update service to update systemd-boot on systemd upgrade
- river/sway as window manager with swayidle and waylock for idle and lock management and levee/yambar for bar management
    - base
    - btrfs-progs
    - bcachefs-tools
    - dosfstools
    - exfatprogs
    - f2fs-tools
    - intel-ucode microcode
    - iwd for wifi
    - kitty/foot terminal
    - linux-firmware
    - linux-zen
    - mesa for opengl
    - intel-media-driver for hardware video acceleration
    - polkit for seat and privileged access management
    - man-db [man-pages](https://wiki.archlinux.org/title/Man_page)
    - Setup GPG whith SSH authentication enabled
    - helix/neovim for config clone [awesome-helix](https://github.com/Ultra-Code/awesome-helix.git) to $XDG_CONFIG_HOME/helix or [awesome-neovim](https://github.com/Ultra-Code/awesome-neovim.git) to $XDG_CONFIG_HOME/nvim
    - sudo
    - elvish/fish (set default shell with `chsh -s $(which shellname)`)

### basic configuration

- symlink /run/systemd/resolve/stub-resolv.con to /etc/resolv.conf for dns resolution
- Copy networking bits already setup in the installation iso image .ie /etc/systemd/network{.conf.d|}/* to the mounted root partition.
  Find sample configuration in [networking/resolve.conf](https://github.com/Ultra-Code/archsway/blob/master/networking/resolve.conf) and  [networking/network](https://github.com/Ultra-Code/archsway/blob/master/networking/network)
- Enable synchronizing the system clock across the network by enabling [systemd-timesyncd.service](https://wiki.archlinux.org/title/Systemd-timesyncd)
- On the freshly installed system use the following fonts
    + use fonts with great unicode support like ttf-dejavu or noto-fonts or gnu-free-fonts as system default font
    + ttc-iosevka  or ttf-jetbrains-mono for monospace,
    + ttf-nerd-fonts-symbols-mono for nerd font symbols and noto-font-emoji for emoji
    >_NOTE_: don't forget to `ln -s /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf /etc/fonts/conf.d/`
- configure hardware acceleration and [Intel_graphics and Intel_GVT-g](https://wiki.archlinux.org/title/Intel_graphics)
- manual powermangement with udev rules and modprobe config files in [powersaving](https://github.com/Ultra-Code/archsway/blob/master/powersaving) .udev rules go to /etc/udev/rules.d
- and modprobe [configs](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate) in /etc/modprobe.d
- add resume kernel parameter to the boot loader and resume hook to mkinitcpio
- add resume to HOOKS in /etc/mkinitcpio.conf and rebuild kernel for hibernation and it variant to work
- enable powersaving options [power management](https://wiki.archlinux.org/title/Power_management) [laptop](https://wiki.archlinux.org/title/Laptop)
- [cpu frequency scaling](https://wiki.archlinux.org/title/CPU_frequency_scaling) and  [udev rules](https://wiki.archlinux.org/title/Udev)
- [Active State Power Management](https://wiki.archlinux.org/title/Power_management#Active_State_Power_Management) check
  if asmp is [supported ](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/power_management_guide/aspm) and add or remove `powersave > /sys/module/pcie_aspm/parameters/policy` from udev powersave rules based on that
- modify sudoers with visudo using example in [suders file](https://github.com/Ultra-Code/archsway/blob/master/sudoers)
- configure what powerbutton and lidclose does with /etc/systemd/logind.conf
- For [pacman](https://wiki.archlinux.org/title/Pacman) enable the following options under option section in /etc/pacman.conf
- For [Performance Improvements](https://wiki.archlinux.org/title/Improving_performance)
```bash
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
- Consider [Firefox Profile on Ram](https://wiki.archlinux.org/title/Firefox/Profile_on_RAM) when using ssd/nvme
- [move disk cache to ram](https://wiki.archlinux.org/title/Firefox/Tweaks#Move_disk_cache_to_RAM) by setting browser.cache.disk.parent_directory to /run/user/UID/firefox
- where UID is your user's ID which can be obtained by running id -u
- increase session save interval to 6 minutes (360000 milliseconds) by setting browser.sessionstore.interval to 360000

## INSTALLS
- base-devel for Basic c/c++ build tools to build Arch Linux packages
- lldb/gdb for debugging zig, c and c++
- clang/gcc for c++ development with clangd
- zig with zls for zig development
- rustup with default profile and rust-analyzer component for rust development
- luajit for lua development
- iptables-nft and nftable(automatically installed as a dependency of iptables-nft) for firewall configuration (enable the nftables service)
- nmap and tcpdump for network analysis and auditing
- yay for AUR packagem mangement
- android-file-transfer with libmtp for connecting android phones mtp management
- aria2 as download manager
- bat is a Cat clone with syntax highlighting and git integration
- bluez and bluez-utils for bluetooth
- brightnessctl for controling backlight
- carapace-bin for completions in elvish
- fzf for fuzzy search
- vivid for LS_COLORS
- starship for prompt
- [Helix](https://github.com/Ultra-Code/awesome-helix) and [Neovim](https://github.com/Ultra-Code/awesome-neovim) awesomely setup with the relevant lsps and static analyzers for zig, c, rust, c++, luajit, python, shell, and web-development
- dictd server with dict client and some dictionary sources for yay like dict-wikt-en-all dict-freedict-eng-spa dict-freedict-spa-eng dict-foldoc dict-gcide dict-wn
    - NOTE: to disable online mode comment out `server dict.org` in  /etc/dict/dict.conf
    - Make sure locale is properly configured in `DICTD_ARGS` of /etc/conf.d/dictd else the service unit will fail
    - Since dict uses en_US.UTF-8 by default, make sure to comment it out in /etc/locale.gen and compile it along side your locale of choice es_MX.UTF-8
- ffmpegthumbnailer & gnome-epub-thumbnailer for thumbnails
- firefox with speech-dispatcher (for Text-to-Speech) as pdf reader or zathura and firefox-ublock-origin as adblocker and foliate/fbreader as epub reader
- wlsunset for controlling screen blue light
- git for version control
- grim and slurp for screenshot
- mako as a lightweight notification daemon for wayland
- docker for containerization of apps
- libreoffice-fresh for working with openoffice documents and hunspell-en_us for spellcheck, [for help setting up spellcheck](https://ask.libreoffice.org/t/how-do-you-get-the-spell-checker-to-work/28998)
- mpd for music daemon and ncmpcpp for ui interface and mpc for controlling playing
- mpv as multimedia player
- sound-theme-freedesktop for standard sounds and tone used in linux
- pipewire and pipewire-audio for audio/video routing and processing, pipewire-pulse as pulseaudio replacement and WirePlumber as pipewire session manager
- lf as filemanger
- fastfetch for displaying system information
- openssh and rsync for syncing file with remote over ssh
- remmina as remote desktop client with plugin like freerdp|libvncserver
- reflector for choosing fastest pacman server list
- usb_modeswitch for enabling modem mode for zero-cd based modems
- wl-clipboard for wayland clipboard
- batsignal for battery status notifications
- kanshi for wayland output management
- fuzzel as the application launcher
- cliphist as clipboard history manager
- qt5-wayland for runing qt5 apps under wayland
- xdg-desktop-portal-wrl for WebRTC screen sharing
- xdg-utils to assist applications with desktop integration tasks
- yt-dlp YouTube downloader
- zoxide for efficient directory movement

## OPTIONAL
- iwd for wifi and enable it dhcp client
- enable DNSOverTLS for resolved
- configure dns for 1.1.1.1 but this might not be needed since it's the default on arch linux. TODO: review the usefullness of the lines below
- disable unneeded services that run at boot like man-db.timer and mask ldconfig.service,systemd-rfkill*
- disable journaling to persistent storage by setting Storage in journal.conf to volatile and masking systemd-journal-flush.service
- link kitty to xterm
- Enable DNS over HTTPS in firefox
- modify relector configuration in /etc/xdg/reflector/reflector.conf to sort based on download rate with --sort rate
