set nocompatible
filetype off
call plug#begin()
" Make sure you use single quotes
" Load plugins
" VIM enhancements
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-sensible'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'qpkorr/vim-bufkill'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-commentary'
" Colorscheme plug
" Plug 'overcache/NeoSolarized'
Plug 'morhetz/gruvbox'

"Git
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-fugitive'

" Initialize plugin system"
call plug#end()

" Set colors
set termguicolors
set background=dark
let g:gruvbox_contrast_dark='medium'
colorscheme gruvbox


"Lightline
let g:lightline#bufferline#show_number  = 0
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'

let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'
let g:lightline.active = {'left': [ [ 'mode', 'paste' ],[ 'cocstatus', 'readonly', 'filename', 'modified' ] ] }
let g:lightline.component_function = {'filename': 'LightlineFilename', 'cocstatus': 'coc#status'}
let g:lightline.tabline          = {'left': [['buffers']], 'right': []}

" Enable bufferline
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[new file]'
endfunction

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

" Open hotkeys
map <C-p> :GFiles<CR>
nmap <leader>; :Buffers<CR>

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'

" Completion
" Better display for messages
set cmdheight=1
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" =============================================================================
" # Editor settings
" =============================================================================
filetype plugin indent on
set autoindent
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set encoding=utf-8
set scrolloff=8
set noshowmode
set hidden
set nowrap
set nojoinspaces
let g:sneak#s_next = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1
" Always draw sign column. Prevent buffer moving when adding/deleting sign.
" set signcolumn=number
set signcolumn=yes

" Sane splits
set splitright
set splitbelow

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" Esc
nnoremap <A-q> <Esc>
inoremap <A-q> <Esc>
vnoremap <A-q> <Esc>
snoremap <A-q> <Esc>
xnoremap <A-q> <Esc>
cnoremap <A-q> <C-c>
onoremap <A-q> <Esc>
lnoremap <A-q> <Esc>
tnoremap <A-q> <Esc>

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" =============================================================================
" # GUI settings
" =============================================================================
set guioptions-=T " Remove toolbar
set backspace=2 " Backspace over newlines
set nofoldenable
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
set showtabline=2
set number
set relativenumber
set diffopt+=iwhite " No whitespace in vimdiff
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
set showcmd " Show (partial) command in status line.
set mouse=a " Enable mouse usage (all modes) in terminals
set shortmess+=c " don't give |ins-completion-menu| messages.
set cursorline
set guicursor=a:block-blinkon0,i:blinkwait50-blinkon200-blinkoff150
" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Damn you
cnoremap :Q! :q!
cnoremap :Q :q
cnoremap :W :w
" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>
nnoremap <leader>bd :BD!<CR>
nnoremap <leader>w :BD<CR>

" Show actions available at this location
nnoremap <silent> <leader><space> :CocAction<cr>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>grn <Plug>(coc-rename)
nmap <leader>gt <Plug>(coc-type-definition)
nmap <leader>gre <Plug>(coc-references)

" Terminal
nnoremap <C-T> :split\|:term<CR>i
tnoremap <Esc> <C-\><C-n>
tnoremap <C-W> <C-\><C-n>:BD!<CR>
