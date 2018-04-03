" To get neovim run the vim configs
"
set runtimepath^=~/.vim,/usr/share/vim/vim80/,/usr/share/vim/vimfiles runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
"set rtp^=/usr/share/vim/vim80/

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

if has('nvim-0.1.5')        " True color in neovim wasn't added until 0.1.5
    set termguicolors
endif

set bri
set spl=en,sv
set so=5
