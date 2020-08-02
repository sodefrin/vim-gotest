function! s:parseFuncName(l)
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

function! s:parseTestFuncName(name) 
  let l:startPoint = stridx(a:name, 'Test')
  if l:startPoint == 0
    return a:name
  endif

  return ''
endfunction

function! s:runTestAll()
  lcd %:h
  return system('go test -v')
endfunction

function! s:runTest(name)
  lcd %:h
  return system('go test -v -run ' . a:name . '$')
endfunction

function! RunGoTest()
  let l:lines = line('.')

  for idx in range(l:lines)
    let l:name = s:parseFuncName(l:lines-idx)
    if l:name != ''
      if s:parseTestFuncName(l:name) != '' 
        echo s:runTest(l:name)
        return
      else 
        echo s:runTestAll()
        return
      endif
    else
    endif
    if getline(l:lines-idx) == '}' && idx > 0
      echo s:runTestAll()
      return
    endif
  endfor
  echo s:runTestAll()
  return
endfunction

command! GoTest call RunGoTest()
