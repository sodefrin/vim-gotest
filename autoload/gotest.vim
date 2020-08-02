let s:gotest_buffer = 'TEST_RESULTS'

function! s:runTestAll() abort
  let l:path = fnamemodify(expand('%:p'), ':h')
  return system('cd ' . l:path . ';' . 'go test -v')
endfunction

function! s:runTestByName(name) abort
  let l:path = fnamemodify(expand('%:p'), ':h')
  return system('cd ' . l:path . ';' . 'go test -v -run ' . a:name . '$')
endfunction

function! s:getTestName() abort
  let l:lineNum = line('.')

  for idx in range(l:lineNum)
    let l:line = getline(l:lineNum-idx)
    let l:testName = matchstr(l:line, '^func\s\+\zsTest.*\ze\s*(')
    if l:testName != ''
      return l:testName
    endif
    if match(line, '^func') == 0
      return ''
    endif
    if idx > 0 && match(line, '^}\s*$') == 0
      return ''
    endif
  endfor
  
  return ''
endfunction

function! s:runTest() abort
  let l:testName = s:getTestName()
  if l:testName != '' 
    return s:runTestByName(l:testName)
  endif
  return s:runTestAll()
endfunction

function! gotest#run() abort
  let l:results = s:runTest()

  if bufexists(s:gotest_buffer)
    let winid = bufwinid(s:gotest_buffer)
    if winid isnot# -1
      call win_gotoid(winid)
    else
      execute 'sbuffer' s:gotest_buffer
    endif
  else
    execute 'new' s:gotest_buffer
    set buftype=nofile
  endif

  %delete _
  call setline(1, split(l:results, '\n'))
endfunction
