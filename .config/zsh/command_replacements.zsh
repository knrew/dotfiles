# ls -> eza
if type eza &> /dev/null; then
  alias ls=eza
else
  alias ls="ls --color=auto"
fi

# nvim
if type nvim &> /dev/null; then
  export EDITOR=nvim
  alias vim=nvim
  alias vi=nvim
  alias v=nvim
fi

# rm -> trash-put
if type trash-put &> /dev/null; then
  alias rm=trash-put
fi

# grep -> ripgrep
if type rg &> /dev/null; then
  alias grep=rg
fi

# cat -> bat
if type bat &> /dev/null; then
  alias cat=bat
fi

