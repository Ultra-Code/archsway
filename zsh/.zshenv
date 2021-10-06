#set DOTFILES for personal config root directory
export DOTFILES="$HOME/.dotfiles"

#Set up zsh config root directory
export ZDOTDIR="$DOTFILES/zsh"

#source nix profile
if [ -e /home/ultracode/.nix-profile/etc/profile.d/nix.sh ];
then
    . /home/ultracode/.nix-profile/etc/profile.d/nix.sh;
fi
