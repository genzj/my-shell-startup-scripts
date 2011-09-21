" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
" if v:progname =~? "evim"
"  finish
" endif

" Set environment variables to make things easy
if has("win32")
	" Use vimfiles folder under the installation directory
	let $VIMFILES=$VIM.'/vimfiles'
else
	" Use the .vim directory under my home folder
	let $VIMFILES=$HOME.'/.vim'
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set backupdir=~/backup   " backup file directory
endif
set ttymouse=
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set sm			" show match
set nu			" show line No.
set softtabstop=4	" Set tabstop width
set tabstop=4		" ||
set shiftwidth=4	" --
"set ea				"Equal windows size
set sbr=->			"chars before a wraped line
set nolist			"show tabs and EOLs
set listchars=tab:>-,eol:$	"tab & eol char

set foldmethod=syntax   "set fold
set foldlevel=100       "do not fold by default

set noerrorbells		"no sound
set novisualbell

"set guifont=Inconsolata\ Medium\ 12 "font and color setting
"source $VIMRUNTIME/colors/torte.vim 
syntax enable
set background=dark
colorscheme solarized

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

  "When .vimrc isedited, reload it
  autocmd! bufwritepost .vimrc source ~/.vimrc
else

  set autoindent		" always set autoindenting on
  set smartindent		" Smart indent
  set cindent		" C-style indent

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Dictionaries
if has("win32")
	" no default dict for win32
else
	set dict+=/usr/share/dict/*
	set complete+=k
endif

" omni cpp STL completion tag
let $STLTAG=$VIMFILES."/tags/cpp.tag"
set tags+=$STLTAG

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" CTags
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"" Auto finding
"set tags=tags;
"
"" Sort by name
"let Tlist_Sort_Type = "name"
"
"" Use right window
"let Tlist_Use_Right_Window = 1
"
"" Enable auto update
"let Tlist_Auto_Update = 1
"
"" Set compart format
"let Tlist_Compart_Format = 1
"
"" Set exit by window
"let Tlist_Exit_OnlyWindow = 1
"
"" Disable auto close
"let Tlist_File_Fold_Auto_Close = 0
"
"" Disable fold column
"let Tlist_Enable_Fold_Column = 0
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Cscope Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"source $VIM/addons/plugin/cscope_map.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Taglist and Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Ctags_Cmd='/usr/bin/ctags'	"ctags command
let Tlist_Show_One_File = 1			"Show only current file
let Tlist_Exit_OnlyWindow = 1		"Exit when tag list is the only window
let Tlist_Use_Right_Window = 1		"Put tag list window at right of screen
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set mapleader
let mapleader = ","

map <silent> <F8> :GundoToggle<CR>
map <silent> <F9> :TlistUpdate<CR>:TlistToggle<CR>
map <silent> <F10> :TMiniBufExplorer<cr>

noremap <C-Tab> <C-W>w		
"Jump to next window
noremap <C-S-Tab> <C-W>W
"Jump to prev window
nnoremap <silent> <up> :wincmd k<CR>
nnoremap <silent> <down> :wincmd j<CR>
nnoremap <silent> <right> :wincmd l<CR>
nnoremap <silent> <left> :wincmd h<CR>

nnoremap <F3> :Explore<CR>
"Open Netrw explorer

nnoremap <silent><F4> :nohls<CR>
"hide highlight search

nnoremap <C-F3> :set scrollbind!<CR>
"sync windows scoll

nnoremap <leader>zb :!zsh<CR>
"Open bash shortkey

nnoremap <leader>zp :!python3<CR>
"Open Python 3 console

nnoremap <leader>zm :w<CR>:make<CR>
"Save and make current file

noremap <silent><leader>ol :set list!<CR>
"toggle show list

noremap <silent><leader>oro :set readonly!<CR>
"toggle read only

noremap <silent><leader>zc :let w:prev_d=getcwd()<CR>:cd %:p:h<CR>:!zsh<CR>:exe 'cd ' . w:prev_d<CR>:unlet w:prev_d<CR>
"open a shell and set to folder of current file

"Super-Tab keymap
"Enter the chosen one when the menu is visible
inoremap <expr> <CR>		pumvisible()?"\<C-Y>":"\<CR>"
inoremap <expr> <space>			pumvisible()?"\<C-Y>":"\<space>"
"Scoll and move the highlight
inoremap <expr> <C-j>		pumvisible()?"\<PageDown>":"\<C-j>"
inoremap <expr> <C-k>		pumvisible()?"\<PageUp>":"\<C-k>"
inoremap <expr> j			pumvisible()?"\<Down>":"j"
inoremap <expr> k			pumvisible()?"\<Up>":"k"

noremap <leader>zw	<C-W>=1<C-W><C-W>1<C-W>_
nnoremap <space>	Lzt
