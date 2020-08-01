function! GoTest()
  let line = getline('.')
  let list = split(line, ' ')

  for l in list
    let startPoint = stridx(l, 'Test')
    let endPoint = stridx(l, '(')
    if startPoint >= 0 && endPoint > 0
      let testName = l[startPoint:endPoint-1]
      let result = system("go test -v -run " . testName)
      echo result
      return
    endif
  endfor
  let result = system("go test -v")
  echo result
  return
endfunction

command! GoTest call GoTest()
