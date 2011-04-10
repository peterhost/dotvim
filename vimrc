" PATHOGEN
"" (either do that or place the following two lines at top of vimrc)
"" Needed on some linux distros.
"" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
"filetype off
" It is essential that these lines are called before enabling filetype detection
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" MACVIM Specific STUFF
if has("gui_macvim") 
    " set macvim specific stuff 
endif
