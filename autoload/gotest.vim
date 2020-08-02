let s:gotest_buffer = 'TEST_RESULTS'

function! s:parseFuncName(l) abort
  let l:line = getline(a:l)
  let l:list = split(l:line, ' ')

  if len(l:list) < 2
    return ''
  endif

  if l:list[0] != 'func'
    return ''
  endif

  let l:endPoint = stridx(l:list[1], '(')
  if l:endPoint > 0
    let l:name = list[1][0:l:endPoint-1]
    return l:name
  endif

  return ''
endfunction

function! s:parseTestFuncName(name) abort
  let l:startPoint = stridx(a:name, 'Test')
  if l:startPoint == 0
    return a:name
  endif

  return ''
endfunction

function! s:runTestAll() abort
  lcd %:h
  return system('go test -v')
endfunction

function! s:runTestByName(name) abort
  lcd %:h
  return system('go test -v -run ' . a:name . '$')
endfunction

function! s:getTestName() abort
  let l:lines = line('.')

  for idx in range(l:lines)
    let l:name = s:parseFuncName(l:lines-idx)
    if l:name != ''
      if s:parseTestFuncName(l:name) != '' 
        return l:name
      else 
        return ''
      endif
    else
    endif
    if getline(l:lines-idx) == '}' && idx > 0
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
