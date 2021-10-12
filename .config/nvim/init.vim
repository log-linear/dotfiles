" General settings ===========================================================
let mapleader=" "          " remap <leader>
set cursorline             " Cursor line highlight
set showcmd                " show commands in status line
filetype plugin indent on  " filetype detection
set notimeout              " No key sequence timeout
set clipboard+=unnamedplus " yank to system clipboard via wl-clipboard or xclip
set splitbelow splitright  " Splits open at the bottom and right
set mouse=nv               " Enable mouse support
set scrolloff=3            " Always show one line above/below character
set sidescroll=3           " Ditto for horizontal scrolling
set number relativenumber  " Relative line numbers
set hidden                 " Allow switching buffers before saving
set signcolumn=auto:9      " sign column for gitgutter, coc, etc
set cmdheight=2            " Give more space for displaying messages.
set nobackup               " Fix breakages with certain coc lsps
set nowritebackup          " Fix breakages with certain coc lsps
set updatetime=300         " Reduce coc.nvim lag
set shortmess+=c           " Don't pass messages to |ins-completion-menu|.
set autoindent smartindent " autoindent

" tabs to spaces
set expandtab
set tabstop=4
set shiftwidth=4

" search tweaks - highlighting, semi-case-insensitive search, etc
set incsearch
set showmatch
set hlsearch
set ignorecase
set smartcase

" Visual line guide at 80 characters
set colorcolumn=80
highlight ColorColumn ctermbg=238

" Auto-insert when navigating to terminal windows
au WinEnter term://* :startinsert

" Esc/Ctrl+[ clears last search highlighting
noremap <esc> :noh<CR>
noremap <C-[> :noh<CR>

" Remap split navigation to ALTR + hjkl
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l

" Remap split adjustments to ALT + HJKL
nnoremap <silent> <A-H> :vertical resize +3<CR>
nnoremap <silent> <A-L> :vertical resize -3<CR>
nnoremap <silent> <A-K> :resize -3<CR>
nnoremap <silent> <A-J> :resize +3<CR>

tnoremap <silent> <A-H> <C-\><C-n>:vertical resize +3<CR>a
tnoremap <silent> <A-L> <C-\><C-n>:vertical resize -3<CR>a
tnoremap <silent> <A-K> <C-\><C-n>:resize -3<CR>a
tnoremap <silent> <A-J> <C-\><C-n>:resize +3<CR>a

" Alt + q to close windows
nnoremap <A-q> :q<CR>
tnoremap <A-q> <C-\><C-n>:q<CR>

" Buffer navigation/management
nnoremap <A-d> :bn <BAR> bd #<CR>
nnoremap <A-n> :bn<CR>
nnoremap <A-p> :bp<CR>
nnoremap <A-s> :split<CR>

" Start terminals
map <Leader>tt :split term://zsh<CR><C-\><C-n><C-w>k
map <Leader>tp :split term://zsh<CR>ipython<CR><C-\><C-n><C-w>k
map <Leader>tr :split term://zsh<CR>iradian --no-history<CR><C-\><C-n><C-w>k

" Disable ex mode
nnoremap Q <Nop>

" Filetype-specific settings =================================================

" R 
augroup r_conf
  au!
  " assignment + pipe maps
  au FileType r,rmd nnoremap <A--> a<space><-<space>
  au FileType r,rmd nnoremap <A-_> a<space>\|><space>
  au FileType r,rmd inoremap <A--> <space><-<space>
  au FileType r,rmd inoremap <A-_> <space>\|><space>
  au FileType r,rmd tnoremap <A--> <space><-<space>
  au FileType r,rmd tnoremap <A-_> <space>\|><space>
  " binary operators maps
  au FileType r,rmd inoremap ;in %in%
  au FileType r,rmd inoremap ;; %%
  au FileType r,rmd inoremap ;/ %/%
  au FileType r,rmd inoremap :* %*%
  au FileType r,rmd inoremap ;* %*%
  au FileType r,rmd inoremap ;o %o%
  au FileType r,rmd inoremap ;x %x%
  au FileType r,rmd tnoremap ;in %in%
  au FileType r,rmd tnoremap ;; %%
  au FileType r,rmd tnoremap ;/ %/%
  au FileType r,rmd tnoremap :* %*%
  au FileType r,rmd tnoremap ;* %*%
  au FileType r,rmd tnoremap ;o %o%
  au FileType r,rmd tnoremap ;x %x%
  " adjust tab widths
  au FileType r,rmd setlocal expandtab shiftwidth=2 tabstop=2
  au FileType r,rmd setlocal autoindent cindent
augroup END

" Shell
au FileType sh setlocal expandtab shiftwidth=2 tabstop=2

" Markdown
augroup md_conf
  au FileType markdown setlocal expandtab shiftwidth=2 tabstop=2
  " Run markdown preview, requires mlp python package
  au FileType markdown nmap <leader>mlp :call jobstart('mlp '.expand('%'))<CR>
  " Convert md to html, pdf, or docx using pandoc
  au FileType markdown nmap <leader>mh :w! \| !pandoc "%" -o "%:r.html"<CR>
  au FileType markdown nmap <leader>mw :w! \| !pandoc "%" -o "%:r.docx"<CR>
  au FileType markdown 
    \ nmap <leader>mp :w! \| !pandoc "%" --pdf-engine=xelatex -o "%:r.pdf"<CR>
augroup END

" Run current python file
au FileType python nmap <leader>py :w! \| !python %<CR>

" Use actual tabs in tsv files
au BufEnter *.tsv setlocal noexpandtab

" Plugins ====================================================================

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
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " completion, linting, etc
  Plug 'tpope/vim-commentary'                     " easy code commenting
  Plug 'jalvesaq/Nvim-R'                          " R support
  Plug 'mhinz/vim-signify'                        " line-by-line git diff marks
  Plug 'tpope/vim-fugitive'                       " git integration
  Plug 'karoliskoncevicius/vim-sendtowindow'      " Basic REPLing
  Plug 'tpope/vim-surround'                       " surround text objects
  Plug 'tpope/vim-repeat'                         " Use . to repeat plugin cmds
  Plug 'mhinz/vim-startify'                       " fancy startup menu
  Plug 'ferrine/md-img-paste.vim'                 " Paste images into md files
  Plug 'junegunn/vim-easy-align'                  " Text alignment
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " Fuzzy Finder
  Plug 'junegunn/fzf.vim'                         " fzf convenience functions

  " Visuals
  Plug 'sheerun/vim-polyglot'                     " General syntax highlighting
  Plug 'vim-airline/vim-airline'                  " status bar
  Plug 'junegunn/goyo.vim'                        " zen mode
  Plug 'morhetz/gruvbox'                          " theme
  Plug 'ryanoasis/vim-devicons'                   " Required: Nerd Font 
  Plug 'Yggdroot/indentLine'                      " Visual line indents
  Plug 'ryanoasis/vim-devicons'                   " Always load last
call plug#end()

" vim-sendtowindow -----------------------------------------------------------
let g:sendtowindow_use_defaults=0
nmap <Leader><Leader> <Plug>SendDown
xmap <Leader><Leader> <Plug>SendDownV

" fzf.vim --------------------------------------------------------------------
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

" vim-easy-align -------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" md-img-paste ---------------------------------------------------------------
au FileType markdown 
  \ nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>

" vim-airline ----------------------------------------------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" indentline -----------------------------------------------------------------
let g:indentLine_char = '▏'

" gruvbox --------------------------------------------------------------------
colorscheme gruvbox
let g:airline_theme = 'gruvbox'

" Goyo -----------------------------------------------------------------------
map <leader>z :Goyo \| set linebreak<CR>

" Nvim-R ---------------------------------------------------------------------
let R_auto_start = 2  " Auto start on all .R/.Rmd files
let R_assign = 0  " Disable assignment operator in favor of filetype maps
let R_min_editor_width = 80  " set a minimum source editor width
let R_objbr_place = 'script,right'  " Open obj explorer on right
let R_objbr_opendf = 0  " Don't expand a dataframe to show columns by default
let R_pdfviewer = 'zathura'  " zathura as default PDF reader
let R_csv_app = 'terminal:vd'  " Use visidata as data.frame/matrix viewer
let R_esc_term = 0  " Don't use <Esc> or <C-[> to exit terminal mode
let r_indent_align_args = 0  " Disable weird indenting rules
let R_rconsole_width = 1000  " Ensure console splits below
let R_objbr_allnames = 1  " Show hidden objects 
let R_openpdf = 1

" Use radian console
let R_app = 'radian'
let R_cmd = 'R'
let R_hl_term = 0
let R_args = ['--no-history']
let R_bracketed_paste = 1

" Press return to send lines and selection to R console
vmap <A-Space> <Plug>RDSendSelection
nmap <A-Space> <Plug>RDSendLine
imap <A-Space> <esc><Plug>RDSendLine<CR>

" vim-signify ----------------------------------------------------------------
map <leader>uh :SignifyHunkUndo<CR>

" vim-startify ---------------------------------------------------------------
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'files',     'header': ['   Recent']            },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" coc.nvim -------------------------------------------------------------------

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

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

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
nmap <leader>cf  <Plug>(coc-fix-current)

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

" Helper function + mapping to disable COC on the fly
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

" Windows-specific configs ===================================================
if has("win64") || has("win32") || has("win16")
  exec 'source ' . stdpath("config") . '\win.vim'
endif
