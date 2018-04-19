set nocompatible
filetype off
set encoding=utf-8

if has('nvim') && empty(glob($XDG_DATA_HOME . '/nvim/site/autoload/plug.vim'))
    silent !curl -fLo $XDG_DATA_HOME'/nvim/site/autoload/plug.vim' --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $XDG_CONFIG_HOME.'/nvim/init.vim'
else
    if !has('nvim') && empty(glob($HOME.'/.vim/site/autoload/plug.vim'))
        silent !curl -fLo '$HOME/.vim/autoload/plug.vim' --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source '$HOME/.vimrc'
    endif
endif

" initialize Vundle
call plug#begin($XDG_DATA_HOME . '/nvim/plugged')
" appearance
Plug 'flazz/vim-colorschemes'
Plug 'szorfein/darkest-space'
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'khzaw/vim-conceal'
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'vim-pandoc/vim-pandoc', {'for': 'pandoc'}

" file management
Plug 'scrooloose/nerdtree', {'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'jreybert/vimagit'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'moll/vim-bbye'

" writing
Plug 'rhysd/vim-grammarous'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'junegunn/goyo.vim'

" syntax
Plug 'vim-latex/vim-latex', {'for': 'tex'}
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'kballard/vim-swift', {'for': 'swift'}
Plug 'Shougo/neco-syntax'
Plug 'dag/vim-fish'

" completion
if has('nvim') || has('python3')
Plug 'maralla/completor.vim'
Plug 'artur-shaik/vim-javacomplete2', {'for': 'java'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' , 'for': 'go'}
endif
Plug 'Shougo/neco-vim'
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': 'pandoc'}
"Plugin 'maralla/completor-swift'
"Plugin 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
"Plugin 'zchee/deoplete-clang'
"Plugin 'zchee/deoplete-jedi'
"Plugin 'sebastianmarkow/deoplete-rust'
"Plugin 'fszymanski/deoplete-abook'
"Plugin 'landaire/deoplete-swift'
"Plugin 'SevereOverfl0w/deoplete-github'

" makers and syntax checkers
Plug 'vim-syntastic/syntastic'
Plug 'Valloric/ListToggle'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'racer-rust/vim-racer', {'for': 'rust'}
"Plugin 'neomake/neomake'
"Plugin 'Shougo/neoinclude.vim'

" deliminator and spacing helpers
Plug 'ntpeters/vim-better-whitespace'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

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
"Plugin 'emgram769/vim-multiuser'
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
":hi! link Conceal Operator

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
nnoremap <CR> :noh<CR>:<BS>

" restore cursor position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" cscope config
cs add $CSCOPE_DB

" airline plugin
let g:airline_theme='term'
set t_Co=256

" latex plugin
let g:tex_flavor='latex'
let g:Imap_UsePlaceHolders = 0

" linuxsty plugin
let g:linuxsty_patterns = ["/linux", "/usr/src/"]

" tagbar plugin
nnoremap <F9> :TagbarToggle<CR>

" nerdtree plugin
nnoremap <F8> :NERDTreeFocus<CR>

" tmuxline plugin
let g:tmuxline_powerline_separators = 0

" vim-grammarous plugin
let g:grammarous#use_vim_spelllang = 1

" vim-racer plugin
let g:racer_cmd = $XDG_DATA_HOME.'/cargo/bin/racer'
let g:racer_experimental_completer = 1

" rust.vim plugin
let g:rustfmt_autosave = 1

" jedi-vim plugin
let g:jedi#use_splits_not_buffers = "right"

" completer.vim plugin
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
let g:completor_python_binary = '/usr/bin/python3'
"let g:completor_racer_binary = $XDG_DATA_HOME.'/cargo/bin/racer'
let g:completer_clang_binary = '/usr/bin/clang'

" syntastic plugin
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_c_checkers = [ "clang_check" ]
let g:syntastic_cpp_checkers = [ "clang_check" ]
let g:syntastic_c_clang_check_post_args = ""
let g:syntastic_cpp_clang_check_post_args = ""

" see :h syntastic-loclist-callback
function! SyntasticCheckHook(errors)
    if !empty(a:errors)
        let g:syntastic_loc_list_height = min([len(a:errors), 10])
    endif
endfunction

" javacomplete2 plugin
autocmd FileType java setlocal omnifunc=javacomplete#Complete

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

" delimitMate plugin
let g:delimitMate_expand_cr = 2
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_inside_quotes = 1
let g:delimitMate_jump_expansion = 1
let g:delimitMate_balance_matchpairs = 1
let g:delimitMate_excluded_ft = ""
let g:delimitMate_insert_eol_marker = 0
inoremap <expr> gg delimitMate#JumpAny()
autocmd FileType python let b:delimitMate_nesting_quotes = ['"']
autocmd FileType c,java,cpp let b:delimitMate_insert_eol_marker = 2
autocmd FileType c,java,cpp let b:delimitMate_eol_marker = ";"

" vim-markdown-compose plugin
let g:markdown_composer_autostart=0
"let g:markdown_composer_external_renderer='pandoc -f markdown -t html --mathjax'
"let g:markdown_composer_refresh_rate=400

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
