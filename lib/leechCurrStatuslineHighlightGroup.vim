" -------- Leech current ColorScheme --{{{2



" WARN: For some reason, the call :
"
"   synIDattr(synIDtrans(hlID(GroupName)), {what}, {mode})
"
"  does not work as expected if {mode} equals "gui",in a FOR loop. It
"  must have stg to do with the scope and my being an ass, but for the
"  moment, just do the following calls sequentially.
"

function! s:statuslineHighlightLeech()
  let s:listSynIDattrWhat = ["name","fg","bg","font","sp","fg#","bg#","sp#",
                            \"bold","italic","reverse","inverse","standout",
                            \"underline","undercurl"]
  let s:listSynIDattrMode = ["term", "cterm", "gui"]


  let l:tmpList = {}

  let l:tmpList["name"] = synIDattr(synIDtrans(hlID("StatusLine")), "name")

  let l:tmpList["termbold"]       = synIDattr(synIDtrans(hlID("StatusLine")), "bold",        "term")
  let l:tmpList["termitalic"]     = synIDattr(synIDtrans(hlID("StatusLine")), "italic",      "term")
  let l:tmpList["termreverse"]    = synIDattr(synIDtrans(hlID("StatusLine")), "reverse",     "term")
  let l:tmpList["terminverse"]    = synIDattr(synIDtrans(hlID("StatusLine")), "inverse",     "term")
  let l:tmpList["termstandout"]   = synIDattr(synIDtrans(hlID("StatusLine")), "standout",    "term")
  let l:tmpList["termunderline"]  = synIDattr(synIDtrans(hlID("StatusLine")), "underline",   "term")
  let l:tmpList["termundercurl"]  = synIDattr(synIDtrans(hlID("StatusLine")), "undercurl",   "term")

  let l:tmpList["ctermbold"]      = synIDattr(synIDtrans(hlID("StatusLine")), "bold",        "cterm")
  let l:tmpList["ctermitalic"]    = synIDattr(synIDtrans(hlID("StatusLine")), "italic",      "cterm")
  let l:tmpList["ctermreverse"]   = synIDattr(synIDtrans(hlID("StatusLine")), "reverse",     "cterm")
  let l:tmpList["cterminverse"]   = synIDattr(synIDtrans(hlID("StatusLine")), "inverse",     "cterm")
  let l:tmpList["ctermstandout"]  = synIDattr(synIDtrans(hlID("StatusLine")), "standout",    "cterm")
  let l:tmpList["ctermunderline"] = synIDattr(synIDtrans(hlID("StatusLine")), "underline",   "cterm")
  let l:tmpList["ctermundercurl"] = synIDattr(synIDtrans(hlID("StatusLine")), "undercurl",   "cterm")
  let l:tmpList["ctermfg"]        = synIDattr(synIDtrans(hlID("StatusLine")), "fg",          "cterm")
  let l:tmpList["ctermbg"]        = synIDattr(synIDtrans(hlID("StatusLine")), "bg",          "cterm")
  let l:tmpList["ctermsp"]        = synIDattr(synIDtrans(hlID("StatusLine")), "sp",          "cterm")


  let l:tmpList["guibold"]        = synIDattr(synIDtrans(hlID("StatusLine")), "bold",        "gui")
  let l:tmpList["guiitalic"]      = synIDattr(synIDtrans(hlID("StatusLine")), "italic",      "gui")
  let l:tmpList["guireverse"]     = synIDattr(synIDtrans(hlID("StatusLine")), "reverse",     "gui")
  let l:tmpList["guiinverse"]     = synIDattr(synIDtrans(hlID("StatusLine")), "inverse",     "gui")
  let l:tmpList["guistandout"]    = synIDattr(synIDtrans(hlID("StatusLine")), "standout",    "gui")
  let l:tmpList["guiunderline"]   = synIDattr(synIDtrans(hlID("StatusLine")), "underline",   "gui")
  let l:tmpList["guiundercurl"]   = synIDattr(synIDtrans(hlID("StatusLine")), "undercurl",   "gui")
  let l:tmpList["guifg"]          = synIDattr(synIDtrans(hlID("StatusLine")), "fg",          "gui")
  let l:tmpList["guibg"]          = synIDattr(synIDtrans(hlID("StatusLine")), "bg",          "gui")
  let l:tmpList["guisp"]          = synIDattr(synIDtrans(hlID("StatusLine")), "sp",          "gui")
  let l:tmpList["guifg#"]         = synIDattr(synIDtrans(hlID("StatusLine")), "fg#",         "gui")
  let l:tmpList["guibg#"]         = synIDattr(synIDtrans(hlID("StatusLine")), "bg#",         "gui")
  let l:tmpList["guisp#"]         = synIDattr(synIDtrans(hlID("StatusLine")), "sp#",        "gui")
  let l:tmpList["guifont"]        = synIDattr(synIDtrans(hlID("StatusLine")), "font",        "gui")

  return l:tmpList
endfunction


let s:statusLineHighlightDBG = s:statuslineHighlightLeech()
call Decho("-------------begin-------------")              "Decho
for key in sort(keys(s:statusLineHighlightDBG))            "Decho
  if s:statusLineHighlightDBG[key] != ""                   "Decho
    call Decho(key . ":" . s:statusLineHighlightDBG[key])  "Decho
  endif                                                    "Decho
endfo                                                      "Decho
call Decho("--------------end--------------")


