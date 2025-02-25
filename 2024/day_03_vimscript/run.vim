let s:d=1 | let s:sum1=0 | let s:sum2=0
function! s:match(str, di)
if has_key(a:di, a:str) | let s:d=a:di[a:str] | else
execute 'let s:sum1=s:sum1+'.matchstr(a:str, '[0-9]\+', 1, 1).'*'.matchstr(a:str, ',[0-9]\+', 1, 1)[1:-1]
execute 'let s:sum2=s:sum2+'.s:d.'*'.matchstr(a:str, '[0-9]\+', 1, 1).'*'.matchstr(a:str, ',[0-9]\+', 1, 1)[1:-1]
endif
endfunction
%s/don't()\|do()\|mul([0-9]\+,[0-9]\+)/\=s:match(submatch(0), {'do()': 1, 'don''t()': 0,})/gn
echo 'p1: '.s:sum1 | echo 'p2: '.s:sum2