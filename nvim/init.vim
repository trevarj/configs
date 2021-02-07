call plug#begin('~/.vim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Extensions to built-in LSP, for example, providing type inlay hints
" Plug 'tjdevries/lsp_extensions.nvim'
Plug '~/Workspace/lsp_extensions.nvim'

" Autocompletion framework for built-in LSP
Plug 'hrsh7th/nvim-compe'

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
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'akinsho/nvim-bufferline.lua' " Requires a Nerd Font
Plug 'kyazdani42/nvim-web-devicons'
Plug 'qpkorr/vim-bufkill'
Plug 'kosayoda/nvim-lightbulb'
Plug 'glepnir/lspsaga.nvim'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'hrsh7th/vim-vsnip'

" Semantics
Plug 'Raimondi/delimitMate'

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
local nvim_lsp = require 'lspconfig'
local saga = require 'lspsaga'
saga.init_lsp_saga()

-- LSP status for display in statusline
local lsp_status = require('lsp-status')
lsp_status.register_progress()
    lsp_status.config({
    status_symbol = '',
})

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    treesitter = true;
  };
}

-- function to attach status when setting up lsp
local on_attach = function(client)
    lsp_status.on_attach(client)
end

-- Set default client capabilities plus window/workDoneProgress
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities
})

require('bufferline').setup{}

nvim_lsp.sumneko_lua.setup({
    on_attach = on_attach,
    capabilities = capabilities
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

let g:lightline = {'enable': {'tabline': 0}}
let g:lightline.colorscheme = 'gruvbox'
let g:lightline.active = {'left': [[ 'mode', 'paste' ], [ 'lsp' ]] }
let g:lightline.component_function = {'lsp': 'LspStatus'}

" Open hotkeys
" map <C-p> :GFiles<CR>
" map <C-P> :Files<CR>
" nmap <leader>; :Buffers<CR>
nnoremap <C-p> <cmd>Telescope git_files<cr>
nnoremap <C-P> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"Search
map <leader>f :Ag<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })
inoremap <silent><expr> <C-e>     compe#close('<C-e>')

" Code Actions
nnoremap <silent><leader>ca :Lspsaga code_action<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
" Hover doc, enabled on CursorHold
" nnoremap <silent>K :Lspsaga hover_doc<CR>
" Signature help
nnoremap <silent> gs :Lspsaga signature_help<CR>
" Rename 
nnoremap <silent>gr :Lspsaga rename<CR>
" Definition preview
nnoremap <silent> gd :Lspsaga preview_definition<CR>

" Goto previous/next diagnostic warning/error
nnoremap <silent> [e :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]e :Lspsaga diagnostic_jump_prev<CR>

" Show diagnostic popup on cursor hold
" using regular LSP diagnostics for now, which are inline virtual text opposed
" to a popup from lspsaga
" autocmd CursorHold * lua vim.defer_fn(function() require'lspsaga.diagnostic'.show_line_diagnostics() end, 2000)

" Show definition on cursor hold
" autocmd CursorHold * lua vim.defer_fn(function() require'lspsaga.provider'.preview_definition() end, 2000)

" Show doc on cursor hold
autocmd CursorHold * lua vim.defer_fn(function() require('lspsaga.hover').render_hover_doc() end, 5000)


" Enable type inlay hints
autocmd BufEnter,BufWinEnter,InsertLeave,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.rust_analyzer.inlay_hints{ prefix = '', highlight = "NonText", enabled = {"ChainingHint", "TypeHint", "ParameterHint"} }

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
set completeopt=menu,menuone,noselect
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
set noshowmode
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
noremap <right> :bn<CR>
noremap <leader>c :BD<CR>

" Terminal
nnoremap <C-T> :split\|:term<CR>i
tnoremap <Esc> <C-\><C-n>
