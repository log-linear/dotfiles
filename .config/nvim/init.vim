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
nnoremap <leader>B D80A=<esc>0:execute "normal! 0r" . &commentstring[0]<cr>
nnoremap <leader>b D80A-<esc>0:execute "normal! 0r" . &commentstring[0]<cr>
nnoremap <leader>H :center<cr>2hv0r=A<space><esc>40A=<esc>d80<bar>0:execute "normal! 0r" . &commentstring[0]<cr><esc>
nnoremap <leader>h :center<cr>2hv0r-A<space><esc>40A-<esc>d80<bar>0:execute "normal! 0r" . &commentstring[0]<cr><esc>

" Start terminals
map <Leader>tt :split term://zsh<CR><C-\><C-n><C-w>k
map <Leader>tp :split term://zsh<CR>ipython<CR><C-\><C-n><C-w>k
map <Leader>tr :split term://zsh<CR>iradian --no-history<CR><C-\><C-n><C-w>k

" Disable ex mode
nnoremap Q <Nop>

"====================== Filetype/buffer/window settings ========================
au FileType sh,bash,zsh setlocal expandtab shiftwidth=2 tabstop=2 " Shell tabs
au FileType vim setlocal tw=0          " No text-wrapping
au BufEnter *.tsv setlocal noexpandtab " Use actual tabs in tsvs
au WinEnter term://* :startinsert      " Always insert mode in terminals

" R settings
augroup r_conf
  au!
  au FileType r,rmd setlocal expandtab shiftwidth=2 tabstop=2 autoindent cindent
  for mapcmd in ['inoremap', 'tnoremap']
    " map assignment + pipe operators
    execute 'au FileType r,rmd ' . mapcmd . ' -- <space><-<space>'
    execute 'au FileType r,rmd ' . mapcmd . ' >> <space>\|><space>'
    execute 'au FileType r,rmd ' . mapcmd . ' ;m <space>%>%<space>'
    " map infix operators
    execute 'au FileType r,rmd ' . mapcmd . ' ;in %in%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;; %%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;/ %/%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;* %*%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;o %o%'
    execute 'au FileType r,rmd ' . mapcmd . ' ;x %x%'
  endfor
augroup END

" Markdown
augroup md_conf
  au FileType markdown setlocal expandtab shiftwidth=4 tabstop=4
  " Run markdown preview, requires mlp python package
  au FileType markdown nmap <leader>mlp :call jobstart('mlp '.expand('%'))<CR>
  " Convert md to html, pdf, or docx using pandoc
  au FileType markdown nmap <leader>mh :w! \| !pandoc "%" -o "%:r.html"<CR>
  au FileType markdown nmap <leader>mw :w! \| !pandoc "%" -o "%:r.docx"<CR>
  au FileType markdown nmap 
    \<leader>mp :w! \| !pandoc "%" --pdf-engine=xelatex -o "%:r.pdf"<CR>
augroup END

" Run current python file
au FileType python nmap <leader>py :w! \| !python %<CR>

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
  Plug 'neoclide/coc.nvim', {'branch': 'release'}     " completion, linting, etc
  Plug 'tpope/vim-commentary'                         " easy code commenting
  Plug 'jalvesaq/Nvim-R'                              " R support
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

  " Visuals
  Plug 'sheerun/vim-polyglot'                         " syntax highlighting
  Plug 'vim-airline/vim-airline'                      " status bar
  Plug 'junegunn/goyo.vim'                            " zen mode
  Plug 'morhetz/gruvbox'                              " theme
  Plug 'ryanoasis/vim-devicons'                       " Required: Nerd Font
  Plug 'Yggdroot/indentLine'                          " Visual line indents
  Plug 'ryanoasis/vim-devicons'                       " Always load last
call plug#end()

"------------------------------ vim-sendtowindow -------------------------------
let g:sendtowindow_use_defaults=0
nmap <Leader><Leader> <Plug>SendDown
xmap <Leader><Leader> <Plug>SendDownV

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
vmap <C-Space> <Plug>RDSendSelection
nmap <C-Space> <Plug>RDSendLine
imap <C-Space> <esc><Plug>RDSendLine<CR>

"-------------------------------- vim-signify ----------------------------------
map <leader>uh :SignifyHunkUndo<CR>

"-------------------------------- vim-startify ---------------------------------
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions'] },
      \ { 'type': 'files',     'header': ['   Recent']   },
      \ { 'type': 'commands',  'header': ['   Commands'] },
      \ ]

"---------------------------------- coc.nvim -----------------------------------
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location 
" list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
au CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

augroup mygroup
  au!
  " Setup formatexpr specified filetype(s).
  au FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>af  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> 
    \ coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> 
    \ coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> 
    \ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> 
    \ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> 
    \ coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> 
    \ coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR 
  \ :call CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Helper function + mapping to disable Coc on the fly
function! CocToggle()
  if g:coc_enabled
    CocDisable
  else
    CocEnable
  endif
endfunction
command! CocToggle :call CocToggle()
nmap <leader>, :CocToggle<CR>
nmap <leader>. :CocRestart<CR>

"========================== Windows-specific configs ===========================
if has("win64") || has("win32") || has("win16")
  exec 'source ' . stdpath("config") . '\win.vim'
endif
