" ============================================================================
" File:        gundo.vim
" Description: vim global plugin to visualize your undo tree
" Maintainer:  Steve Losh <steve@stevelosh.com>
" License:     GPLv2+ -- look it up.
" Notes:       Much of this code was thiefed from Mercurial, and the rest was
"              heavily inspired by scratch.vim and histwin.vim.
" Modified:    Add python3 support, 2011-01-29,
"              by lilydjwg <lilydjwg@gmail.com>
" ============================================================================


"{{{ Init

if !exists('g:gundo_debug') && (exists('g:gundo_disable') || exists('loaded_gundo') || &cp)"{{{
    finish
endif
let loaded_gundo = 1"}}}

if v:version < '703'"{{{
    echo  "Gundo requires Vim 7.3+"
    finish
endif"}}}

if has('python3')"{{{
    let s:has_supported_python = 2
elseif has('python')
    let s:has_supported_python = 1

python << ENDPYTHON
import sys
import vim
if sys.version_info[:2] < (2, 4):
    vim.command('let s:has_supported_python = 0')
ENDPYTHON

    " Python version is too old
    if !s:has_supported_python
        echo  "Gundo requires that Vim be compiled with Python 2.4+"
        finish
    endif
else
    " no Python support
    echo  "Gundo requires that Vim be compiled with Python 2.4+"
    finish
endif"}}}

if !exists('g:gundo_width')"{{{
    let g:gundo_width = 45
endif"}}}
if !exists('g:gundo_preview_height')"{{{
    let g:gundo_preview_height = 15
endif"}}}
if !exists('g:gundo_preview_bottom')"{{{
    let g:gundo_preview_bottom = 0
endif"}}}
if !exists('g:gundo_right')"{{{
    let g:gundo_right = 0
endif"}}}
if !exists('g:gundo_help')"{{{
    let g:gundo_help = 1
endif"}}}

"}}}

"{{{ Execute python codes
let pyfile = fnameescape(globpath(&runtimepath, 'plugin/gundo.py'))
if s:has_supported_python == 2
  exe 'py3file ' . pyfile
else
  exe 'pyfile ' . pyfile
endif

function! s:python(code)
  if s:has_supported_python == 2
    exe 'py3 ' . a:code
  else
    exe 'py ' . a:code
  endif
endfunction
"}}}

"{{{ Gundo utility functions

function! s:GundoGetTargetState()"{{{
    let target_line = matchstr(getline("."), '\v\[[0-9]+\]')
    return matchstr(target_line, '\v[0-9]+')
endfunction"}}}

function! s:GundoGoToWindowForBufferName(name)"{{{
    if bufwinnr(bufnr(a:name)) != -1
        exe bufwinnr(bufnr(a:name)) . "wincmd w"
        return 1
    else
        return 0
    endif
endfunction"}}}

function! s:GundoIsVisible()"{{{
    if bufwinnr(bufnr("__Gundo__")) != -1 || bufwinnr(bufnr("__Gundo_Preview__")) != -1
        return 1
    else
        return 0
    endif
endfunction"}}}

function! s:GundoInlineHelpLength()"{{{
    if g:gundo_help
        return 6
    else
        return 0
    endif
endfunction"}}}

"}}}

"{{{ Gundo buffer settings

function! s:GundoMapGraph()"{{{
    nnoremap <script> <silent> <buffer> <CR>          :call <sid>GundoRevert()<CR>
    nnoremap <script> <silent> <buffer> j             :call <sid>GundoMove(1)<CR>
    nnoremap <script> <silent> <buffer> k             :call <sid>GundoMove(-1)<CR>
    nnoremap <script> <silent> <buffer> gg            gg:call <sid>GundoMove(1)<CR>
    nnoremap <script> <silent> <buffer> P             :call <sid>GundoPlayTo()<CR>
    nnoremap <script> <silent> <buffer> p             :call <sid>GundoRenderChangePreview()<CR>
    nnoremap <script> <silent> <buffer> q             :call <sid>GundoClose()<CR>
    cabbrev  <script> <silent> <buffer> q             call <sid>GundoClose()
    cabbrev  <script> <silent> <buffer> quit          call <sid>GundoClose()
    nnoremap <script> <silent> <buffer> <2-LeftMouse> :call <sid>GundoMouseDoubleClick()<CR>
endfunction"}}}

function! s:GundoMapPreview()"{{{
    nnoremap <script> <silent> <buffer> q     :call <sid>GundoClose()<CR>
    cabbrev  <script> <silent> <buffer> q     call <sid>GundoClose()
    cabbrev  <script> <silent> <buffer> quit  call <sid>GundoClose()
endfunction"}}}

function! s:GundoSettingsGraph()"{{{
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal filetype=gundo
    setlocal nolist
    setlocal nonumber
    setlocal norelativenumber
    setlocal nowrap
    call s:GundoSyntaxGraph()
    call s:GundoMapGraph()
endfunction"}}}

function! s:GundoSettingsPreview()"{{{
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal filetype=diff
    setlocal nonumber
    setlocal norelativenumber
    setlocal nowrap
    setlocal foldlevel=20
    setlocal foldmethod=diff
    call s:GundoMapPreview()
endfunction"}}}

function! s:GundoSyntaxGraph()"{{{
    let b:current_syntax = 'gundo'

    syn match GundoCurrentLocation '@'
    syn match GundoHelp '\v^".*$'
    syn match GundoNumberField '\v\[[0-9]+\]'
    syn match GundoNumber '\v[0-9]+' contained containedin=GundoNumberField

    hi def link GundoCurrentLocation Keyword
    hi def link GundoHelp Comment
    hi def link GundoNumberField Comment
    hi def link GundoNumber Identifier
endfunction"}}}

"}}}

"{{{ Gundo buffer/window management

function! s:GundoResizeBuffers(backto)"{{{
    call s:GundoGoToWindowForBufferName('__Gundo__')
    exe "vertical resize " . g:gundo_width

    call s:GundoGoToWindowForBufferName('__Gundo_Preview__')
    exe "resize " . g:gundo_preview_height

    exe a:backto . "wincmd w"
endfunction"}}}

function! s:GundoOpenGraph()"{{{
    let existing_gundo_buffer = bufnr("__Gundo__")

    if existing_gundo_buffer == -1
        call s:GundoGoToWindowForBufferName('__Gundo_Preview__')
        exe "new __Gundo__"
        if g:gundo_preview_bottom
            if g:gundo_right
                wincmd L
            else
                wincmd H
            endif
        endif
        call s:GundoResizeBuffers(winnr())
    else
        let existing_gundo_window = bufwinnr(existing_gundo_buffer)

        if existing_gundo_window != -1
            if winnr() != existing_gundo_window
                exe existing_gundo_window . "wincmd w"
            endif
        else
            call s:GundoGoToWindowForBufferName('__Gundo_Preview__')
            if g:gundo_preview_bottom
                if g:gundo_right
                    exe "botright vsplit +buffer" . existing_gundo_buffer
                else
                    exe "topleft vsplit +buffer" . existing_gundo_buffer
                endif
            else
                exe "split +buffer" . existing_gundo_buffer
            endif
            call s:GundoResizeBuffers(winnr())
        endif
    endif
endfunction"}}}

function! s:GundoOpenPreview()"{{{
    let existing_preview_buffer = bufnr("__Gundo_Preview__")

    if existing_preview_buffer == -1
        if g:gundo_preview_bottom
            exe "botright new __Gundo_Preview__"
        else
            if g:gundo_right
                exe "botright vnew __Gundo_Preview__"
            else
                exe "topleft vnew __Gundo_Preview__"
            endif
        endif
    else
        let existing_preview_window = bufwinnr(existing_preview_buffer)

        if existing_preview_window != -1
            if winnr() != existing_preview_window
                exe existing_preview_window . "wincmd w"
            endif
        else
            if g:gundo_preview_bottom
                exe "botright split +buffer" . existing_preview_buffer
            else
                if g:gundo_right
                    exe "botright vsplit +buffer" . existing_preview_buffer
                else
                    exe "topleft vsplit +buffer" . existing_preview_buffer
                endif
            endif
        endif
    endif
endfunction"}}}

function! s:GundoClose()"{{{
    if s:GundoGoToWindowForBufferName('__Gundo__')
        quit
    endif

    if s:GundoGoToWindowForBufferName('__Gundo_Preview__')
        quit
    endif

    exe bufwinnr(g:gundo_target_n) . "wincmd w"
endfunction"}}}

function! s:GundoOpen()"{{{
    call s:GundoOpenPreview()
    exe bufwinnr(g:gundo_target_n) . "wincmd w"

    call s:GundoRenderGraph()
    call s:GundoRenderPreview()
endfunction"}}}

function! s:GundoToggle()"{{{
    if s:GundoIsVisible()
        call s:GundoClose()
    else
        let g:gundo_target_n = bufnr('')
        let g:gundo_target_f = @%
        call s:GundoOpen()
    endif
endfunction"}}}

"}}}

"{{{ Gundo mouse handling

function! s:GundoMouseDoubleClick()"{{{
    let start_line = getline('.')

    if stridx(start_line, '[') == -1
        return
    else
        call s:GundoRevert()
    endif
endfunction"}}}

"}}}

"{{{ Gundo movement

function! s:GundoMove(direction) range"{{{
    let start_line = getline('.')
    let distance = 2 * v:count1

    " If we're in between two nodes we move by one less to get back on track.
    if stridx(start_line, '[') == -1
        let distance = distance - 1
    endif

    let target_n = line('.') + (distance * a:direction)

    " Bound the movement to the graph.
    if target_n <= s:GundoInlineHelpLength() - 1
        call cursor(s:GundoInlineHelpLength(), 0)
    else
        call cursor(target_n, 0)
    endif

    let line = getline('.')

    " Move to the node, whether it's an @ or an o
    let idx1 = stridx(line, '@')
    let idx2 = stridx(line, 'o')
    if idx1 != -1
        call cursor(0, idx1 + 1)
    else
        call cursor(0, idx2 + 1)
    endif

    call s:GundoRenderPreview()
endfunction"}}}

"}}}

"{{{ Gundo rendering

function! s:GundoRenderGraph()"{{{
    call s:python("GundoRenderGraph()")
endfunction"}}}

function! s:GundoRenderPreview()"{{{
    call s:python("GundoRenderPreview()")
endfunction"}}}

function! s:GundoRenderChangePreview()"{{{
    call s:python("GundoRenderChangePreview()")
endfunction"}}}

"}}}

"{{{ Gundo undo/redo

function! s:GundoRevert()"{{{
    call s:python("GundoRevert()")
endfunction"}}}

function! s:GundoPlayTo()"{{{
    call s:python("GundoPlayTo()")
endfunction"}}}

"}}}

"{{{ Misc
command! -nargs=0 GundoToggle call s:GundoToggle()
command! -nargs=0 GundoRenderGraph call s:GundoRenderGraph()
autocmd BufNewFile __Gundo__ call s:GundoSettingsGraph()
autocmd BufNewFile __Gundo_Preview__ call s:GundoSettingsPreview()
"}}}
" vim:se fdm=marker:sw=4:
