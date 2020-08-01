function! s:isTestFunc(l) 
  let l:line = getline(a:l)
  let l:list = split(l:line, ' ')

  if len(l:list) < 2
    return ''
  endif

  if l:list[0] != 'func'
    return ''
  endif

  let l:startPoint = stridx(l:list[1], 'Test')
  let l:endPoint = stridx(l:list[1], '(')
  if l:startPoint == 0 && l:endPoint > 0
    let l:testName = list[1][l:startPoint:l:endPoint-1]
    return l:testName
  endif

  return ''
endfunction

function! GoTest()
  let l:line = line('.')

  for l in range(l:line)
    let l:testName = s:isTestFunc(l:line - l)
    if l:testName != ''
      lcd %:h
      echo system("go test -v -run " . l:testName . '$')
      return
    endif
  endfor
endfunction

command! GoTest call GoTest()
