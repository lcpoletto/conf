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

set directory=~/.vim/swp " swap files directory

" use actual tabs for makefiles (they don't work with spaces)
autocmd FileType make setlocal tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
" usgin autocmd for python code because it was being overwriten by python.vim
" autoindent
"autocmd FileType python setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" NERDTree Configuration
" Auto open NERDTree and focus on the opened file
autocmd vimenter * NERDTree | wincmd p

" Open NERDTree with CTRL+n
map <C-n> :NERDTreeToggle<CR>

" Close NERDTree when it's the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")) | q | endif

let NERDTreeShowHidden = 1 " show hidden files on NERDTree
let NERDTreeWinSize = 50 " NERDTree window size (default is 31)

" bufferline configuration
let g:bufferline_excludes = ['\[vimfiler\]', 'NERD_tree_1']
let g:bufferline_echo = 0
autocmd VimEnter * let &statusline='%{bufferline#refresh_status()}' .bufferline#get_status_string()

" easy buffer switching
nnoremap <F5> :bp<CR>
nnoremap <F6> :bn<CR>
inoremap <F5> <ESC>:bp<CR>
inoremap <F6> <ESC>:bn<CR>

" Don't show docstring when autocompleting python code
autocmd FileType python setlocal completeopt-=preview

" python debugging from vim
nnoremap <F8> :w<CR>:!python -m pudb.run %
inoremap <F8> <ESC>:w<CR>:!python -m pudb.run %

" enable ReactJS syntax highlighting on .js files
let g:jsx_ext_required = 0
