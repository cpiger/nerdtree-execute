" ============================================================================
" File:        execute_menuitem.vim
" Description: plugin for NERD Tree that provides an execute menu item, that
"              executes system default application for file or directory
" Maintainer:  Ivan Tkalin <itkalin at gmail dot com>
" Last Change: 27 May, 2010
" ============================================================================
if exists("g:loaded_nerdtree_shell_exec_menuitem")
  finish
endif

let g:loaded_nerdtree_shell_exec_menuitem = 1
if has("unix")
    let s:haskdeinit = system("ps -e") =~ 'kdeinit'
    let s:hasdarwin = system("uname -s") =~ 'Darwin'
endif

call NERDTreeAddMenuItem({
      \ 'text': '(E)xecute',
      \ 'shortcut': 'E',
      \ 'isActiveCallback': '1',
      \ 'callback': 'NERDTreeExecute' })


call NERDTreeAddKeyMap({
            \ 'key': 'E',
            \ 'callback': 'NERDTreeExecute',
            \ 'quickhelpText': 'open with system default application',
            \ 'override': '1',
            \ 'scope': 'Node' })


function! NERDTreeExecute(node)
  let l:oldssl=&shellslash
  set noshellslash
  let treenode = g:NERDTreeFileNode.GetSelected()
  let path = treenode.path.str()

  if has("gui_running")
    let args = shellescape(path,1)." &"
  else
    let args = shellescape(path,1)." > /dev/null"
  end

  if has("unix") && executable("gnome-open") && !s:haskdeinit
    exe "silent !gnome-open ".args
    let ret= v:shell_error
  elseif has("unix") && executable("kde-open") && s:haskdeinit
    exe "silent !kde-open ".args
    let ret= v:shell_error
  elseif has("unix") && executable("open") && s:hasdarwin
    exe "silent !open ".args
    let ret= v:shell_error
  elseif has("win32") || has("win64")
    exe "silent !start explorer ".shellescape(path,1)
  end
  let &shellslash=l:oldssl
  redraw!
endfunction
