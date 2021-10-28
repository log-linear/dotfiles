"============================== General settings ===============================
let mapleader=" "                    " remap <leader>
set cursorline                       " Cursor line highlight
set showcmd                          " show commands in status line
filetype plugin indent on            " filetype detection
set notimeout                        " No key sequence timeout
set clipboard+=unnamedplus           " Use system clipboard for yank/paste
set splitbelow splitright            " Splits open at the bottom and right
set mouse=a                          " Enable mouse support
set scrolloff=3 sidescroll=3         " Always show 3 horiz/vert lines on scroll
set number relativenumber            " Relative line numbers
set hidden                           " Allow switching buffers before saving
set signcolumn=auto:9                " sign column for gitgutter, coc, etc
set cmdheight=2                      " Give more space for displaying messages.
set nobackup                         " Fix breakages with certain coc lsps
set nowritebackup                    " Fix breakages with certain coc lsps
set updatetime=300                   " Reduce coc.nvim lag
set shortmess+=c                     " no ins-completion-menu messages
set autoindent smartindent           " autoindent
set expandtab tabstop=4 shiftwidth=4 " tabs to spaces, default 4

" search tweaks - highlighting, semi-case-insensitive search, etc
set incsearch showmatch hlsearch ignorecase smartcase

" Visual line guide at 80 characters
set colorcolumn=80
highlight ColorColumn ctermbg=238

"------------------------------------ Maps -------------------------------------
" Esc/Ctrl+[ clears last search highlighting
noremap <esc> :noh<CR>
noremap <C-[> :noh<CR>

" Multi-mode mappings
for mapcmd in ['noremap', 'inoremap', 'vnoremap', 'tnoremap']
  " Remap split navigation to ALT + hjkl
  execute mapcmd . ' <A-h> <C-\><C-n><C-w>h'
  execute mapcmd . ' <A-j> <C-\><C-n><C-w>j'
  execute mapcmd . ' <A-k> <C-\><C-n><C-w>k'
  execute mapcmd . ' <A-l> <C-\><C-n><C-w>l'
  " Remap split adjustment to ALT + HJKL
  execute mapcmd . ' <A-H> <C-\><C-n><C-w>:vertical resize -3<CR>'
  execute mapcmd . ' <A-J> <C-\><C-n><C-w>:resize -3<CR>'
  execute mapcmd . ' <A-K> <C-\><C-n><C-w>:resize +3<CR>'
  execute mapcmd . ' <A-L> <C-\><C-n><C-w>:vertical resize +3<CR>'
  execute mapcmd . ' <A-=> <C-\><C-n><C-w>='
  " Alt + q to close windows
  execute mapcmd . ' <A-q> <C-\><C-n>:q<CR>'
  " Buffer navigation/management
  execute mapcmd . ' <A-d> <C-\><C-n>:bn <BAR> bd #<CR>'
  execute mapcmd . ' <A-n> <C-\><C-n>:bn<CR>'
  execute mapcmd . ' <A-p> <C-\><C-n>:bp<CR>'
  execute mapcmd . ' <A-s> <C-\><C-n>:split<CR>'
  execute mapcmd . ' <A-v> <C-\><C-n>:vsplit<CR>'
endfor

" Headers
nnoremap <leader>B 0D80A=<esc>0:execute "normal! 0r" . &commentstring[0]<cr>
nnoremap <leader>b 0D80A-<esc>0:execute "normal! 0r" . &commentstring[0]<cr>
nnoremap <leader>H :center<cr>2hv0r=A<space><esc>40A=<esc>d80<bar>0:execute "normal! 0r" . &commentstring[0]<cr><esc>
nnoremap <leader>h :center<cr>2hv0r-A<space><esc>40A-<esc>d80<bar>0:execute "normal! 0r" . &commentstring[0]<cr><esc>

" Start terminals
map <Leader>tt :split term://zsh<CR><C-\><C-n><C-w>k
map <Leader>tp :split term://zsh<CR>ipython<CR><C-\><C-n><C-w>k
map <Leader>tr :split term://zsh<CR>iradian --no-history<CR><C-\><C-n><C-w>k

" Disable ex mode
nnoremap Q <Nop>

" Always enter terminals in insert mode
au WinEnter term://* :startinsert

"============================= Filetype settings ===============================
augroup ft_conf
  au!
  au FileType sh,bash,zsh setlocal expandtab shiftwidth=2 tabstop=2 " Shell tabs
  au FileType vim setlocal tw=0          " No text-wrapping
  au BufEnter *.tsv setlocal noexpandtab " Use actual tabs in tsvs
  
  " R settings
  au FileType r,rmd setlocal expandtab shiftwidth=2 tabstop=2 autoindent cindent
  for mapcmd in ['inoremap', 'tnoremap']
    " map assignment + pipe operators
    execute 'au FileType r,rmd ' . mapcmd . ' ;; <-'
    execute 'au FileType r,rmd ' . mapcmd . ' ;n \|>'
    execute 'au FileType r,rmd ' . mapcmd . ' ;m %>%'
    " map infix operators
    execute 'au FileType r,rmd ' . mapcmd . ' ;in %in%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;: %%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;/ %/%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;* %*%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;o %o%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;x %x%'
  endfor
  
  " Markdown
  au BufEnter *.md setlocal conceallevel=0
  au FileType markdown setlocal expandtab shiftwidth=4 tabstop=4
  " Run markdown preview, requires mlp python package
  au FileType markdown nmap <leader>mlp :call jobstart('mlp '.expand('%'))<CR>
  " Convert md to html, pdf, or docx using pandoc
  au FileType markdown nmap <leader>mh :w! \| !pandoc "%" -o "%:r.html"<CR>
  au FileType markdown nmap <leader>mw :w! \| !pandoc "%" -o "%:r.docx"<CR>
  au FileType markdown nmap 
    \<leader>mp :w! \| !pandoc "%" --pdf-engine=xelatex -o "%:r.pdf"<CR>
  
  " Run current python file
  au FileType python nmap <leader>py :w! \| !python %<CR>
augroup END

"================================== Plugins ====================================
" Install vim-plug if not already available
if empty(stdpath("config") . '/site/autoload/plug.vim')
  silent !curl -fLo stdpath("config") . '/site/autoload/plug.vim' --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
au VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" vim-polyglot settings need to run before loading
let g:polyglot_disabled = ['markdown']

" Load plugins
call plug#begin(stdpath("config") . '/plugged')
  " Functionality
  Plug 'tpope/vim-commentary'                         " easy code commenting
  Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}        " R support
  Plug 'tpope/vim-fugitive'                           " git integration
  Plug 'mhinz/vim-signify'                            " git diff markers
  Plug 'karoliskoncevicius/vim-sendtowindow'          " Basic REPLing
  Plug 'tpope/vim-surround'                           " surround text objects
  Plug 'tpope/vim-repeat'                             " repeat plugin commands
  Plug 'mhinz/vim-startify'                           " fancy startup menu
  Plug 'ferrine/md-img-paste.vim'                     " Paste images to md files
  Plug 'junegunn/vim-easy-align'                      " Text alignment
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy Finder
  Plug 'junegunn/fzf.vim'                             " fzf functions

  " IDE features
  Plug 'neovim/nvim-lspconfig'                        " Language Server Protocol
  Plug 'ray-x/lsp_signature.nvim'                     " Function param popup
  Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }         " Auto-completion

  " Aesthetics/visual aids
  Plug 'sheerun/vim-polyglot'                         " syntax highlighting
  Plug 'vim-airline/vim-airline'                      " status bar
  Plug 'junegunn/goyo.vim'                            " zen mode
  Plug 'morhetz/gruvbox'                              " theme
  Plug 'ryanoasis/vim-devicons'                       " Required: Nerd Font
  Plug 'Yggdroot/indentLine'                          " Visual line indents
  Plug 'ryanoasis/vim-devicons'                       " Icons, always load last
call plug#end()

"---------------------------------- coq_nvim -----------------------------------
let g:coq_settings = {
  \ 'auto_start': v:true, 
  \ 'keymap.recommended': v:false,
  \ 'keymap.jump_to_mark': 'null'
\ }

" Keybindings
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"

"------------------------------ vim-sendtowindow -------------------------------
let g:sendtowindow_use_defaults=0
nmap <A-Space> <Plug>SendDown
xmap <A-Space> <Plug>SendDownV
imap <A-Space> <esc><Plug>SendDownV

"---------------------------------- fzf.vim ------------------------------------
nnoremap <Leader>/f :Files<CR>
nnoremap <Leader>/g :GFiles<CR>
nnoremap <Leader>/c :BCommits<CR>
nnoremap <Leader>/h :Help<CR>
nnoremap <Leader>/s :History<CR>
nnoremap <Leader>// :BLines<CR>
nnoremap <Leader>/b :Buffers<CR>
nnoremap <Leader>/l :Lines<CR>
nnoremap <Leader>/m :Maps<CR>
nnoremap <Leader>/t :Filetypes<CR>

"------------------------------- vim-easy-align --------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"-------------------------------- md-img-paste ---------------------------------
au FileType markdown 
  \ nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>

"-------------------------------- vim-airline ----------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

"--------------------------------- indentline ----------------------------------
let g:indentLine_char = '▏'

"---------------------------------- gruvbox ------------------------------------
colorscheme gruvbox
let g:airline_theme = 'gruvbox'

"------------------------------------ Goyo -------------------------------------
map <leader>z :Goyo \| set linebreak<CR>

"----------------------------------- Nvim-R ------------------------------------
let R_auto_start = 2               " Auto start on all .R/.Rmd files
let R_assign = 0                   " Disable assignment operator, use au above
let R_min_editor_width = 80        " set a minimum source editor width
let R_objbr_place = 'script,right' " Open obj explorer on right
let R_objbr_opendf = 0             " Don't show df cols in obj explorer 
let R_csv_app = 'terminal:vd'      " Use visidata as data.frame/matrix viewer
let R_esc_term = 0                 " Don't use <Esc>/<C-[> to exit terminal mode
let r_indent_align_args = 0        " Disable weird indenting rules
let R_rconsole_width = 1000        " Ensure console splits below
let R_objbr_allnames = 1           " Show hidden objects
let R_openpdf = 1                  " Only auto-open knit-ed PDFs once

" Use radian console
let R_app = 'radian'
let R_cmd = 'R'
let R_hl_term = 0
let R_args = ['--no-history']
let R_bracketed_paste = 1

" Press Alt + Return to send lines and selection to R console
vmap <A-CR> <Plug>RDSendSelection
nmap <A-CR> <Plug>RDSendLine
imap <A-CR> <esc><Plug>RDSendLine<CR>

"-------------------------------- vim-signify ----------------------------------
map <leader>uh :SignifyHunkUndo<CR>

"-------------------------------- vim-startify ---------------------------------
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions'] },
      \ { 'type': 'files',     'header': ['   Recent']   },
      \ { 'type': 'commands',  'header': ['   Commands'] },
      \ ]

"---------------------------- LSP, auto-completion -----------------------------
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Function signature
  require "lsp_signature".on_attach()

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Hide in-line diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false
  }
)

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'r_language_server', 'bashls', 'vimls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- nvim_coq
local coq = require "coq" 
EOF

"========================== Windows-specific configs ===========================
if has("win64") || has("win32") || has("win16")
  exec 'source ' . stdpath("config") . '\win.vim'
endif
