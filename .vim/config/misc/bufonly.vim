"Deletes all buffers except the current one.
"Source: < https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one#comment86214068_42071865 >
command! BufOnly silent! execute "%bd|e#|bd#"

