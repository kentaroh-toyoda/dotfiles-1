"PHP lint
nnoremap <Space>l :call PHPLint()<CR>
"autocmd BufWritePost *.php :call PHPLint()

function! PHPLint()
	let result = system(&ft . ' -l ' . bufname(""))
	echo result
endfunction

"php関連
let php_sql_query=1
let php_htmlInStrings=1
let php_noShortTags=1
autocmd Syntax php set fdm=syntax

