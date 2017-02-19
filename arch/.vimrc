execute pathogen#infect()
syntax on
" use filetype detection and file-based indenting
filetype plugin indent on

set nocompatible
set number
set ruler
set hlsearch
set incsearch

set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab " use spaces instead of tabs
set smarttab
set showcmd
set hidden " will navigate through buffers even if there are changes on them
set term=screen-256color " avoid tmux from overriding colors

set directory=~/.vim/swp " swap files directory

" use actual tabs for makefiles (they don't work with spaces)
autocmd FileType make setlocal tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

" Plugins configuration start below:
" https://github.com/ctrlpvim/ctrlp.vim.git
set runtimepath^=~/.vim/bundle/ctrlp.vim
