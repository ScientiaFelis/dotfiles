
"set termguicolors
set guicursor= "Fix the change to clock cursor in terminal.

" Plugins and plugin settings
"{{{
"
" Load Plugins
call plug#begin('~/.vim/plugged')

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'itchyny/lightline.vim'
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'joshdick/onedark.vim'
Plug 'tpope/vim-surround'
" Plug 'vim-pandoc/vim-rmarkdown'
Plug 'donRaphaco/neotex', { 'for': 'tex' }

call plug#end()

" Settings of the plugins
"
" vim-pandoc
let g:pandoc#syntax#conceal#blacklist = ["atx", "titteblock"] " Do not change the symbols for headings.

let g:pandoc#folding#fdc = 0 " Do not show windows foldcolumn.
let g:pandoc#folding#level = 3


"vim-neotex latex-preview
let g:neotex_delay = 2000
let g:tex_flavor = 'latex'


"}}}

" Setting options
"{{{
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


" Foldings

set foldmethod=marker
highlight Folded guibg=red guifg=blue
highlight FoldColumn guibg=white guifg=green


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

"}}}


" Mappings and Autocommands
"{{{


" Tab completion
 " will insert tab at beginning of line,
 " will use completion if not at beginning
set wildmode=list:longest,list:full
set complete=.,w,t
set complete+=k/home/georg/Dokument/Min_Forskning/Artiklar/BibTex/Zotero.bib
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>

"Map jk to the esc. 
inoremap jk <esc> 

" Set the spellcheck and language 
inoremap ;se <Esc>:setlocal spell spelllang=en<Enter>
inoremap ;ss <Esc>:setlocal spell spelllang=sv<Enter>

" Make brackets arround words.
map <F5> <Esc>bi[<Esc>ea]<Esc>
map <Leader>p <Esc>bi(<Esc>ea)<Esc>
map <Leader>c <Esc>Bi{<Esc>Ea}<Esc>


" Autocomands
" Make shortcut comands for editing eg. html.
inoremap <Space><Space> <Esc>/<++><Enter>"_c4l

"Autocommand in insertmode i html
autocmd FileType html inoremap ;i <em></em><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;b <strong></strong><Space><++><Esc>FsT>i
autocmd Filetype html inoremap ;p <p></p><Space><++><Esc>FpT>i

" Autocommand in insertmode i bash
autocmd FileType sh inoremap ;i2 if [<Space><++><Space>]; then <Enter><++><Enter>else<Enter><++><Enter>fi<Esc>kkkkf<c4l
autocmd FileType sh inoremap ;i if [<Space><++><Space>]; then <Enter><++><Enter>fi<Esc>kkf<c4l
autocmd FileType sh inoremap ;t [<space><++><space>]<space><++><Esc>F[f>lc4l


" Autocommands in insertmode i Markdown 
autocmd FileType markdown inoremap ;b <Space><Esc>i**<++>**<Space><++><Esc>F*F<c4l
autocmd FileType markdown inoremap ;i <Space><Esc>i*<++>*<Space><++><Esc>F*F<c4l
autocmd FileType markdown inoremap ;k <Space><Esc>i***<++>***<Space><++><Esc>F*F<c4l
autocmd FileType markdown inoremap ;h1 <Esc>0i#<Space>
autocmd FileType markdown inoremap ;h2 <Esc>o<Enter><Esc>0i##<Space>
autocmd FileType markdown inoremap ;h3 <Esc>o<Enter><Esc>0i###<Space>
autocmd FileType markdown inoremap ;h4 <Esc>o<Enter><Esc>0i####<Space>
autocmd FileType markdown inoremap ;h5 <Esc>o<Enter><Esc>0i#####<Space>
autocmd FileType markdown inoremap ;f <Esc>i![<++>](<++>)<++><Esc>F]F<c4l
autocmd FileType markdown inoremap ;w <Esc>i[<++>](<++>)<++><Esc>F]F<c4l

"Add one citation block.
autocmd FileType markdown inoremap ;c <Esc>i[@<++>]<++><Esc>F@lc4l
" Finish two citations when you only have the nameyear tag.
autocmd FileType markdown inoremap ;2r <Esc>F;bi[@<Esc>f;wi@<Esc>ea]
" Finish three citations when you only have the nameyear tag.
autocmd FileType markdown inoremap ;3r <Esc>F;F;bi[@<Esc>f;wi@<Esc>f;wi@<Esc>ea]


" Add a metadata block and referens section to markdown articles.
autocmd FileType markdown inoremap ;B <Esc>gg0O---<Enter>title:<Space><++><Enter>author:<Space><++><Enter>fontsize:<Space>12pt<Enter>bibliography:<Space>"/home/georg/Dokument/Min_Forskning/Artiklar/BibTex/Zotero.bib"<Enter>csl: "/home/georg/Dokument/Min_Forskning/Artiklar/BibTex/chicago-author-date.csl"<Enter>geometry:<Enter><Tab>-<Space>top=1cm<Enter>-<Space>right=1cm<Enter><Esc>I---<Enter><++><Enter><Enter><Esc>11kf<c4l

autocmd FileType markdown inoremap ;R <Esc>GA<Enter><Enter>### References<Enter>\noindent<Enter>\vspace{-2em}<Enter>\setlength{\parindent}{-0.6cm}<Enter>\setlength{\leftskip}{0.6cm}<Enter><Esc>


"}}}

" Backgrounds and coloschemes
"{{{

"
set background=dark

" Set the lightline colorscheme
"
"let g:lightline = {'colorscheme': 'nordisk'}
let g:lightline = {'colorscheme': 'onedark'}

set noshowmode " Dont show mode (NORMAL INSERT) as we already do that with lightline

" Set the colorscheme
"colorscheme solarized
"colorscheme nordisk
colorscheme onedark

"autocmd BufWinEnter,FileType markdown colorscheme onedark
autocmd BufWinEnter,FileType tex colorscheme solarized

"}}}
