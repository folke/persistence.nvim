# 💾 Persistence

**Persistence** is a simple lua plugin for automated session management.

## ✨ Features

- automatically saves the active session under `~/.local/state/nvim/sessions` on exit
- simple API to restore the current or last session

## ⚡️ Requirements

- Neovim >= 0.7.2

## 📦 Installation

Install the plugin with your preferred package manager:

### [folke](https://github.com/folke/lazy.nvim)

```lua
-- Lua
{
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  }
}
```

## ⚙️ Configuration

Persistence comes with the following defaults:

```lua
{
  dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
  options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
  pre_save = nil, -- a function to call before saving the session
  save_empty = false, -- don't save if there are no open file buffers
}
```

## 🚀 Usage

**Persistence** works well with plugins like `startify` or `dashboard`. It will never restore a session automatically,
but you can of course write an autocmd that does exactly that if you want.

```lua
-- restore the session for the current directory
vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})

-- restore the last session
vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})
```
