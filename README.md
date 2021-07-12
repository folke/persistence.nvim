# 💾 Persistence

**persistence** is a simple lua plugin for automated session management.

## ✨ Features

- automatically saves the active session under `.config/nvim/sessions` on exit
- simple API to restore the current or last session

## ⚡️ Requirements

- Neovim >= 0.5.0

## 📦 Installation

Install the plugin with your preferred package manager:

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
-- Lua
use({
  "folke/persistence.nvim",
  event = "VimEnter",
  module = "persistence",
  config = function()
    require("persistence").setup()
  end,
})
```

## ⚙️ Configuration

Todo comes with the following defaults:

```lua
{
  dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"), -- directory where session files are saved
  options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
}
```

## 🚀 Usage

**Persistence** works well with plugins like `startify` or `dashboard`. It will never restore a session automatically,
but you can of course write an autocmd that does exactly that if you want.

```lua
-- restore the session for the current directory
vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]])

-- restore the last session
vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load(last=true)<cr>]])

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]])
```
