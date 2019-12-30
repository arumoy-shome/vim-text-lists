if exists("g:loaded_vtl")
  finish
endif
let g:loaded_vtl = 1

function! s:define_bindings() abort
  nmap <buffer> <silent> <C-c><C-c> :call vim_text_lists#toggle_task()<CR>

  nnoremap <buffer> <silent> o o<Esc>:call vim_text_lists#auto_list(0)<CR>A
  nnoremap <buffer> <silent> O O<Esc>:call vim_text_lists#auto_list(1)<CR>A
  inoremap <buffer> <silent> <CR> <CR><Esc>:call vim_text_lists#auto_list(0)<CR>A
endfunction

augroup VimTextLists
  autocmd!

  autocmd FileType markdown,text,gitcommit call s:define_bindings()
augroup END
