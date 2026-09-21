" autoload/my/writing.vim — mode écriture (Goyo + Limelight + Pencil)

function! my#writing#enter()
  if !empty($TMUX)
    silent !tmux set status off
  endif
  set noshowmode noshowcmd scrolloff=999
  if exists(':Limelight') == 2
    Limelight
  endif
  if exists(':PencilSoft') == 2
    PencilSoft
  endif
endfunction

function! my#writing#leave()
  if !empty($TMUX)
    silent !tmux set status on
  endif
  set showmode showcmd scrolloff=6
  if exists(':Limelight') == 2
    Limelight!
  endif
  if exists(':PencilOff') == 2
    PencilOff
  endif
endfunction
