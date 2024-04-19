sudo ln --interactive --symbolic --relative --verbose /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf /etc/fonts/conf.d/
sudo ln --interactive --symbolic --relative --verbose etc/pacman.d/pacman.conf /etc/pacman.d/
ln fzf/rgf.sh /home/ultracode/.local/bin/rgf
ln gnupg/sshcontrol /home/ultracode/.gnupg/
ln gnupg/gpg-agent.conf /home/ultracode/.gnupg/
ln ssh/config /home/ultracode/.ssh/
ln terminal/kitty/ ../
ln fzf/fzt.sh /home/ultracode/.local/bin/fzt
ln git/ ~/.config/
ln -s /home/ultracode/.config/dotfiles/elvish/ /home/ultracode/.config/elvish
sudo ln /usr/lib/helix/hx /bin/hx
sudo cp etc/xdg/reflector/reflector.conf /etc/xdg/reflector/reflector.conf
ln fontconfig/fonts.conf ../
cp etc/pacman.d/pacman.conf /etc/pacman.d/pacman.conf
ln procps/ ../
sudo cp etc/systemd/journald.conf.d/journald.conf /etc/systemd/journald.conf.d/
sudo mkdir -p /etc/systemd/logind.conf.d ; sudo cp etc/systemd/logind.conf.d/logind.conf /etc/systemd/logind.conf.d/
sudo mkdir -p /etc/systemd/sleep.conf.d ; sudo cp etc/systemd/sleep.conf.d/sleep.conf /etc/systemd/sleep.conf.d/
sudo cp etc/systemd/resolved.conf.d/resolved.conf /etc/systemd/resolved.conf.d/
sudo cp etc/systemd/network/13-usb-ethernet.network /etc/systemd/network/20-usb-ethernet.network
sudo cp etc/iwd/main.conf /etc/iwd/
ln zig/zig-update.elv /home/ultracode/.local/bin/zig-update
ln mako/ ../
sudo cp etc/modules-load.d/* /etc/modules-load.d/
sudo cp etc/modprobe.d/* /etc/modprobe.d/
sudo cp etc/udev/rules.d/* /etc/udev/rules.d/
sudo cp etc/sysctl.d/* /etc/sysctl.d/
sudo cp etc/fstab /etc/fstab
ln config/* ../
ln mako/ ../
ln config/gnupg/* ../gnupg/
ln config/zls.json ../
# mpd and ncmcpp create folder and link the config into these folders
# just like for gnupg
md ../{mpd{/playlist} ncmpcpp}
ln config/mpd/* ../mpd/
ln config/ncmpcpp/* ../ncmpcpp/
# link efm-language-server config
ln efm-langserver/ ../
Ln /bin/helix /bin/hx
