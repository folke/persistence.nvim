local M = {}

local e = vim.fn.fnameescape

local sessions_dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/")
vim.fn.mkdir(sessions_dir, "p")

function M.get_current()
  local name = vim.fn.getcwd():gsub("/", "%%")
  return sessions_dir .. name .. ".vim"
end

function M.get_last()
  local sessions = M.list()
  table.sort(sessions, function(a, b)
    return vim.loop.fs_stat(a).mtime.sec > vim.loop.fs_stat(b).mtime.sec
  end)
  return sessions[1]
end

function M.start()
  vim.cmd([[
    augroup Persistence
      autocmd!
      autocmd VimLeavePre * lua require("persistence").save()
      "autocmd BufEnter * lua require("persistence").save()
    augroup end
  ]])
end

function M.stop()
  vim.cmd([[
  autocmd! Persistence
  augroup! Persistence
  ]])
end

function M.save()
  vim.cmd("mks! " .. e(M.get_current()))
end

function M.load(opt)
  opt = opt or {}
  local sfile = opt.last and M.get_last() or M.get_current()
  if sfile and vim.fn.filereadable(sfile) ~= 0 then
    vim.cmd("source " .. e(sfile))
  end
end

function M.list()
  return vim.fn.glob(sessions_dir .. "*.vim", true, true)
end

return M
