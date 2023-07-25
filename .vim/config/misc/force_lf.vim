"Converts mixed line endings to LF-only (Unix.)
"Found at <http://vim.wikia.com/wiki/File_format>
function! ForceLF()
  :update
  :e ++ff=dos
  :setlocal ff=unix
  :w
endfunction
