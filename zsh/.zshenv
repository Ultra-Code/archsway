#set DOTFILES for personal config root directory
export DOTFILES="$HOME/.dotfiles"

#Set up zsh config root directory
export ZDOTDIR="$DOTFILES/zsh"

#Set up path for interactive envirionment
export PATH=$HOME/.local/bin:$PATH

#source nix profile
if [ -e /home/ultracode/.nix-profile/etc/profile.d/nix.sh ];
then
    . /home/ultracode/.nix-profile/etc/profile.d/nix.sh;
fi
