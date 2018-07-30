set tabstop=4
set shiftwidth=4
syntax on
colorscheme monokai

set ai "Auto indent
set si "Smart indent
set smarttab " Be smart when using tabs ;)
set wrap "Wrap line
set number
set relativenumber
set incsearch
set incsearch " Search as typing
set hlsearch " Highlight search results
set cursorline " Highligt the cursor line
set virtualedit=onemore " Allow the cursor to move just past the end of the line
set scrolloff=10 " Always keep 10 lines after or before when scrolling
set gdefault " The substitute flag g is on
set showbreak=↪ " See this char when wrapping text
set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set ignorecase " Search insensitive
set smartcase " ... but smart

""" Prevent lag when hitting escape
set ttimeoutlen=0
set timeoutlen=1000
au InsertEnter * set timeout
au InsertLeave * set notimeout

" Set to auto read when a file is changed from the outside
set autoread

" For regular expressions turn magic on
set magic

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Make backspace behave in a sane manner
set backspace=2
set backspace=indent,eol,start

" Fix laggy scroll
set lazyredraw
set ttyfast

""" Custom commands

" :W - To write with root rights
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Returns true if paste mode is enabled
function! HasPaste()
	if &paste
		return 'PASTE MODE  '
	endif
	return ''
endfunction

" Airline stuff
let g:airline_powerline_fonts = 1
let g:airline#extensions#whitespace#checks = [ 'trailing' ]

" Highlight columns
let &colorcolumn="80,100,110,".join(range(120,999),",")

let mapleader = ","
" Clear search buffer
nnoremap <leader><space> :noh<cr>
" Re-select pasted text
nnoremap <leader>v V`]
" Automagically inserts \end in LaTeX with proper contents
nnoremap <leader>end o\end{}<esc>/\\begin<enter>Nf{lyt}/\\end<enter>f{p<esc><leader><space>k
" Delete without putting into the yank register
nnoremap <leader>d "_d

" Toggle NERDTree
nnoremap <leader>nt :NERDTreeToggle<enter>

" Create sequence of numbers from a ^A on a vblock of numbers
function! Incr()
	let a = line('.') - line("'<")
	let c = virtcol("'<")
	if a > 0
		execute 'normal! '.c.'|'.a."\<C-a>"
	endif
	normal `<
endfunction
vnoremap <C-a> :call Incr()<CR>

" Plugins
call plug#begin('~/.vim/plugged')

" Airline statusbar
Plug 'vim-airline/vim-airline'

" Polyglot addons
Plug 'sheerun/vim-polyglot'

" Indent guides
" Plug 'nathanaelkane/vim-indent-guides'

" Better (?) indent guides
Plug 'Yggdroot/indentLine'

" Git modifications in the gutter
Plug 'airblade/vim-gitgutter'

" Syntax checker
" Plug 'scrooloose/syntastic'

" Alignment plugin
" Plug 'godlygeek/tabular'

" File tree
Plug 'scrooloose/nerdtree'

" Nerdtree git integration
Plug 'Xuyuanp/nerdtree-git-plugin'

" Better JSON handling
Plug 'elzr/vim-json'

" Highlight trailing whitespaces
Plug 'bronson/vim-trailing-whitespace'

" Automatically inserts matching pair
Plug 'jiangmiao/auto-pairs'

" YouCompleteMe
" Plug 'Valloric/YouCompleteMe'

" Table Mode
Plug 'dhruvasagar/vim-table-mode'

" Edit PNGs ? WTF ?
Plug 'tpope/vim-afterimage'

call plug#end()

" Sytastic config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

" Tab guides
set listchars=tab:\│\ 
set list
hi SpecialKey ctermfg=240 ctermbg=NONE

" Indent guides, spaces
let g:indentLine_char='│'
let g:indentLine_color_term=240

" clang_complete config
" let g:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'

" Fix conflict between clang_complete and auto-pairs
let g:AutoPairsMapCR = 0
imap <silent><CR> <CR><Plug>AutoPairsReturn
" let g:clang_make_default_keymappings = 0

" Change the vim shell for syntastic (can't handle fish)
set shell=bash

" Use clang-format
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

