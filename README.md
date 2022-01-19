# 💾 Persisted

**Persisted** is a simple lua plugin for automated session management within Neovim.

The plugin was forked from the fantastic [Persistence.nvim](https://github.com/folke/persistence.nvim) as active development had paused.

## ✨ Features

- Automatically saves the active session under `.config/nvim/sessions` on exit
- Simple API to restore the current or last session
- Make use of sessions per git branch

## ⚡️ Requirements

- Neovim >= 0.5.0

## 📦 Installation

Install the plugin with your preferred package manager:

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
-- Lua
use({
  "olimorris/persisted.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  module = "persisted",
  config = function()
    require("persisted").setup()
  end,
})
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
" Vim Script
Plug 'olimorris/persisted.nvim'

lua << EOF
  require("persisted").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
```

## ⚙️ Configuration

Persisted comes with the following defaults:

```lua
{
  dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"), -- directory where session files are saved
  use_git_branch = false, -- create session files based on the branch of the git enabled repository
  options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
}
```

## 🚀 Usage

**Persisted** works well with plugins like `startify` or `dashboard`. It will never restore a session automatically,
but you can of course write an autocmd that does exactly that if you want.

```lua
-- restore the session for the current directory
vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persisted").load()<cr>]])

-- restore the last session
vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persisted").load({ last = true })<cr>]])

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persisted").stop()<cr>]])
```
