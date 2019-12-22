function! s:define_bindings() abort
  nmap <buffer> <C-c><C-c> :call vim_text_lists#toggle_task()<CR>

  nnoremap <buffer> o o<Esc>:call vim_text_lists#auto_list(0)<CR>A
  nnoremap <buffer> O O<Esc>:call vim_text_lists#auto_list(1)<CR>A
  inoremap <buffer> <CR> <CR><Esc>:call vim_text_lists#auto_list(0)<CR>A
endfunction

augroup VimTextLists
  autocmd!

  autocmd BufNewFile,BufRead *.md,*.txt,*.gitcommit call s:define_bindings()
augroup END
