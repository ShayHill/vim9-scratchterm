# scratch_term

Open terminals without losing focus. Close terminals with minimum disruption.

I often want to run a script or some tests in a terminal that *may* have useful output. This typically involves "tabbing over" to a terminal, starting a script, then tabbing back to read the output or close the terminal. Within Vim, I can do the same without the tabbing, but it is still necessary to switch buffers. This plugin defines commands to accomplish this with less distraction.

[See it in action](https://youtu.be/4qcHWfDdTjE)

## Commands

The terminal launching commands accept all arguments available to the vim `:terminal`. E.g., `:ScratchTerm python`.

### ScratchTerm

```
                                                *ScratchTerm*
:ScratchTerm            Open a terminal in Vim. The only difference between a
                        terminal opened with `:ScratchTerm` and a terminal
                        opened with `:term` is that the "scratch" terminal is
                        marked with a buffer-local variable "scratch_term".
```

### ScratchTermUnfocused

```
                                                *ScratchTermUnfocused*
:ScratchTermUnocused    Open a scratch terminal but keep focus in the current
                        window.
```

### ScratchTermReplaceF and ScratchTermReplaceU

```
                                                *ScratchTermReplaceF*
:ScratchTermReplaceF    Kill all open scratch terminals on the current tab and
                        replace with a single, focused scratch terminal.

                                                *ScratchTermReplaceU*
:ScratchTermReplaceU    Kill all open scratch terminals on the current tab and
                        replace with a single scratch terminal. Keep focus in
                        current window.
```

## Vertical Variants

All commands have a +V variant to run the command in a vertical terminal.

```
                                                *ScratchTermV*
:ScratchTermV           Open a scratch terminal in a vertical split.

                                                *ScratchTermUnfocused*
:ScratchTermUnocusedV   Open a vertical scratch terminal but keep focus in the
                        current window.

                                                *ScratchTermReplaceFV*
:ScratchTermReplaceFV   Kill all open scratch terminals on the current tab and
                        replace with a single, vertical, focused scratch
                        terminal.

                                                *ScratchTermReplaceUV*
:ScratchTermReplaceUV   Kill all open scratch terminals on the current tab and
                        replace with a single, vertical scratch terminal. Keep
                        focus in the current window.
```

## Example Use

Here are some example mappings for refactoring a module with existing tests in Python.

```
# re-run the last test in an unfocused terminal
nnoremap <F7> :update<CR>:ScratchTermReplaceFV pytest<t_ku><CR>
inoremap <F7> <ESC>:update<CR>:ScratchTermReplaceFV pytest<t_ku><CR>

# kill ScratchTerms
tmap <F4> <C-w>:ScratchTermsKill<CR>
nmap <F4> :ScratchTermsKill<CR>
```

Workflow is now:

    * edit a module
    * press F7 to run pytest in a terminal without losing focus on my module
    * read the output of pytest at my leisure
    # press F7 again to re-run the tests

This is also good for formatters, "fixing" linters, and other scripts with (at least occasionally) useful output.


## install

```
# Windows
git clone https://www.github.com/ShayHill/scratch_term ~\vimfiles\pack\plugins\start

# Linux
git clone https://www.github.com/ShayHill/scratch_term ~/.vim/pack/plugins/start

If you're cloning in, cd in Vim to the `pack/whatever/whatever/scratch_term/doc`
directory and run `:helptags`

# with minpac
call minpac#add('shayhill/scratch_term')
```


