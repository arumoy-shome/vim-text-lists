" NOTE: this shadows vim-slime but that's okay because I don't need it for md files
nmap <buffer> <C-c><C-c> :call vim_markdown_lists#toggle_task()<CR>

nnoremap <buffer> o o<Esc>:call vim_markdown_lists#auto_list(0)<CR>A
nnoremap <buffer> O O<Esc>:call vim_markdown_lists#auto_list(1)<CR>A
inoremap <buffer> <CR> <CR><Esc>:call vim_markdown_lists#auto_list(0)<CR>A
