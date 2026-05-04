if type fzf &> /dev/null; then
  alias aptls="apt list --installed 2> /dev/null | sed '1d' | fzf --preview 'apt show {1}'"
  alias aptrm="apt list --installed 2> /dev/null | sed '1d' | fzf --multi --preview 'apt show {1}' | cut -d/ -f1 | xargs -ro sudo apt purge"
fi
