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
set signcolumn=auto:2                " sign column for gitgutter, lsp, etc
set autoindent smartindent           " autoindent
set expandtab tabstop=4 shiftwidth=4 " tabs to spaces, default 4
set termguicolors                    " Enable 24-big RGB

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
map <leader>tt :split term://zsh<CR><C-\><C-n><C-w>k
map <leader>tp :split term://zsh<CR>ipython<CR><C-\><C-n><C-w>k
map <leader>tr :split term://zsh<CR>iradian --no-history<CR><C-\><C-n><C-w>k

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
    \ <leader>mp :w! \| !pandoc "%" --pdf-engine=xelatex -o "%:r.pdf"<CR>
  
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

" Pre-load settings for certain plugins
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
  Plug 'lifepillar/vim-gruvbox8'                      " theme
  Plug 'ryanoasis/vim-devicons'                       " Required: Nerd Font
  Plug 'Yggdroot/indentLine'                          " Visual line indents
  Plug 'norcalli/nvim-colorizer.lua'                  " Highlight hex colors
  Plug 'sunjon/shade.nvim'                            " Dim inactive windows
  Plug 'ryanoasis/vim-devicons'                       " Icons, always load last
call plug#end()

"----------------------------- nvim-colorizer.lua ------------------------------
lua require'colorizer'.setup()

"---------------------------------- coq_nvim -----------------------------------
let g:coq_settings = {
  \ 'auto_start': v:true, 
  \ 'keymap.recommended': v:false,
  \ 'keymap.jump_to_mark': ''
\ }
"
" Keybindings
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"

"------------------------------ vim-sendtowindow -------------------------------
let g:sendtowindow_use_defaults=0
nmap <A-Space> <Plug>SendDown
xmap <A-Space> <Plug>SendDownV
imap <A-Space> <esc><Plug>SendDownV

"---------------------------------- fzf.vim ------------------------------------
nnoremap <leader>/f :Files<CR>
nnoremap <leader>/g :GFiles<CR>
nnoremap <leader>/c :BCommits<CR>
nnoremap <leader>/h :Help<CR>
nnoremap <leader>/s :History<CR>
nnoremap <leader>// :BLines<CR>
nnoremap <leader>/b :Buffers<CR>
nnoremap <leader>/l :Lines<CR>
nnoremap <leader>/m :Maps<CR>
nnoremap <leader>/t :Filetypes<CR>

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
colorscheme gruvbox8
let g:airline_theme = 'gruvbox8'

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
let R_openpdf = 1                  " Only auto-open knit'ed PDFs once

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

"================================ lua configs ==================================
lua require('config')

"========================== Windows-specific configs ===========================
if has("win64") || has("win32") || has("win16")
  exec 'source ' . stdpath("config") . '\win.vim'
endif
