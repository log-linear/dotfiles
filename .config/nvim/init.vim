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

"============================= Filetype settings ===============================
augroup ft_conf
  au!
  au FileType vim setlocal tw=0          " No text-wrapping
  au BufEnter *.tsv setlocal noexpandtab " Use actual tabs in tsvs

  " Shell
  au FileType sh,bash,zsh setlocal expandtab shiftwidth=2 tabstop=2
  au FileType sh,bash,zsh inoremap ;s $
  au FileType sh,bash,zsh nmap <leader>cc :w<CR> :!%:p<CR>
  
  " R
  au FileType r,rmd setlocal expandtab shiftwidth=2 tabstop=2 autoindent cindent
  let g:r_indent_op_pattern = get(g:, 'r_indent_op_pattern',
      \ '\(&\||\|+\|-\|\*\|/\|=\|\~\|%\|->\||>\)\s*$')  " Support |> indenting
  for mapcmd in ['inoremap', 'tnoremap']
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
  au FileType r nmap <leader>cc :w<CR> :!Rscript %:p<CR>
  au FileType rmd nmap <leader>cc :w<CR> :!Rscript -e "rmarkdown::render(r'(%:p)')"<CR>

  " Markdown
  au BufEnter *.md setlocal conceallevel=0
  au BufEnter *.rmd setlocal conceallevel=0
  au FileType markdown setlocal expandtab shiftwidth=4 tabstop=4
  " Run markdown preview, requires mlp python package
  au FileType markdown nmap <leader>mlp :call jobstart('mlp '.expand('%'))<CR>
  " Convert md to html, pdf, or docx using pandoc
  au FileType markdown nmap <leader>ch :w! \| !pandoc "%" -o "%:r.html"<CR>
  au FileType markdown nmap <leader>cw :w! \| !pandoc "%" -o "%:r.docx"<CR>
  au FileType markdown nmap <leader>cp :w! \| !pandoc "%" -o "%:r.pdf"<CR>
  au FileType markdown nmap <leader>cx :w! \| !pandoc "%" --pdf-engine=xelatex -o "%:r.pdf"<CR>
  
  " TeX
  au FileType tex nmap <leader>cp :w<cr> :!pdflatex %:r.tex && rm %:r.aux %:r.log<cr>
  au FileType tex nmap <leader>cx :w<cr> :!xelatex %:r.tex && rm %:r.aux %:r.log<cr>

  " Python
  au FileType python nmap <leader>cc :w<CR> :!python %<CR>
augroup END

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
nnoremap <leader>B 0D80A=<esc>0:execute "normal! 0r" . &commentstring[0]<cr>
nnoremap <leader>b 0D80A-<esc>0:execute "normal! 0r" . &commentstring[0]<cr>
nnoremap <leader>H :center<cr>2hv0r=A<space><esc>40A=<esc>d80<bar>0:execute "normal! 0r" . &commentstring[0]<cr><esc>
nnoremap <leader>h :center<cr>2hv0r-A<space><esc>40A-<esc>d80<bar>0:execute "normal! 0r" . &commentstring[0]<cr><esc>

" Disable ex mode
nnoremap Q <Nop>

" Open compiled documents in external programs
nmap <leader>op :!xdg-open %:r.pdf > /dev/null 2>&1 &<cr><cr>
nmap <leader>oh :!xdg-open %:r.html > /dev/null 2>&1 &<cr><cr>
nmap <leader>od :!xdg-open %:r.docx > /dev/null 2>&1 &<cr><cr>

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
let g:neoterm_default_mod = 'botright'
nmap <A-CR> <Plug>(neoterm-repl-send)
vmap <A-CR> <Plug>(neoterm-repl-send)
imap <A-CR> <Esc><Plug>(neoterm-repl-send)
let g:neoterm_automap_keys = ''  " Remove default mapping for :Tmap
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
nnoremap <leader>/w :Windows<CR>

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
