local M = {}

---@class PersistenceOptions
---@field pre_save? fun()
local defaults = {
  dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- directory where session files are saved
  options = { "buffers", "curdir", "tabpages", "winsize", "skiprtp" }, -- sessionoptions used for saving
  save_empty = false, -- don't save if there are no open file buffers
}

---@type PersistenceOptions
M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
  vim.fn.mkdir(M.options.dir, "p")
end

return M
