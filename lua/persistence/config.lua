local M = {}

---@class Persistence.Config
local defaults = {
  dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
  save_empty = false, -- don't save if there are no open file buffers
}

---@type Persistence.Config
M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
  vim.fn.mkdir(M.options.dir, "p")
end

return M
