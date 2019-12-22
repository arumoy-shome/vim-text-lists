function! vim_markdown_lists#toggle_task() abort
  let l:current_line = getline(".")
  if l:current_line =~ '\v^\s*[-\*]\s\[[X]*\]\s'
    " if the current line starts with an arbitrary number of whitespace followed
    " by a `-` or `*` followed by a single whitespace followed by a `[` followed
    " by a `X` followed by a `]` followed by a single whitespace then make the
    " line an unordered list.
    substitute/\v^\s*[-\*]\s\zs\[[X]*\]\s\ze/
  elseif l:current_line =~ '\v^\s*[-\*]\s\[[^\]]*\]\s'
    " if the current line starts with an arbitrary number of whitespace followed
    " by a `-` or `*` followed by a single whitespace followed by a `[` followed
    " by a single char that is NOT `]` followed by a `]` followed by a single
    " whitespace then mark the task as done.
    substitute/\v^\s*[-\*]\s\zs\[[^\]]*\]\ze\s/[X]
  elseif l:current_line =~ '\v^\s*[-\*]\s'
    " if the current line starts with an arbitrary number of whitespace followed
    " by a `-` or `*` followed by a single whitespace then mae the line an
    " incomplete task.
    " NOTE: the trailing whitespace is intentional
    substitute/\v^\s*[-\*]\s\zs\ze/[ ] 
  elseif l:current_line =~ '\v^[A-Za-z]'
    " if the line starts with an alphabet, make it an unordered list.
    " NOTE: the trailing whitespace is intentional
    substitute/\v\zs\ze^[A-Za-z]/- 
  else
    " do nothing
  end
endfunction

function! s:complete_list(prepend, context_line)
  if a:context_line =~ '\v^\d+\.\s.'
    " The context line matches any number of digits followed by a full-stop
    " followed by one character of whitespace followed by one more character
    " i.e. it is an ordered list item

    " Continue the list
    let l:list_index = matchstr(a:context_line, '\v^\d*')
    if a:prepend
      call setline(".", l:list_index . ". ")
    else
      call setline(".", l:list_index . ". ")
    end
  elseif a:context_line =~ '\v^\d+\.\s$'
    " The context line matches any number of digits followed by a full-stop
    " followed by one character of whitespace followed by nothing
    " i.e. it is an empty ordered list item

    " End the list and clear the empty item
    if a:prepend
      call setline(line(".") + 1, "")
    else
      call setline(line(".") - 1, "")
    end
  elseif a:context_line[0] == "-" && a:context_line[1] == " "
    " The previous line is an unordered list item
    if strlen(a:context_line) == 2
      " ...which is empty: end the list and clear the empty item
      if a:prepend
        call setline(line(".") + 1, "")
      else
        call setline(line(".") - 1, "")
      end
    else
      " ...which is not empty: continue the list
      call setline(".", "- ")
    endif
  endif
endfunction

" Auto lists: Automatically continue/end lists by adding markers if the
" previous line is a list item, or removing them when they are empty
" from: https://gist.github.com/sedm0784/dffda43bcfb4728f8e90
function! vim_markdown_lists#auto_list(prepend)
  if a:prepend
    let l:context_line = getline(line(".") + 1)
    call s:complete_list(a:prepend, l:context_line)
  else
    let l:context_line = getline(line(".") - 1)
    call s:complete_list(a:prepend, l:context_line)
  end
endfunction
