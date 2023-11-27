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
Plug 'chiphogg/vim-prototxt'

" autoformat
Plug 'rhysd/vim-clang-format', {'for': ['c', 'cpp', 'java', 'proto']}

" completion
if has('nvim') || (has('python3') && has('lambda') && has('timers') && has('job'))
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'm-pilia/vim-ccls'
    let g:coc_global_extensions = ['coc-cmake', 'coc-git', 'coc-highlight',
                \ 'coc-jedi', 'coc-markdownlint', 'coc-pyright',
                \ 'coc-rust-analyzer', 'coc-sh', 'coc-vimlsp', 'coc-yaml']
endif
Plug 'Shougo/neco-vim'
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': 'pandoc'}

" deliminator and spacing helpers
Plug 'tpope/vim-surround'

" git
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'

" other
Plug 'ciaranm/securemodelines'
call plug#end()

filetype plugin indent on
set nu

set mouse=
nnoremap ; :
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
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
set ttyfast
set lazyredraw
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
autocmd FileType c,cpp,proto setlocal tabstop=2 shiftwidth=2

" set tabs for Makefiles
autocmd FileType make setlocal tabstop=4 shiftwidth=4 noexpandtab

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

" coc.nvim suggestions
"
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" Use tab for trigger completion with characters ahead and navigate.
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
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
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
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
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
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif
" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" coc-highlight plugin
autocmd CursorHold * silent call CocActionAsync('highlight')

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

" vim-markdown-compose plugin
let g:markdown_composer_autostart=1

" vim-clang-format plugin
autocmd FileType c,cpp,java,proto ClangFormatAutoEnable

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
