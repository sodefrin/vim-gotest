function! IsTestFunc(l) 
  let line = getline(a:l)
  let list = split(line, ' ')

  if len(list) < 2
    return ''
  endif

  if list[0] != 'func'
    return ''
  endif

  let startPoint = stridx(list[1], 'Test')
  let endPoint = stridx(list[1], '(')
  if startPoint == 0 && endPoint > 0
    let testName = list[1][startPoint:endPoint-1]
    return testName
  endif

  return ''
endfunction

function! GoTest()
  let line = line('.')

  for l in range(line)
    let testName = IsTestFunc(line - l)
    if testName != ''
      lcd %:h
      echo system("go test -v -run " . testName . '$')
      return
    endif
  endfor
endfunction

command! GoTest call GoTest()
