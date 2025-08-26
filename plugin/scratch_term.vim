vim9script
# Maintainer:   Shay Hill <http://shayallenhill.com>
# Version:      1.0.0
# Define a command, ScratchTerm, that creates a new terminal buffer and marks
# it as a scratch buffer. This allows us to kill all scratch terminals in the
# current view with a single function.


if v:version < 900
    finish
endif


if exists("g:loaded_scratch_term")
    finish
endif
g:loaded_scratch_term = 1

var coreutils_exe = ''
if executable('coreutils.exe')
    coreutils_exe = 'coreutils.exe'
    elseif exists('g:coreutils_exe')
        coreutils_exe = g:coreutils_exe
    else
        coreutils_exe = ''
endif 
# -----------------------------------------------------------------------------#
#
#  Identify scratch terminals
#
# ---------------------------------------------------------------------------- #


def IsScratchTerm(bufnr: number): bool
    # Return 1 if the buffer was created with the ScratchTerm command,
    # 0 otherwise.
    if bufexists(bufnr) && getbufvar(bufnr, 'scratch_term', 0)
        return v:true
    endif
    return v:false
enddef


def HasBufferWindow(bufnr: number): bool
    # Return 1 if the buffer has a current window
    var windows = getbufinfo(bufnr)[0].windows
    for winid in windows
        if win_id2win(winid) != -1
            return v:true
        endif
    endfor
    return v:false
enddef


def IsBufferOnCurrentTab(bufnr: number): bool
    # Return 1 if the buffer is visible in the current tab, 0 otherwise.
    var windows = getbufinfo(bufnr)[0].windows
    for winid in windows
        if tabpagenr() == win_id2tabwin(winid)[0]
            return v:true
        endif
    endfor
    return v:false
enddef


def IsVisibleScratchTerm(bufnr: number): bool
    # Return 1 if the buffer is visible in the current view, 0 otherwise.
    return IsScratchTerm(bufnr) &&
                \ HasBufferWindow(bufnr) &&
                \ IsBufferOnCurrentTab(bufnr)
enddef


# -----------------------------------------------------------------------------#
#
#  Close or kill scratch terminals
#
# ---------------------------------------------------------------------------- #


def KillOrCloseScratchTerms(do_kill: bool): void
    # Close or kill all terminals in the current view that were opened with
    # the ScratchTerm command. If you can see a terminal created with
    # ScratchTerm, this will kill it.
    var scratch_terms = range(1, bufnr('$')) ->
                \ filter((_, v) => IsVisibleScratchTerm(v))
    for term in scratch_terms
        if do_kill
            execute 'bdelete! ' .. term
        else
            execute 'bdelete ' .. term
        endif
    endfor
enddef


# kill all scratch terminals in the current view
command! ScratchTermsKill call KillOrCloseScratchTerms(v:true)

# close all scratch terminals in the current view
command! ScratchTermsClose call KillOrCloseScratchTerms(v:false)


# -----------------------------------------------------------------------------#
#
#  Open focused scratch terminals
#
# ---------------------------------------------------------------------------- #


# open a horizontal scratch terminal. focus on terminal
command! -nargs=* -complete=file ScratchTerm
    \ silent execute 'term ' .. coreutils_exe .. ' <args>' | b:scratch_term = 1


# open a vertical scratch terminal. focus on terminal
command! -nargs=* -complete=file ScratchTermV
    \ silent execute 'vert term ' .. coreutils_exe .. ' <args>' | b:scratch_term = 1


# Replace all open scratch terminals with a new scratch terminal.
command! -nargs=* -complete=file ScratchTermReplaceF
    \ KillOrCloseScratchTerms(v:true) |
    \ silent execute 'term ' .. coreutils_exe .. ' <args>' | b:scratch_term = 1


# Replace all open scratch terminals with a new vertical scratch terminal.
command! -nargs=* -complete=file ScratchTermReplaceFV
    \ KillOrCloseScratchTerms(v:true) |
    \ silent execute 'vert term ' .. coreutils_exe .. ' <args>' | b:scratch_term = 1


# -----------------------------------------------------------------------------#
#
#  Open unfocused scratch terminals
#
# ---------------------------------------------------------------------------- #


def OpenUnfocusedWindow(command: string): void
    # Run a command. Return to current window.
    var prev_winid = win_getid()
    execute command
    call win_gotoid(prev_winid)
enddef

# Open a scratch terminal. Keep focus.
command! -nargs=* -complete=file ScratchTermUnfocused
    \ OpenUnfocusedWindow('ScratchTerm ' .. <q-args>)

# Open a vertical scratch terminal. Keep focus.
command! -nargs=* -complete=file ScratchTermUnfocusedV
    \ OpenUnfocusedWindow('ScratchTermV ' .. <q-args>)

# Replace all open scratch terminals with a new scratch terminal.
# Keep focus.
command! -nargs=* -complete=file ScratchTermReplaceU
    \ KillOrCloseScratchTerms(v:true) |
    \ OpenUnfocusedWindow('ScratchTerm ' .. <q-args>)

# Replace all open scratch terminals with a new vertical scratch terminal.
# Keep focus.
command! -nargs=* -complete=file ScratchTermReplaceUV
    \ KillOrCloseScratchTerms(v:true) |
    \ OpenUnfocusedWindow('ScratchTermV ' .. <q-args>)

