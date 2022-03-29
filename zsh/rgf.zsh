# Two-phase filtering with Ripgrep and fzf
#
# 1. Search for text in files using Ripgrep
# 2. Interactively restart Ripgrep with reload action
#    * Press ctrl-f to switch to fzf-only filtering
# 3. Open the file in Vim
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
INITIAL_QUERY="${*:-}"
FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
fzf --ansi \
  --color "hl:-1:underline,hl+:-1:underline:reverse" \
  --disabled --query "$INITIAL_QUERY" \
  --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true " \
  --bind "ctrl-f:unbind(change)+change-prompt(2. fzf> )+enable-search+clear-query" \
  --bind "enter:execute:nvim {1}" \
  --prompt '1. ripgrep> ' \
  --delimiter : \
  --preview 'bat --color=always {1} --highlight-line {2}' \
  --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
  # UNTILE https://github.com/junegunn/fzf/issues/2752 is fixed  .ie rebinding of the change event is allowed
  # --bind "ctrl-r:unbind(ctrl-f)+change-prompt(1. ripgrep> )+disable-search+clear-query,change:reload(sleep 0.1; $RG_PREFIX {q} || true)" \
