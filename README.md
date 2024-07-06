# 💾 Persistence

**Persistence** is a simple lua plugin for automated session management.

## ✨ Features

- automatically saves the active session under `~/.local/state/nvim/sessions` on exit
- simple API to restore the current or last session

## ⚡️ Requirements

- Neovim >= 0.7.2

## 📦 Installation

Install the plugin with your preferred package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

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
  dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
  -- minimum number of file buffers that need to be open to save
  -- Set to 0 to always save
  need = 1,
  branch = true, -- use git branch to save session
}
```

> [!TIP]
> To configure what should be saved in your session, check [:h 'sessionoptions'](https://neovim.io/doc/user/options.html#'sessionoptions')

## 🚀 Usage

**Persistence** works well with plugins like `startify` or `dashboard`. It will never restore a session automatically,
but you can of course write an autocmd that does exactly that if you want.

```lua
-- load the session for the current directory
vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end)

-- select a session to load
vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end)

-- load the last session
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end)

-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end)
```

## 📅 Events

- **PersistenceLoadPre**: before loading a session
- **PersistenceLoadPost**: after loading a session
- **PersistenceSavePre**: before saving a session
- **PersistenceSavePost**: after saving a session
