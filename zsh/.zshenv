export PATH="$PATH:$HOME/.local/bin"

# Export default nix envs
if [ -e /home/ultracode/.nix-profile/etc/profile.d/nix.sh ]
then
    source /home/ultracode/.nix-profile/etc/profile.d/nix.sh
fi

USER_NIX_PATH=/nix/var/nix/profiles/per-user/ultracode
export NIX_PATH="$USER_NIX_PATH/channels:$HOME/.nix-defexpr/channels"
