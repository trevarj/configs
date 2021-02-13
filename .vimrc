" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Tpope
Plug 'tpope/vim-sensible' 
Plug 'tpope/vim-commentary' 

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Theme/UI
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'

" Initialize plugin system
call plug#end()

source $VIMRUNTIME/defaults.vim

" KEY BINDINGS
map <c-c> <esc>

nmap <C-p> :GFiles<CR>
nmap <C-P> :Files<CR>
nmap <leader>; :Buffers<CR>
nmap <leader>f :Ag<CR>

" PLUGIN CONFIGS
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_modified_removed = '▎'
let g:gitgutter_sign_removed = '▁'
let g:gitgutter_sign_removed_first_line = '▔'

"
" SET OPTIONS
"
" General
set belloff=all
set background=dark
let g:gruvbox_contrast_dark='medium'
colorscheme gruvbox
set mouse=a
" Layout
set signcolumn=yes
set number
set relativenumber
set showtabline=2
set tabstop=4
set expandtab
" Search
set ignorecase
set smartcase
