source $HOME/.addons/plugged.vim

" disable python2 support
let g:loaded_python_provider=1
" disable ruby support
let g:loaded_ruby_provider=1
" disable node support
let g:loaded_node_provider=1
let g:python3_host_prog="/Users/mscheufe/.virtualenvs/neovim/bin/python"
set diffopt+=vertical " open Gdiff in a vertical split window
"set acd "set autochdir
set noautochdir

set background=light " colors
colorscheme solarized

language en_US " language
set rnu " set relative line numbers
set hidden " allow to open a new file while the current file has unwritten changes
set scrolloff=1 " Minimal number of screen lines to keep above and below the cursor.

set ts=4 "number of spaces used for tab
set sts=4
set sw=4 "number of spaces used for one indent level
set smarttab " indents on beginning of line uses sw tabs, on other places indent uses ts, sts
set expandtab " in insert mode use the appropriate number of spaces when inserting a tab
set ignorecase " case insensitive search
set smartcase " Override the 'ignorecase' option if the search pattern contains upper case characters

set splitbelow " split windows are opened below respectively right
set splitright

set linebreak " do not split words when wrapping lines
set cul " highlight cursor line
set noshowmode " do not show the current mode (is displayed within lightline)
set listchars=tab:→\ ,trail:␣,extends:…,eol:⏎ " set chars to be displayed for whitespace char class
set inccommand=nosplit " make substitute command interactive

let g:yapf_style = "pep8" " python formatting with yapf

aug GENERAL
    au!
    au VimLeave * set guicursor=a:ver10-blinkon1 " restore cursor size and blinking on exit
    au FileType python setlocal equalprg=yapf " for python files run yapf when formatting with gq
aug END

" reload _vimrc on write
aug CONFIG
    au!
    au! BufWritePost $HOME/.vimrc nested source $MYVIMRC
aug END

aug PERL
    au!
    au! BufNewFile *.pl 0r ~/.vim/templates/pl.template
    au! FileType perl set tags^=~/.tags/perl/tags
    au! FileType perl setlocal equalprg=perltidy\ -st\ -q " for perl files run perltidy when formatting with gq
aug END

aug TERMINAL
    au!
    au! BufEnter * if &buftype == 'terminal' | :startinsert | endif
    au! BufLeave * if &buftype == 'terminal' | :stopinsert | endif
aug END

aug ASYNCRUN
    au!
    " Automatically open the quickfix window
    au! User AsyncRunStart call asyncrun#quickfix_toggle(8, 1)
aug END

hi TODO cterm=bold ctermbg=226 ctermfg=0
augroup HI_TODO
    au!
    au Syntax * syn match TODO /\v<(FIXME|NOTE|TODO|OPTIMIZE|XXX|BUG)/
          \ containedin=.*Comment,vimCommentTitle
augroup END

" completion options
set completeopt+=menuone
set completeopt+=noinsert

" linting with neomake When writing a buffer.
call neomake#configure#automake('w')
let g:neomake_open_list = 2
let g:neomake_python_python_exe = 'python3'

let g:lightline = {
    \ 'colorscheme': 'solarized',
	\ 'active': {
	\	'left': [ [ 'mode', 'paste' ], [ 'readonly', 'fugitive', 'filename' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'tagbar', 'fileformat', 'fileencoding', 'filetype', 'charval' ] ],
	\ },
    \ 'component_function': {
    \   'readonly': 'LightlineReadonly',
    \   'fugitive': 'LightlineFugitive',
    \},
    \ 'component': {
    \   'tagbar': '%{tagbar#currenttag("[ %s ]", "")}',
    \   'charval': '%b|0x%B',
    \},
    \ 'separator': {'left': '', 'right': ''},
    \ 'subseparator': { 'left': '', 'right': ''}
\ }

function! LightlineReadonly()
		return &readonly ? '⭤' : ''
endfunction

function! LightlineFugitive()
	if exists('*fugitive#head')
		let branch = fugitive#head()
		return branch !=# '' ? '⭠ '.branch : ''
	endif
	return ''
endfunction

" Custom mappings
let mapleader="," " leader key

" mappings
noremap <silent><F2> :UndotreeToggle<CR> " toggle UndoTree Window
noremap <silent><F3> :TagbarToggle<CR> " toggle tagbar
nmap <silent> <leader>d <Plug>DashSearch " search for word under cursor in Dash
nnoremap Y y$ " make behaviour of Y similar to C, D (delete from cursor to end of line)
nnoremap <silent><leader>q :cclose<CR> " close quickfix window
nnoremap <silent><leader>c :bd<CR> " delete current buffer
nnoremap <silent><leader><space> :noh<CR> " clear highlight
noremap <silent><leader>v :sp $HOME/.vimrc<CR> " edit init.vim in horizontal split window
" scroll 3 lines up/down without moving the cursor
" nnoremap <C-k> 3k3<C-y>
" noremap <C-j> 3j3<C-e>
inoremap <silent><C-s> <C-o>:up<CR> " save file in insert mode (only save in case buffer has changed)
nnoremap <silent><C-s> :up<CR>
nnoremap <leader>ff :FufCoverageFile<CR>
nnoremap <leader>be :BufExplorer<CR>
vnoremap // y/\V<C-R>"<CR> " copy visual selection and paste it into search

" Quick run via F8
function! s:CompileAndRun()
    :up
    if &filetype == 'python'
        exec "AsyncRun! python3 %"
    elseif &filetype == 'perl'
        exec "AsyncRun! perl %"
    endif
endfunction
nnoremap <silent><F8> :call <SID>CompileAndRun()<CR>

" Show syntax highlighting groups for word under cursor
function! s:SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nnoremap <C-S-P> :call <SID>SynStack()<CR>

function! s:LocationNext() " easily navigate errors in neomake
  try
    lnext
  catch
    try | lfirst | catch | endtry
  endtry
endfunction
nnoremap <leader>E :call <SID>LocationNext()<cr>
nnoremap <silent><leader>e :lclose<CR> " close error window

if has('nvim')
    " switch to terminal mode
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-v><Esc> <Esc>
	" Terminal mode:
	tnoremap <M-h> <c-\><c-n><c-w>h
	tnoremap <M-j> <c-\><c-n><c-w>j
	tnoremap <M-k> <c-\><c-n><c-w>k
	tnoremap <M-l> <c-\><c-n><c-w>l
    " Insert mode:
    inoremap <M-h> <Esc><c-w>h
    inoremap <M-j> <Esc><c-w>j
    inoremap <M-k> <Esc><c-w>k
    inoremap <M-l> <Esc><c-w>l
    " Visual mode:
    vnoremap <M-h> <Esc><c-w>h
    vnoremap <M-j> <Esc><c-w>j
    vnoremap <M-k> <Esc><c-w>k
    vnoremap <M-l> <Esc><c-w>l
    " Normal mode:
    nnoremap <M-h> <c-w>h
    nnoremap <M-j> <c-w>j
    nnoremap <M-k> <c-w>k
    nnoremap <M-l> <c-w>l
endif
