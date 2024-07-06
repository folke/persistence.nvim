local Config = require("persistence.config")

local uv = vim.uv or vim.loop

local M = {}
---@type string?
M._current = nil

local e = vim.fn.fnameescape

function M.current()
  local name = vim.fn.getcwd():gsub("[\\/:]", "%%")
  if Config.options.branch then
    local branch = M.branch()
    if branch and branch ~= "main" and branch ~= "master" then
      name = name .. "-" .. branch
    end
  end
  return Config.options.dir .. name .. ".vim"
end

function M.setup(opts)
  Config.setup(opts)
  M.start()
end

function M.fire(event)
  vim.api.nvim_exec_autocmds("User", {
    pattern = "Persistence" .. event,
  })
end

-- Check if a session is active
function M.active()
  return M._current ~= nil
end

function M.start()
  M._current = M.current()
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("persistence", { clear = true }),
    callback = function()
      M.fire("SavePre")

      if Config.options.need > 0 then
        local bufs = vim.tbl_filter(function(b)
          if vim.bo[b].buftype ~= "" or vim.bo[b].filetype == "gitcommit" or vim.bo[b].filetype == "gitrebase" then
            return false
          end
          return vim.api.nvim_buf_get_name(b) ~= ""
        end, vim.api.nvim_list_bufs())
        if #bufs < Config.options.need then
          return
        end
      end

      M.save()
      M.fire("SavePost")
    end,
  })
end

function M.stop()
  M._current = nil
  pcall(vim.api.nvim_del_augroup_by_name, "persistence")
end

function M.save()
  vim.cmd("mks! " .. e(M._current or M.current()))
end

---@param opts? { last?: boolean, file?: string }
function M.load(opts)
  opts = opts or {}
  local file = opts.file or opts.last and M.last() or M.current()
  if file and vim.fn.filereadable(file) ~= 0 then
    M.fire("LoadPre")
    vim.cmd("silent! source " .. e(file))
    M.fire("LoadPost")
    if M._current then
      M.start()
    end
  end
end

---@return string[]
function M.list()
  local sessions = vim.fn.glob(Config.options.dir .. "*.vim", true, true)
  table.sort(sessions, function(a, b)
    return uv.fs_stat(a).mtime.sec > uv.fs_stat(b).mtime.sec
  end)
  return sessions
end

function M.last()
  return M.list()[1]
end

function M.select()
  ---@type { session: string, dir: string }[]
  local items = {}
  for _, session in ipairs(M.list()) do
    if uv.fs_stat(session) then
      local dir = session:sub(#Config.options.dir + 1, -5):gsub("%%", "/")
      items[#items + 1] = { session = session, dir = dir }
    end
  end
  vim.ui.select(items, {
    prompt = "Select a session: ",
    format_item = function(item)
      return vim.fn.fnamemodify(item.dir, ":p:~")
    end,
  }, function(item)
    if item then
      M.load({ file = item.session })
    end
  end)
end

--- get current branch name
---@return string?
function M.branch()
  if uv.fs_stat(".git") then
    local ret = vim.fn.systemlist("git branch --show-current")[1]
    return vim.v.shell_error == 0 and ret or nil
  end
end

return M
