local M = {}

---@class PersistenceOptions
local defaults = {
  dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"), -- directory where session files are saved
  use_git_branch = false, -- create session files based on the branch of the git enabled repository
  options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
}

---@type PersistenceOptions
M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
  vim.fn.mkdir(M.options.dir, "p")
end

return M
