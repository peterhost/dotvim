" xml : repli syntaxique, = réindente avec xmllint s'il est installé
setlocal foldmethod=syntax
setlocal tabstop=4 shiftwidth=4
if executable('xmllint')
  setlocal equalprg=xmllint\ --format\ -
endif
