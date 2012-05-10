call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"Reload vimrc file: 
":so %
":so $MYVIMRC
",l

" move backup and swap files from working directory
set backupdir=/tmp/vim_backup/
set directory=/tmp/vim_swap/

syntax on
filetype on  
filetype plugin on  
filetype plugin indent on

set nocompatible
set modelines=0

autocmd BufRead,BufNewFile *.phtml set ft=html
autocmd BufRead,BufNewFile markdown set ft=markdown

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
set nowrap  
set ttyfast
set textwidth=0
set bs=2
set wildmenu
set wildmode=list:longest
set wildignore+=*Zend*,.git,*bundles*
set shortmess+=I

set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'}]  " filetype
"set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
"set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
"set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
"set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%)\ %<%P        " offset
set laststatus=2

let NERDTreeQuitOnOpen=1  
map <C-c> :NERDTreeToggle<CR>  

"nnoremap <CR> <C-^>  
"nnoremap <C-w> :w<CR>

let mapleader = ","

inoremap jj <ESC>
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
nnoremap <leader>v <C-w>v<C-w>l

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

"SyntasticEnable php
let g:syntastic_auto_loc_list=1

let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'ssh local open %URL%'


