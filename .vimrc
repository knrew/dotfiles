"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim/dein/')
  call dein#begin('~/.vim/dein/')

  " Let dein manage dein
  " Required:
  call dein#add('~/.vim/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

  " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', { 'rev': '3787e5' })
  call dein#add('Shougo/vimfiler')
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/neossh.vim')
  call dein#add('Shougo/context_filetype.vim')
  call dein#add('Shougo/vinarise.vim')

  " Unite {{{
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/unite-build')
  call dein#add('Shougo/unite-outline')
  call dein#add('Shougo/neomru.vim')
  call dein#add('Shougo/tabpagebuffer.vim')
  " call dein#add('kannokanno/unite-dwm')
  call dein#add('osyo-manga/unite-quickfix')
  " }}}

  call dein#add('lervag/vimtex')
  
  call dein#add('justmao945/vim-clang',{'on_ft' : 'cpp'})
  "call dein#add('Rip-Rip/clang_complete', {'on_ft' : 'cpp'})

  call dein#add('junegunn/seoul256.vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"let g:seoul256_background = 253
"colo seoul256

set expandtab
set tabstop=4
set shiftwidth=4

"let g:clang_snippets=1
"let g:clang_snippets_engine='ultisnips'
"let g:clang_conceal_snippets=1
"let g:clang_trailing_placeholder=1
"let g:clang_make_default_keymappings=1
"let g:clang_debug=1
"let g:clang_use_library=1
