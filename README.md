# vim.zsh

A simple vim plugin for zsh

## Custom key bindings

A common habit of vim users is to re-map a key sequence to`<Esc>` in insert mode, to avoid having to reach far on the keyboard. You can do the same here by simply assigning a key binding to the env variable `VI_MODE_ESC_INSERT`: for example

```bash

export VI_MODE_ESC_INSERT="jk" && plug "zap-zsh/vim"
```

will escape back into normal mode upon pressing `jk`. 
