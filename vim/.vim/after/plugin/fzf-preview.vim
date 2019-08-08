" Shamelessly stolen from:
" https://gist.github.com/acepukas/e4a13c34d9ce487a2ca4dfe7c6a48dce
" Which I got from:
" https://www.reddit.com/r/vim/comments/9xpb18/file_preview_with_fzf_rg_bat_and_devicons/

" ripgrep
if executable('rg')

  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

  " Overriding fzf.vim's default :Files command.
  " Pass zero or one args to Files command (which are then passed to Fzf_dev). Support file path completion too.
  command! -nargs=? -complete=file Files call Fzf_dev(<q-args>)

  nnoremap <silent> <leader>e :Files<CR>

endif

" Files + devicons
function! Fzf_dev(qargs)
  let l:fzf_files_options = '--reverse --prompt "filename > " --header "Open File:" --preview "bat --theme="OneHalfDark" --style=numbers,changes --color always {2..-1} | head -'.&lines.'" --expect=ctrl-t,ctrl-v,ctrl-x --multi --bind=ctrl-a:select-all,ctrl-d:deselect-all'

  function! s:files(dir)
    let l:cmd = $FZF_DEFAULT_COMMAND
    if a:dir != ''
      let l:cmd .= ' ' . shellescape(a:dir)
    endif
    let l:files = split(system(l:cmd), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      " temporarily disable webdevicons, because it's causing this preview window to
      " be extremely slow.
      " This is because it calls WebDevIconsGetFileTypeSymbol() once per file.
      " This call recurses down and ends up attempting to do about 10 pattern
      " matches per file, each of which takes about 0.2s
      " See https://github.com/ryanoasis/vim-devicons/blob/69028519c368304a6bf95f629b924c2ea85c69db/plugin/webdevicons.vim#L298
      " And the trace:
      " 48940              0.081112     for [pattern, glyph] in items(g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols)
      " 44046              0.218383       if match(fileNode, pattern) != -1
      "                                     let symbol = glyph
      "                                     break
      "                                   endif
      " 44046              0.019412     endfor
      "let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      let l:icon = "·" " Need to use a non-whitespace character so the logic to split the filename before feeding to bat for preview works correctly
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(lines)
    if len(a:lines) < 2 | return | endif

    let l:cmd = get({'ctrl-x': 'split',
                 \ 'ctrl-v': 'vertical split',
                 \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')

    for l:item in a:lines[1:]
      let l:pos = stridx(l:item, ' ')
      let l:file_path = l:item[pos+1:-1]
      execute 'silent '. l:cmd . ' ' . l:file_path
    endfor
  endfunction

  call fzf#run({
        \ 'source':  <sid>files(a:qargs),
        \ 'sink*':   function('s:edit_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'up':      '50%' })
endfunction

" Ctrl-P to open the file prompt, copying vscode
nnoremap <silent> <C-p> :call Fzf_dev(getcwd())<CR>
