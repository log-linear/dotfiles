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
set termguicolors                    " Enable 24-bit RGB
set list lcs=tab:\▏\                 " Show tab indentlines
au WinEnter term://* :startinsert    " Always enter terminals in insert mode

" search tweaks - highlighting, semi-case-insensitive search, etc
set incsearch showmatch hlsearch ignorecase smartcase

" Visual line guide at 80 characters
set colorcolumn=80
highlight ColorColumn ctermbg=238

" netrw
let g:netrw_liststyle = 3                                 " Default to tree-view
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'  " relative line nums
let g:netrw_winsize = 25

"============================= Filetype settings ===============================
augroup ft_conf
  au!
"----------------------------------- Shell -------------------------------------
  au FileType sh,bash,zsh setlocal expandtab shiftwidth=2 tabstop=2
  au FileType sh,bash,zsh imap ;s $
"------------------------------------- R ---------------------------------------
  au FileType r,rmd setlocal expandtab shiftwidth=2 tabstop=2 autoindent cindent
  let g:r_indent_op_pattern = get(g:, 'r_indent_op_pattern',
      \ '\(&\||\|+\|-\|\*\|/\|=\|\~\|%\|->\||>\)\s*$')  " Support |> indenting
  for mapcmd in ['imap', 'tmap']
    execute 'au FileType r,rmd ' . mapcmd . ' ;; <-'
    execute 'au FileType r,rmd ' . mapcmd . ' ;n \|>'
    execute 'au FileType r,rmd ' . mapcmd . ' ;m %>%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;in %in%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;: %%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;/ %/%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;* %*%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;o %o%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;x %x%'
  endfor
  au FileType rmd imap ;c ```{}<CR>```<esc>k$i
  au FileType rmd imap ;C ```{r}<CR>```<esc>O
"---------------------------------- Markdown -----------------------------------
  let g:markdown_fenced_languages = ['python', 'r', 'sh', 'bash', 'zsh', 
    \ 'powershell=ps1', 'sql', 'json', 'html']
  au BufEnter *.md setlocal conceallevel=0
  au BufEnter *.rmd setlocal conceallevel=0
  au FileType markdown setlocal expandtab shiftwidth=4 tabstop=4
  au FileType markdown imap ;c ```<CR>```<esc>k$a
  au FileType markdown imap ;C ```<CR>```<esc>O
  au FileType markdown,rmd imap ;e **<left>
  au FileType markdown,rmd imap ;H <esc>yypv$r=o
  au FileType markdown,rmd imap ;h <esc>yypv$r-o
"------------------------------------ TeX --------------------------------------
  let g:tex_conceal = 0
  au FileType tex imap ;; \
  au FileType tex imap ;s $
"------------------------------- Miscellaneous ---------------------------------
  au FileType vim setlocal tw=0 shiftwidth=2 tabstop=2
  au BufEnter *.tsv setlocal noexpandtab
augroup END

"==================================== Maps =====================================
" Esc/Ctrl+[ clears last search highlighting
nmap <esc> :noh<CR>
nmap <C-[> :noh<CR>

" Multi-mode mappings
for mapcmd in ['nmap', 'imap', 'vmap', 'tmap']
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
  execute mapcmd . ' <A-Q> <C-\><C-n>:q!<CR>'
  " netrw
  execute mapcmd . ' <A-f> <C-\><C-n>:Vexplore<CR>'
  " Buffer navigation/management
  execute mapcmd . ' <A-d> <C-\><C-n>:bn <BAR> bd #<CR>'
  execute mapcmd . ' <A-n> <C-\><C-n>:bn<CR>'
  execute mapcmd . ' <A-p> <C-\><C-n>:bp<CR>'
  execute mapcmd . ' <A-s> <C-\><C-n>:split<CR>'
  execute mapcmd . ' <A-v> <C-\><C-n>:vsplit<CR>'
endfor

" Headers
nmap <leader>B 0D80A=<esc>0:execute "normal! 0r" . &commentstring[0]<cr>
nmap <leader>b 0D80A-<esc>0:execute "normal! 0r" . &commentstring[0]<cr>
nmap <leader>H :center<cr>2hv0r=A<space><esc>40A=<esc>d80<bar>0:execute "normal! 0r" . &commentstring[0]<cr><esc>
nmap <leader>h :center<cr>2hv0r-A<space><esc>40A-<esc>d80<bar>0:execute "normal! 0r" . &commentstring[0]<cr><esc>

" Disable ex mode
nmap Q <Nop>

" Compile code/documents, etc
nmap <leader>cc :w<CR> :execute '!compile "%:p"'<CR>
au FileType tex,markdown nmap <leader>cc :w<CR> :execute '!compile "%:p" "'.input('What type of document would you like to compile? Choose from `h` for html, `p` for pdf, `d` for docx, or `x` for a xelatex pdf: ').'"'<CR>

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

" Load plugins
call plug#begin(stdpath("config") . '/plugged')
  " Functionality
  Plug 'tpope/vim-commentary'                         " easy code commenting
  Plug 'tpope/vim-fugitive'                           " git integration
  Plug 'mhinz/vim-signify'                            " git diff markers
  Plug 'kassio/neoterm'                               " Basic REPLing
  Plug 'tpope/vim-surround'                           " surround text objects
  Plug 'tpope/vim-repeat'                             " repeat plugin commands
  Plug 'ferrine/md-img-paste.vim'                     " Paste images to md files
  Plug 'junegunn/vim-easy-align'                      " Text alignment
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy Finder
  Plug 'junegunn/fzf.vim'                             " fzf functions
  " IDE features
  Plug 'neovim/nvim-lspconfig'                        " Language Server Protocol
  Plug 'ray-x/lsp_signature.nvim'                     " Function param popup
  Plug 'ms-jpq/coq_nvim', { 'branch': 'coq' }         " Auto-completion
  Plug 'nvim-treesitter/nvim-treesitter',             " syntax highlighting, etc
    \ {'do': ':TSUpdate'}  " Update on start
  " Aesthetics/visual aids
  Plug 'vim-airline/vim-airline'                      " status bar
  Plug 'lifepillar/vim-gruvbox8'                      " theme
  Plug 'Yggdroot/indentLine'                          " Visual line indents
  Plug 'norcalli/nvim-colorizer.lua'                  " Highlight hex colors
  Plug 'sunjon/shade.nvim'                            " Dim inactive windows
  Plug 'ryanoasis/vim-devicons'                       " Icons, always load last
call plug#end()

"---------------------------------- coq_nvim -----------------------------------
let g:coq_settings = {
  \ 'auto_start': v:true, 
  \ 'keymap.recommended': v:false,
  \ 'keymap.jump_to_mark': ''
\ }

" Keybindings
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"

"---------------------------------- neoterm ------------------------------------
nmap <A-CR> <Plug>(neoterm-repl-send)
vmap <A-CR> <Plug>(neoterm-repl-send)
imap <A-CR> <Esc><Plug>(neoterm-repl-send)
let g:neoterm_default_mod = 'botright'
let g:neoterm_automap_keys = '<Nop>'  " Remove default mapping for :Tmap
let g:neoterm_repl_r = 'radian'
let g:neoterm_bracketed_paste = 1
let g:neoterm_direct_open_repl = 1
let g:neoterm_autoinsert = 1
let g:neoterm_autoscroll = 1

" Start terminals
map <leader>tt :Tnew<CR><C-\><C-n><C-w>k
map <leader>tp :T python<CR><C-\><C-n><C-w>k
map <leader>tr :T radian<CR><C-\><C-n><C-w>k

"---------------------------------- fzf.vim ------------------------------------
nmap <leader>/f :Files<CR>
nmap <leader>/g :GFiles<CR>
nmap <leader>/c :BCommits<CR>
nmap <leader>/h :Help<CR>
nmap <leader>/s :History<CR>
nmap <leader>// :BLines<CR>
nmap <leader>/b :Buffers<CR>
nmap <leader>/l :Lines<CR>
nmap <leader>/m :Maps<CR>
nmap <leader>/t :Filetypes<CR>
nmap <leader>/w :Windows<CR>

"------------------------------- vim-easy-align --------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"-------------------------------- md-img-paste ---------------------------------
au FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>

"-------------------------------- vim-airline ----------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

"--------------------------------- indentline ----------------------------------
let g:indentLine_char = '▏'

"---------------------------------- gruvbox ------------------------------------
colorscheme gruvbox8
let g:airline_theme = 'gruvbox8'
hi Function guifg=#98971a guibg=NONE gui=bold cterm=bold  " function hi group

"-------------------------------- vim-signify ----------------------------------
map <leader>uh :SignifyHunkUndo<CR>

"================================ lua configs ==================================
lua require('config')

"========================== Windows-specific configs ===========================
if has("win64") || has("win32") || has("win16")
  exec 'source ' . stdpath("config") . '\win.vim'
endif
