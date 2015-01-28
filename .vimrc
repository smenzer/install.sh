"call pathogen#runtime_append_all_bundles()
execute pathogen#infect()
call pathogen#helptags()

"Reload vimrc file: 
":so %
":so $MYVIMRC

" move backup and swap files from working directory
set backupdir=~/terminal/.vim_backup/
set directory=~/terminal/.vim_swap/

syntax on
filetype on  
filetype plugin on  
filetype plugin indent on

set nocompatible
set modelines=0

"set syntax highlighting for filetypes
autocmd BufRead,BufNewFile *.phtml set ft=php
autocmd BufRead,BufNewFile markdown set ft=markdown
autocmd BufRead,BufNewFile *.json set ft=json
autocmd BufNewFile,BufRead *.blade.php set ft=html 

"make javascript use jQuery code style
au FileType javascript set tabstop=4

"set json syntax options
au FileType json set foldmethod=syntax
au FileType json set formatoptions=tcq2l
au FileType json set autoindent
au FileType json set textwidth=78 shiftwidth=2
au FileType json set softtabstop=4 tabstop=8 
au FileType json set expandtab

set autoindent  
set hlsearch
set smartindent  
set showmatch  
set number  
set ruler
set cursorline
"set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ L,\ col:\ %c%V\ (%P)%)
"set laststatus=4
set tabstop=4  
set softtabstop=4  
set shiftwidth=4  
set noexpandtab  
set incsearch  
set ignorecase  
set autoread  
set ttyfast
set textwidth=0
set bs=2
set wildmenu
set wildmode=list:longest
set wildignore+=*Zend*,.git,*bundles*
set shortmess+=I

set wrap
set linebreak

"set statusline=   " clear the statusline for when vimrc is reloaded
"set statusline+=%-3.3n\                      " buffer number
"set statusline+=%f\                          " file name
"set statusline+=%h%m%r%w                     " flags
"set statusline+=[%{strlen(&ft)?&ft:'none'}]  " filetype
""set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
""set statusline+=%{&fileformat}]              " file format
"set statusline+=%=                           " right align
""set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
""set statusline+=%b,0x%-8B\                   " current char
"set statusline+=%-14.(%l,%c%)\ %<%P        " offset
set laststatus=2

let NERDTreeQuitOnOpen=1  
map <C-c> :NERDTreeToggle<CR>  

"nnoremap <CR> <C-^>  
"nnoremap <C-w> :w<CR>

let mapleader = ","

noremap jj <ESC>
map <leader>a :set wrap!<CR>
map <leader>k :nohlsearch<CR>  
map <leader>l :source ~/.vimrc<CR>
map <leader>n :set number!<CR>
map <leader>o :only<CR>
map <leader>p :set paste!<CR>
map <leader>q :wqa<CR>
map <leader>s :setlocal spell!<CR>
map <leader>V :e ~/.vimrc<CR>
map <leader>w :w<CR>
map <leader>y y :PBCopy<CR>
"map <leader>/ /<C-p>


" noremap <silent> <leader>/ :call CommentLineToEnd('// ')<CR>+
lnoremap <leader>, <ESC>
noremap <leader>, <ESC>
"map <leader>| <c-w>|

" smarter splitting
nmap <leader>s<left> :leftabove vnew<CR>
nmap <leader>s<right> :rightbelow vnew<CR>
nmap <leader>s<up> :leftabove new<CR>
nmap <leader>s<down> :rightbelow new<CR>

"Easier splits navigation - Remapped Caps Lock to Control    
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Open a vertically-split window, and focus on it.
"nnoremap <leader>v <C-w>v<C-w>l

" set all panes equal size
map <leader>= <c-w>=

" easier splits sizing
noremap <C-w><left> 10<C-w><  
noremap <C-w><right> 10<C-w>> 
noremap <C-w><up> 10<C-w>+
noremap <C-w><down> 10<C-w>-

"PBCopy the selected text
noremap <leader>y y :PBCopy<CR>

" highlight text after it has been pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]''`]`'

let g:sparkupExecuteMapping='<c-g>'

":vmap // y/<C-R>"<CR> "search for visually highlighted text

let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'ssh local open %URL%'

"use your mouse to scroll
"set mouse=a
"set ttymouse=xterm2


"""""""""""""""""""""""""""""""""""
" airline status line configuration
"""""""""""""""""""""""""""""""""""

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

"* the separator used on the left side 
"default >
"  let g:airline_left_sep='»'
let g:airline_left_sep='▶'

"* the separator used on the right side
"default <
"  let g:airline_right_sep='«'
let g:airline_right_sep='◀'

"* enable modified detection 
"default 1
let g:airline_detect_modified=1

"* enable paste detection 
"default 1
let g:airline_detect_paste=1

"* enable iminsert detection 
"default 0
let g:airline_detect_iminsert=0

"* determine whether inactive windows should have the left section collapsed to only the filename of that buffer.
"default 1
let g:airline_inactive_collapse=1

"* enable/disable automatic population of the `g:airline_symbols` dictionary with powerline symbols. 
"default 0
let g:airline_powerline_fonts=0

" here is an example of how you could replace the branch indicator with
" the current working directory, followed by the filename.
let g:airline_section_b = '%f %h%m%r%w' "path/filename, help flag, modified flag, readonly flag, preview flag
let g:airline_section_c = '%t' "filename 
let g:airline_section_y = ''
let g:airline_section_warning = '%#warningmsg# %{SyntasticStatuslineFlag()} %*'



" syntastic settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

let g:syntastic_php_checkers = ["php", "phpcs", "phpmd", "phplint"]
"let g:syntastic_html_checkers = ["w3"]


map <leader>E :SyntasticCheck<CR>
map <leader>e :Errors<CR>
map <leader>r :lclose<CR>


