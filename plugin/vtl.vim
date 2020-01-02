if exists("g:loaded_vtl")
  finish
endif
let g:loaded_vtl = 1

function! s:define_bindings(scope) abort
  if a:scope == 'auto_list'
    nnoremap <buffer> <silent> o o<Esc>:call vtl#auto_list(0, &ft, 'n')<CR>
    nnoremap <buffer> <silent> O O<Esc>:call vtl#auto_list(1, &ft, 'n')<CR>
    inoremap <buffer> <silent> <CR> <CR><Esc>:call vtl#auto_list(0, &ft, 'i')<CR>
  endif

  if a:scope == 'toggle_task'
    nmap <buffer> <silent> <C-c><C-c> :call vtl#toggle_task()<CR>
  endif
endfunction

augroup VimTextLists
  autocmd!

  autocmd FileType tex,markdown,text,gitcommit call s:define_bindings('auto_list')
  autocmd FileType markdown,text,gitcommit call s:define_bindings('toggle_task')
augroup END
