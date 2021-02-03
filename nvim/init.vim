call plug#begin('~/.vim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Extensions to built-in LSP, for example, providing type inlay hints
Plug 'tjdevries/lsp_extensions.nvim'

" Autocompletion framework for built-in LSP
Plug 'nvim-lua/completion-nvim'

" LSP Status
Plug 'nvim-lua/lsp-status.nvim'

" LSP Installer
" LspInstall rust_analyzer
Plug 'anott03/nvim-lspinstall'

" Colors
Plug 'morhetz/gruvbox'

"Git
Plug 'airblade/vim-gitgutter'

" Fuzzy
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'andymass/vim-matchup'
Plug 'qpkorr/vim-bufkill'
Plug 'kosayoda/nvim-lightbulb'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Semantics
Plug 'jiangmiao/auto-pairs'

call plug#end()

syntax enable
filetype plugin indent on

set termguicolors
let g:gruvbox_contrast_dark='medium'
colorscheme gruvbox

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require('lspconfig')

-- LSP status for display in statusline
local lsp_status = require('lsp-status')
lsp_status.register_progress()
    lsp_status.config({
    status_symbol = '',
})

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })

nvim_lsp.rust_analyzer.setup({
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

-- Tree sitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "rust", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
EOF

"Lightline
let g:lightline#bufferline#show_number  = 0
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'

let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'
let g:lightline.active = {'left': [[ 'mode', 'paste' ], [ 'lsp' ]] }
let g:lightline.component_function = {'lsp': 'LspStatus'}
let g:lightline.tabline          = {'left': [['buffers', 'readonly']], 'right': []}

" Enable bufferline
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}

" LSP Status 
function! LspStatus() abort
    if luaeval('#vim.lsp.buf_get_clients() > 0')
       return luaeval("require('lsp-status').status()")
    endif
    return ''
endfunction

" Rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'

" Open hotkeys
map <C-p> :GFiles<CR>
map <C-P> :Files<CR>
nmap <leader>; :Buffers<CR>

"Search
map <leader>f :Ag<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.defer_fn(function() vim.lsp.diagnostic.show_line_diagnostics() end, 2000)

" Enable type inlay hints
autocmd BufEnter,BufWinEnter,InsertLeave,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "NonText", enabled = {"ChainingHint", "TypeHint", "ParameterHint"} }

" Highlight on yank
autocmd TextYankPost * silent! lua vim.highlight.on_yank()

" Control keymaps
" Esc
nnoremap <C-c> <Esc>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>
snoremap <C-c> <Esc>
xnoremap <C-c> <Esc>
cnoremap <C-c> <Esc>
onoremap <C-c> <Esc>
lnoremap <C-c> <Esc>
tnoremap <C-c> <Esc>

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c
" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
set signcolumn=yes
set scrolloff=10
set nojoinspaces
set splitright
set splitbelow
set formatoptions=tcrqnj
set incsearch
set ignorecase
set smartcase
set tabstop=4
set shiftwidth=4
set expandtab
set number
set showtabline=2
set relativenumber
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
set showcmd
set mouse=a
set guicursor=a:block-blinkon0,i:blinkwait50-blinkon200-blinkoff150

" Buffer movement
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

" Left and right can switch buffers
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Terminal
nnoremap <C-T> :split\|:term<CR>i
tnoremap <Esc> <C-\><C-n>
