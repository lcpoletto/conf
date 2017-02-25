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
" Nothing to configure so far
" https://github.com/majutsushi/tagbar.git
nmap <F8> :TagbarToggle<CR>
" Next config based on: https://github.com/jstemmer/gotags
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }

" https://github.com/Shougo/neocomplete.vim
"let g:neocomplete#enable_at_startup = 1
