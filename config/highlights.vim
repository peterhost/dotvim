" highlights.vim — surlignages maison (voir autoload/my/highlights.vim)

if !has('syntax') || !exists('*matchadd')
  finish
endif

call my#highlights#define()

augroup my_highlights
  autocmd!
  autocmd BufWinEnter,WinEnter,FileType * call my#highlights#apply(0)
  autocmd InsertEnter * call my#highlights#apply(1)
  autocmd InsertLeave * call my#highlights#apply(0)
augroup END

command! LongLinesToggle call my#highlights#toggle_longlines()
