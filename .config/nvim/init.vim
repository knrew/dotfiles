if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  "call dein#add('Shougo/deoplete.nvim')
  if !has('nvim')
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif


  " Add or remove my plugins:
  call dein#add('Shougo/denite.nvim')
  call dein#add('Shougo/deoplete.nvim') "complate
 
  " snippet
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  "call dein#add('honza/vim-snippets')

  call dein#add('Shougo/deol.nvim') "shell

  "call dein#add('Shougo/defx.nvim')
  "call dein#add('Shougo/vimproc.vim', {'build' : 'make'})  

  call dein#add('lervag/vimtex')

  " plugins end------

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif


" tab -> space:4
set expandtab
set tabstop=4
set shiftwidth=4

" complete (),{},[] 
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>

" deoplete
let g:deoplete#enable_at_startup = 1
set completeopt=menuone,noinsert

" neosnippet
let g:neosnippet#enable_snipmate_compatibility = 1

" vimtex
let g:latex_latexmk_options = '-pvc -halt-on-error'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_fold_enabled=0
let g:vimtex_view_enabled=0
call deoplete#custom#var('omni', 'input_patterns', {'tex': g:vimtex#re#deoplete})

" last
filetype plugin indent on
syntax enable


