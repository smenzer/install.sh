" File: pbcopy.vim
" Author: Tom Stuart
" User: Joseph Huttner
" Version: 1.0
" Last modified: February 7, 2011

function! s:pbcopy()
"  call system("ssh local pbcopy", getreg(""))
  call system("pbcopy", getreg(""))
endfunction

command! -nargs=0 -bar PBCopy call s:pbcopy()
