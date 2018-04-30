" Vimrc
"
" This file contains the minimal settings to set the foundation, with the
" majority of the configuration and settings living in files spread between
" ~/.vim/rcfiles and ~/.vim/rcplugins

" leader key
let mapleader=","

function! s:SourceConfigFilesIn(directory)
  let directory_splat = '~/.vim/' . a:directory . '/*'
  for config_file in split(glob(directory_splat), '\n')
    if filereadable(config_file)
      execute 'source' config_file
    endif
  endfor
endfunction

call plug#begin('~/.vim/bundle')
call s:SourceConfigFilesIn('rcplugins')
call plug#end()

call s:SourceConfigFilesIn('rcfiles')

" vim:ft=vim
