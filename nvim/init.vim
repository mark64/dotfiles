set nocompatible
filetype off
set encoding=utf-8

if has('nvim') && empty(glob($XDG_DATA_HOME . '/nvim/site/autoload/plug.vim'))
    silent !curl -fLo $XDG_DATA_HOME'/nvim/site/autoload/plug.vim' --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $XDG_CONFIG_HOME.'/nvim/init.vim'
else
    if !has('nvim') && empty(glob($HOME.'/.vim/autoload/plug.vim'))
        silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $HOME/.vimrc
    endif
endif

" initialize Vundle
call plug#begin($XDG_DATA_HOME . '/nvim/plugged')
" appearance
Plug 'flazz/vim-colorschemes'
"Plug 'szorfein/darkest-space'
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'vim-pandoc/vim-pandoc'

" file management
Plug 'scrooloose/nerdtree', {'on':  'NERDTreeFocus' }
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeFocus'}
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', {'do': './install --all --xdg'}
Plug 'moll/vim-bbye'

" writing
Plug 'junegunn/goyo.vim'

" syntax
Plug 'vim-latex/vim-latex'
Plug 'rust-lang/rust.vim'
Plug 'Shougo/neco-syntax'
Plug 'rhysd/vim-clang-format'

" completion
if has('nvim') || (has('python3') && has('lambda') && has('timers') && has('job'))
Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --clang-tidy --rust-completer --java-completer --go-completer'}
Plug 'Valloric/ListToggle'
endif
Plug 'Shougo/neco-vim'
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': 'pandoc'}

" makers and syntax checkers
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'racer-rust/vim-racer', {'for': 'rust'}

" deliminator and spacing helpers
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-surround'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'jreybert/vimagit'

" cool real-time markdown rendering
" vim-markdown-composer plugin
function! VimMarkdownBuild(info)
    if a:info.status != 'unchanged' || a:info.force
        if has('nvim')
            !cargo build --release
        else
            !cargo build --release --no-default-features --features json-rpc
        endif
    endif
endfunction
Plug 'euclio/vim-markdown-composer', {'do': function('VimMarkdownBuild')}
call plug#end()

filetype plugin indent on
set nu

nnoremap ; :
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
imap fd <C-y>
inoremap jk <Esc>
nnoremap Q :Bdelete<CR>

inoremap <M-h> <Esc><C-w>h
inoremap <M-j> <Esc><C-w>j
inoremap <M-k> <Esc><C-w>k
inoremap <M-l> <Esc><C-w>l
noremap <M-h> <C-w>h
noremap <M-j> <C-w>j
noremap <M-k> <C-w>k
noremap <M-l> <C-w>l
if has('nvim')
    tnoremap <M-h> <C-\><C-n><C-w>h
    tnoremap <M-j> <C-\><C-n><C-w>j
    tnoremap <M-k> <C-\><C-n><C-w>k
    tnoremap <M-l> <C-\><C-n><C-w>l
    tnoremap `` <C-\><C-n>
    autocmd BufWinEnter,WinEnter term://* startinsert
endif

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
if has('nvim') || v:version > 800
    set termguicolors
endif
colorscheme CandyPaper
"colorscheme desert
"colorscheme osx_like
set background=dark
:hi Normal guibg=Black
:hi Title gui=Bold
:hi Title guifg=White
:hi Title cterm=Bold
:hi Title ctermfg=White
:hi Folded guibg=Black
:hi Folded ctermbg=Black
:hi Folded guifg=Gray
:hi Folded ctermfg=Gray
:hi! link Conceal Operator

if has('nvim') || v:version > 800
    set breakindent
    set display=truncate
endif
syntax enable
set visualbell
"set noerrorbells
set pastetoggle=<F2>
set switchbuf=newtab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0
set copyindent
set backspace=2
set laststatus=2
set ruler
set smartcase
set infercase
set wildignorecase
set smartcase
set showcmd
"set showmatch
set hidden
set splitright
set splitbelow
set history=300
set wildmenu
set scrolloff=10
let c_comment_strings=1
set hlsearch
set incsearch
set noequalalways
nnoremap <CR> :noh<CR>:<BS>

" undo file
set undodir=$XDG_DATA_HOME/nvim/undo
set undofile

" restore cursor position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" set shiftwidth for C-style files
autocmd FileType c,cpp setlocal tabstop=2 shiftwidth=2

" set tabs for Makefiles
autocmd FileType make setlocal tabstop=4 shiftwidth=4 noexpandtab

" cscope config
cs add $CSCOPE_DB

" airline plugin
let g:airline_theme='term'
set t_Co=256

" latex plugin
let g:tex_flavor='latex'
let g:Imap_UsePlaceHolders = 0

" tagbar plugin
nnoremap <F9> :TagbarToggle<CR>

" nerdtree plugin
nnoremap <F8> :NERDTreeFocus<CR>

" tmuxline plugin
let g:tmuxline_powerline_separators = 0

" vim-racer plugin
let g:racer_cmd = $XDG_DATA_HOME.'/cargo/bin/racer'

" rust.vim plugin
let g:rustfmt_autosave = 1
let g:rust_recommended_style = 1

" jedi-vim plugin
let g:jedi#use_splits_not_buffers = "right"

" YouCompleteMe plugin
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
let g:ycm_autoclose_preview_window_after_insertion = 1

" syntastic plugin
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

" vim-pandoc plugin
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#textwidth = 100
let g:pandoc#formatting#mode = "hA"
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 1

" Goyo.vim plugin
function! s:goyo_enter()
    let b:quitting = 0
    let b:quitting_bang = 0
    autocmd QuitPre <buffer> let b:quitting = 1
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction
function! s:goyo_leave()
    " Quit Vim if this is the only remaining buffer
    if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if b:quitting_bang
            qa!
        else
            qa
        endif
    endif
endfunction
autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

" vim better whitespace plugin
let g:better_whitespace_filetypes_blacklist=['diff']
autocmd FileType * EnableStripWhitespaceOnSave
autocmd! FileType diff,markdown,pandoc DisableStripWhitespaceOnSave

" vim-markdown-compose plugin
let g:markdown_composer_autostart=0
"let g:markdown_composer_external_renderer='pandoc -f markdown -t html --mathjax'
"let g:markdown_composer_refresh_rate=400

" vim-clang-format plugin
autocmd FileType c,cpp let g:clang_format#auto_format = 1

" writing function
autocmd Filetype gitcommit,text,markdown,help,tex call WriterMode()
function! WriterMode()
    setlocal spell spelllang=en_us
    setlocal formatprg=par
    setlocal complete+=s
    setlocal complete+=k
    setlocal wrap
endfunction
com! WM call WriterMode()
