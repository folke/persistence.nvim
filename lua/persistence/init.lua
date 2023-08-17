local Config = require("persistence.config")

local M = {}

local e = vim.fn.fnameescape

function M.get_current()
  local pattern = "/"
  if vim.fn.has("win32") == 1 then
    pattern = "[\\:]"
  end
  local name = vim.fn.getcwd():gsub(pattern, "%%")
  return Config.options.dir .. name .. ".vim"
end

function M.get_last()
  local sessions = M.list()
  table.sort(sessions, function(a, b)
    return vim.loop.fs_stat(a).mtime.sec > vim.loop.fs_stat(b).mtime.sec
  end)
  return sessions[1]
end

function M.has_session()
  return vim.fn.filereadable( M.get_current() ) == 1
end

function M.setup(opts)
  M.running = false
  Config.setup(opts)
  if opts.auto_start then M.start() end
end

function M.start()
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("persistence", { clear = true }),
    callback = function()
      if Config.options.pre_save then
        Config.options.pre_save()
      end

      M.save()
    end,
  })
  M.running = true
end

function M.stop()
  pcall(vim.api.nvim_del_augroup_by_name, "persistence")
  M.running = false
end

function M.save()
  local tmp = vim.o.sessionoptions
  vim.o.sessionoptions = table.concat(Config.options.options, ",")
  vim.cmd("mks! " .. e(M.get_current()))
  vim.o.sessionoptions = tmp
end

function M.load(opt)
  opt = opt or {}
  local sfile = opt.last and M.get_last() or M.get_current()
  if sfile and vim.fn.filereadable(sfile) ~= 0 then
    vim.cmd("silent! source " .. e(sfile))
    M.running = true
  end
end

function M.list()
  return vim.fn.glob(Config.options.dir .. "*.vim", true, true)
end

return M
