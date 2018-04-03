
filetype plugin indent on
syntax on

" Show the file name in the title bar
set title

" Highlight current line
set cursorline

" Highlight search
set hlsearch

set autoindent
set nocompatible " Use Vim rather than Vi settings

set background=dark
"colorscheme solarized

"Map commands 
map <F5> bi[<Esc>ea]<Esc>
map \p bi(<Esc>ea)<Esc>
map \c bi{<Esc>ea}<Esc>

"##Taken from thoughbot

set history=50
set ruler		" Show mouse position
set showcmd		" display inclomplete commands

" Softtabs, 4 spaces
set tabstop=2
set shiftwidth=4
set shiftround
set expandtab


" Use one space after puctuation instead of two
set nojoinspaces

" Show 80 characters
"set textwidth=80
"set colorcolumn=+1

" Set not error bells
set noerrorbells

" Don't reset cursor to start of line
set nostartofline

" Show Linenumbers
set number
set numberwidth=4

" Show relative line numbers
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif

set ignorecase
set smartcase "Does not show lowercase matches if the search is with upper case.

" Tab completion
 " will insert tab at beginning of line,
 " will use completion if not at beginning
set wildmode=list:longest,list:full
set complete=.,w,t
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

set guicursor= "Fix the change to clock cursor in terminal.

" Make shortcut comands for editing eg. html.
inoremap <Space><Space> <Esc>/<++><Enter>"_c4l

"Autoinsert i html
autocmd FileType html inoremap ;i <em></em><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;b <strong></strong><Space><++><Esc>FsT>i
autocmd Filetype html inoremap ;p <p></p><Space><++><Esc>FpT>i

autocmd FileType sh inoremap ;i if i in <OO><Enter><Space><Space><Space><Space><++><Enter>else<Enter><++><Enter>fi<Esc>kkFOT>_c4l



