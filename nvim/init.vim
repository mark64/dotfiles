set nocompatible
filetype off
set encoding=utf-8

" initialize Vundle
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')
Plugin 'VundleVim/Vundle.vim'

" appearance
Plugin 'flazz/vim-colorschemes'
Plugin 'szorfein/darkest-space'
Plugin 'vim-airline/vim-airline'
Plugin 'edkolev/tmuxline.vim'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'khzaw/vim-conceal'
Plugin 'KeitaNakamura/tex-conceal.vim'
Plugin 'vim-pandoc/vim-pandoc'

" file management
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'majutsushi/tagbar'
Plugin 'junegunn/fzf'
Plugin 'jreybert/vimagit'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'moll/vim-bbye'

" writing
Plugin 'rhysd/vim-grammarous'
Plugin 'beloglazov/vim-online-thesaurus'
Plugin 'junegunn/goyo.vim'

" syntax
Plugin 'vim-latex/vim-latex'
Plugin 'rust-lang/rust.vim'
Plugin 'kballard/vim-swift'
Plugin 'Shougo/neco-syntax'
Plugin 'dag/vim-fish'

" completion
Plugin 'maralla/completor.vim'
Plugin 'Shougo/neco-vim'
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'vim-pandoc/vim-pandoc-syntax'
"Plugin 'maralla/completor-swift'
"Plugin 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
"Plugin 'zchee/deoplete-clang'
"Plugin 'zchee/deoplete-jedi'
"Plugin 'sebastianmarkow/deoplete-rust'
"Plugin 'fszymanski/deoplete-abook'
"Plugin 'landaire/deoplete-swift'
"Plugin 'SevereOverfl0w/deoplete-github'

" makers and syntax checkers
Plugin 'vim-syntastic/syntastic'
Plugin 'Valloric/ListToggle'
Plugin 'davidhalter/jedi-vim'
Plugin 'racer-rust/vim-racer'
"Plugin 'neomake/neomake'
"Plugin 'Shougo/neoinclude.vim'

" deliminator and spacing helpers
Plugin 'vim-scripts/HTML-AutoCloseTag'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-surround'

" git
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'
Plugin 'airblade/vim-gitgutter'

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
Plugin 'euclio/vim-markdown-composer', {'do': function('VimMarkdownBuild')}
"Plugin 'emgram769/vim-multiuser'
call vundle#end()

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

tnoremap `` <C-\><C-n>
autocmd BufWinEnter,WinEnter term://* startinsert

inoremap <M-h> <Esc><C-w>h
inoremap <M-j> <Esc><C-w>j
inoremap <M-k> <Esc><C-w>k
inoremap <M-l> <Esc><C-w>l
noremap <M-h> <C-w>h
noremap <M-j> <C-w>j
noremap <M-k> <C-w>k
noremap <M-l> <C-w>l
tnoremap <M-h> <C-\><C-n><C-w>h
tnoremap <M-j> <C-\><C-n><C-w>j
tnoremap <M-k> <C-\><C-n><C-w>k
tnoremap <M-l> <C-\><C-n><C-w>l

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set termguicolors
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

syntax enable
set visualbell
"set noerrorbells
set pastetoggle=<F2>
set switchbuf=newtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=0
set copyindent
set breakindent
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
set display=truncate
set splitright
set splitbelow
set history=300
set wildmenu
set scrolloff=10
let c_comment_strings=1
set hlsearch
set incsearch
nnoremap <CR> :noh<CR>:<BS>

" stupid autograder style checking
autocmd FileType java call CS61BMode()
function! CS61BMode()
	set expandtab
endfunction

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
" let g:grammarous#default_comments_only_filetypes = {
"	\'*' : 1, 'help' : 0, 'markdown' : 0, 'text' : 0, 'tex' : 0,
"	\ }
" let g:grammarous#disabled_rules = {
"	\ '*' : ['WHITESPACE_RULE', 'EN_QUOTES'],
"	\ 'help' : ['WHITESPACE_RULE', 'EN_QUOTES', 'SENTENCE_WHITESPACE', 'UPPERCASE_SENTENCE_START'],
"	\ }
let g:grammarous#use_vim_spelllang = 1

" vim-racer plugin
let g:racer_cmd = "~/.cargo/bin/racer"
let g:racer_experimental_completer = 1

" rust.vim plugin
let g:rustfmt_autosave = 1

" completer.vim plugin
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
let g:completor_python_binary = '/usr/bin/python3'
let g:completor_racer_binary = '~/.cargo/bin/racer'
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
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
nmap <F5> <Plug>(JavaComplete-Imports-Add)
imap <F5> <Plug>(JavaComplete-Imports-Add)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

" vim-pandoc plugin
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#textwidth = 80
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
"let g:markdown_composer_autostart=0
"let g:markdown_composer_external_renderer='pandoc -f markdown -t html --mathjax'
"let g:markdown_composer_refresh_rate=400

" neomake plugin
"call neomake#configure#automake('nrw')
autocmd FileType c,cpp let b:neomake_enabled_makers = ['make', 'clangchec']
"let g:neomake_enabled_makers = ['clangcheck', 'gcc', 'jedi', 'racer']
let g:neomake_cpp_enabled_makers = ['clangcheck']
let g:neomake_c_enabled_makers = ['clangcheck']

" deoplete plugin
let g:deoplete#enable_at_startup = 1
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
if has("patch-7.4.314")
	set shortmess+=c
endif

" deoplete-clang plugin
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-6.0/lib/libclang.so.1'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'

" deoplete-rust plugin
let g:deoplete#sources#rust#racer_binary = $HOME.'/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path=$HOME.'/.local/share/rust/rust/src'
let g:deoplete#sources#rust#show_duplicates = 1
let g:deoplete#sources#rust#disable_keymap = 1
let g:deoplete#sources#rust#documentation_max_height = 20

" deoplete-github plugin
"let g:deoplete#sources#gitcommit=['github']
"let g:deoplete#keyword_patterns = {}
"let g:deoplete#keyword_patterns.gitcommit = '.+'
"call deoplete#util#set_pattern(
"  \ g:deoplete#omni#input_patterns,
"  \ 'gitcommit', [g:deoplete#keyword_patterns.gitcommit])

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
