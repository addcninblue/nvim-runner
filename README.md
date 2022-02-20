# Nvim-Runner

This plugin is a plugin that spawns REPLs in `run` or `interactive` mode,
depending on the keymap launched. It's quite similar to things like
[Vim-Slime](https://github.com/jpalardy/vim-slime), but was written since I
wasn't happy with any existing plugins.

## Features

Three functions are exposed:

* `run`: Opens a split that runs the current file.
* `interactive`: Opens a split that runs the current file in interactive mode.
* `send_text`: Text operator that sends the text object to the split.

This is really nice for scripting languages, where you can open a split and
send text by visual-moding over them and sending them over.

My configuration:

```fnl
(set vim.go.virtualedit "block,onemore")
(let [runner (require "runner")]
  (vimp.nnoremap ["silent"] "<leader>r" runner.run)
  (vimp.nnoremap ["silent"] "<leader>i" runner.interactive)
  (vimp.nnoremap ["silent" "expr"] "<leader>-" runner.send_text)
  (vimp.vnoremap ["silent" "expr"] "<leader>-" runner.send_text))
```
