# Two-phase filtering with grep and fzf
#
# 1. Search for text in files using grep
# 2. Interactively restart grep with reload action
#    * Press ctrl-f to switch to fzf-only filtering
# 3. Open the file in Vim
RG_PREFIX="grep --extended-regexp --color=always --recursive --line-number --ignore-case --binary-files=without-match --exclude='.*' --exclude-dir='.git' --exclude-dir='*cache*' --ignore-case"
INITIAL_QUERY=${*:-}
  FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q $INITIAL_QUERY)" \
  fzf --ansi \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --disabled --query "$INITIAL_QUERY" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+clear-query+enable-search+rebind(ctrl-r)" \
      --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. grep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)" \
      --bind "enter:execute:nvim +{2} {1}" \
      --prompt '1. grep> ' \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
      # --header 'ctrl-r (ripgrep) ╱ ctrl-f (fzf)╱' \
