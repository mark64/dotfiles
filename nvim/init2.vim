Plug 'KeitaNakamura/tex-conceal.vim', {'for': ['tex', 'pandoc']}

" other
Plug 'ciaranm/securemodelines'

filetype plugin indent on

"set noerrorbells
set wildmenu
let c_comment_strings=1

" set shiftwidth for C-style files
autocmd FileType c,cpp,proto setlocal tabstop=2 shiftwidth=2

" set tabs for Makefiles
autocmd FileType make setlocal tabstop=4 shiftwidth=4 noexpandtab

" vim-clang-format plugin
autocmd FileType c,cpp,java,proto ClangFormatAutoEnable

" Prevent leaking secrets
au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
au BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile
au BufNewFile,BufRead /var/tmp/* setlocal noswapfile nobackup noundofile

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
