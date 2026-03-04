local actions = require("persistence.actions")

local M = {}

local map_opts = { noremap = false, silent = true }

---@class Persistence.WinOpts
---@field height number
---@field width number
---@field title string|nil
---@field border string|nil

---@class Persistence.ConfirmOpts
---@field width number
---@field title string|nil
---@field border string|nil

---@class Persistence.KeyMap
---@field mode string
---@field action string|fun()
---@field opts vim.keymap.set.Opts

---@class Persistence.ManageConfig
local manage = {
  ---@type Persistence.WinOpts
  list = {
    width = 100,
    height = 30,
    title = " Manage sessions ",
  },
  ---@type Persistence.ConfirmOpts
  confirm = {
    width = 80,
    title = " Confirm ",
  },
  ---@type {list: {[string]: Persistence.KeyMap}, confirm: {[string]: Persistence.KeyMap}}
  keymaps = {
    list = {
      q = {
        mode = "n",
        opts = map_opts,
        action = actions.close_popup,
      },
    },
    confirm = {
      y = {
        mode = "n",
        opts = map_opts,
        action = actions.confirm_close,
      },
      n = {
        mode = "n",
        opts = map_opts,
        action = function()
          actions.close_popup({ cascade = false })
        end,
      },
      ["<Tab>"] = {
        mode = "n",
        opts = map_opts,
        action = actions.toggle_action_selection,
      },
      ["<CR>"] = {
        mode = "n",
        opts = map_opts,
        action = actions.execute_selected_action,
      },
    },
  },
  highlight = {
    confirm_warning = "ErrorMsg",
    neutral = "@label",
  },
}

---@class Persistence.Config
local defaults = {
  dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
  -- minimum number of file buffers that need to be open to save
  -- Set to 0 to always save
  need = 1,
  branch = true, -- use git branch to save session
  manage = manage,
}

---@type Persistence.Config
M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
  vim.fn.mkdir(M.options.dir, "p")
end

return M
