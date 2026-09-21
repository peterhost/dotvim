" markdown.vim — vim-markdown, aperçu dans le navigateur, jekyll
if my#plug#on('vim-markdown')
  " blocs de code colorés selon leur langage (```python, ```js…)
  let g:vim_markdown_fenced_languages = ['js=javascript', 'bash=sh', 'viml=vim']
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_toml_frontmatter = 1
  let g:vim_markdown_new_list_item_indent = 2
endif

if my#plug#on('markdown-preview.nvim')
  let g:mkdp_auto_start = 0
  let g:mkdp_auto_close = 1
endif

if my#plug#on('vim-jekyll')
  let g:jekyll_post_template = [
        \ '---',
        \ 'layout: post',
        \ 'title: "JEKYLL_TITLE"',
        \ 'categories: "[category1, category2]"',
        \ 'tags: "[tag1,tag2]"',
        \ 'intro-img: "<img alt=\"pain-in-the-ass\" src=\"http://barkingcode.peterhost.fr/img/covers/date-covername.jpg\"/>"',
        \ 'intro: "Short Description<br/><br/><strong>Use Case:</strong> define use case"',
        \ '---',
        \ '']
endif
