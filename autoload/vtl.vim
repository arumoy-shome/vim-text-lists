function! vtl#toggle_task() abort
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
    " by a `-` or `*` followed by a single whitespace then make the line an
    " incomplete task.
    " NOTE: the trailing whitespace is intentional
    substitute/\v^\s*[-\*]\s\zs\ze/[ ] 
  elseif l:current_line =~ '\v^\s*\d+\.\s'
    " if the current line starts with an arbitrary number of whitespace followed
    " by digits followed by a `.` followed by a single whitespace then make the
    " line an incomplete task.
    substitute/\v^\s*\zs\d+\.\ze\s/- [ ]
  elseif l:current_line =~ '\v^[A-Za-z]'
    " if the line starts with an alphabet, make it an unordered list.
    " NOTE: the trailing whitespace is intentional
    substitute/\v\zs\ze^[A-Za-z]/- 
  endif
endfunction

function! s:handle_empty_list(prepend) abort
  if a:prepend
    " since we prepended, clear the line below
    call setline(line(".") + 1, "")
  else
    " since we appended, clear the line above
    call setline(line(".") - 1, "")
  endif
endfunction

function! s:get_marker_pattern(ft) abort
  " match 'very magic' at begining of line, arbitrary whitespace followed by the
  " following list markers:
  let l:marker_pattern = '\v^\s*'
  " - arbitrary number of digits followed by a `.` or (markdown ordered list)
  " - a single `-` or `*` or (markdown unordered list)
  let l:md_marker_pattern = '(\d+\.|[-\*]|\\li)'
  " - a single `\item` (tex list)
  let l:tex_marker_pattern = '\\item'

  if a:ft == 'tex'
    let l:marker_pattern .= l:tex_marker_pattern
  else
    let l:marker_pattern .= l:md_marker_pattern
  endif

  return l:marker_pattern
endfunction

function! s:complete_list(prepend, ft, context_line) abort
  let l:marker_pattern = s:get_marker_pattern(a:ft)
  let l:marker = matchstr(a:context_line, l:marker_pattern)

  if a:context_line =~ l:marker_pattern . '\s.'
    " The context line matches the marker_pattern followed by one character of
    " whitespace followed by one more character i.e. it is a list

    " Continue the list
    call setline(".", l:marker . ' ')
  elseif a:context_line =~ l:marker_pattern . '\s$'
    " else if the list matches everything above but ends with nothing i.e. it's
    " an empty list

    " End the list and clear the empty item
    call s:handle_empty_list(a:prepend)
  endif
endfunction

" Auto lists: Automatically continue/end lists by adding markers if the
" previous line is a list item, or removing them when they are empty
" inspired by: https://gist.github.com/sedm0784/dffda43bcfb4728f8e90
function! vtl#auto_list(prepend, ft, mode) abort
  if a:mode == 'i' && col(".") != col("$")
    startinsert
    return
  endif

  if a:prepend
    let l:context_line = getline(line(".") + 1)
    call s:complete_list(a:prepend, a:ft, l:context_line)
  else
    let l:context_line = getline(line(".") - 1)
    call s:complete_list(a:prepend, a:ft, l:context_line)
  endif

  startinsert!
endfunction
