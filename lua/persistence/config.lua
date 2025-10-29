local M = {}

---@class Persistence.Config
local defaults = {
  dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
  -- minimum number of file buffers that need to be open to save
  -- Set to 0 to always save
  need = 1,

  -- use git branch to save session (true, false, or "any")
  -- false: single session per directory, not branch-specific
  -- true (default): branch-specific session, won't fall back to other branches
  -- "any": branch-specific session, falls back to any other branch
  branch = true,
}

---@type Persistence.Config
M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
  vim.fn.mkdir(M.options.dir, "p")
end

return M
