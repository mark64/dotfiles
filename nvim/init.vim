set nocompatible
"colorscheme CandyPaper
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

" initialize Vim-Plug
call plug#begin($XDG_DATA_HOME . '/nvim/plugged')

" appearance
Plug 'vim-airline/vim-airline'
Plug 'KeitaNakamura/tex-conceal.vim', {'for': ['tex', 'pandoc']}
Plug 'flazz/vim-colorschemes'

" Better shell Ctrl-R
Plug 'junegunn/fzf', {'do': './install --all --xdg'}

" syntax
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-latex/vim-latex'
Plug 'rust-lang/rust.vim'
Plug 'Shougo/neco-syntax'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'vim-scripts/cup.vim'

" autoformat
Plug 'rhysd/vim-clang-format', {'for': ['c', 'cpp', 'java']}
Plug 'ambv/black', {'for': 'python'}

" completion
if has('nvim') || (has('python3') && has('lambda') && has('timers') && has('job'))
"    Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --clang-tidy --rust-completer --java-completer --go-completer'}
    Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --clang-tidy'}
    " YCM is better, except for with rust
    Plug 'maralla/completor.vim', {'for': 'rust'}
endif
Plug 'Shougo/neco-vim'
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': 'pandoc'}

" makers and syntax checkers
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'racer-rust/vim-racer', {'for': 'rust'}
" YCM doesn't have good rust or python checks
Plug 'vim-syntastic/syntastic', {'for': ['rust', 'python']}

" deliminator and spacing helpers
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-surround'

" git
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'

" other
Plug 'ciaranm/securemodelines'
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

if !has('nvim')
    execute "set <M-h>=\eh"
    execute "set <M-j>=\ej"
    execute "set <M-k>=\ek"
    execute "set <M-l>=\el"
endif
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
else
if has('terminal')
    tnoremap `` <C-W>N
    tnoremap <M-h> <C-w>h
    tnoremap <M-j> <C-w>j
    tnoremap <M-k> <C-w>k
    tnoremap <M-l> <C-w>l
endif
endif

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
if has('nvim') || v:version > 800
    set termguicolors
endif
syntax enable
"colorscheme elrond
set background=dark
:hi! link Conceal Operator
:hi! link Conceal Special
:hi Title gui=Bold
:hi Title guifg=White
:hi Title cterm=Bold
:hi Title ctermfg=White
:hi Folded guibg=Black
:hi Folded ctermbg=Black
:hi Folded guifg=Gray
:hi Folded ctermfg=Gray

if has('nvim') || v:version > 800
    set breakindent
    set display=truncate
endif
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
colorscheme molokai_dark
colorscheme detailed
:hi Normal guibg=Black

" undo file
set undodir=$XDG_DATA_HOME/nvim/undo
set undofile

" restore cursor position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" set shiftwidth for C-style files
autocmd FileType c,cpp setlocal tabstop=2 shiftwidth=2

" set tabs for Makefiles
autocmd FileType make setlocal tabstop=4 shiftwidth=4 noexpandtab

" cscope config
"cs add $CSCOPE_DB

" airline plugin
set t_Co=256

" latex plugin
let g:tex_flavor='latex'
let g:Imap_UsePlaceHolders = 0

" vim-racer plugin
let g:racer_cmd = $XDG_DATA_HOME.'/cargo/bin/racer'

" rust.vim plugin
let g:rustfmt_autosave = 1
let g:rust_recommended_style = 1

" jedi-vim plugin
let g:jedi#use_splits_not_buffers = "right"

" completer.vim plugin
let g:completor_complete_options = 'menuone,noselect,preview'

" YouCompleteMe plugin
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_extra_conf_globlist = ['~/repos/berkeley/*', '~/repos/sw/*', '~/repos/astros2/*']
let g:ycm_rust_src_path = $CARGO_HOME.'/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'

" fzf plugin
inoremap <C-f> :FZF<CR>
nnoremap <C-f> :FZF<CR>

" syntastic plugin
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_aggregate_errors = 1

" vim-pandoc plugin
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#textwidth = 100
let g:pandoc#formatting#mode = "hA"
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 1

" vim better whitespace plugin
let g:better_whitespace_filetypes_blacklist=['diff']
autocmd FileType * EnableStripWhitespaceOnSave
autocmd! FileType diff,markdown,pandoc DisableStripWhitespaceOnSave

" vim-markdown-compose plugin
let g:markdown_composer_autostart=1

" vim-clang-format plugin
autocmd FileType c,cpp,java let g:clang_format#auto_format = 1

" Black plugin
let g:black_virtualenv = $XDG_CACHE_HOME.'/black/venv'
let g:black_skip_string_normalization = 1
autocmd FileType python autocmd BufWritePre <buffer> execute ':Black'

" cup.vim plugin
au BufNewFile,BufRead *.cup setf cup

" Prevent leaking secrets
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
au BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile
au BufNewFile,BufRead /var/tmp/* setlocal noswapfile nobackup noundofile

" Hybrid numbering from https://jeffkreeftmeijer.com/vim-number/
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

setlocal spell spelllang=en_us

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
