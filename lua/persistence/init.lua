local Config = require("persistence.config")

local M = {}
---@type string?
M.current = nil

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

function M.setup(opts)
  Config.setup(opts)
  M.start()
end

function M.start()
  M.current = M.get_current()
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("persistence", { clear = true }),
    callback = function()
      if Config.options.pre_save then
        Config.options.pre_save()
      end

      if not Config.options.save_empty then
        local bufs = vim.tbl_filter(function(b)
          if vim.bo[b].buftype ~= "" then
            return false
          end
          if vim.bo[b].filetype == "gitcommit" then
            return false
          end
          return vim.api.nvim_buf_get_name(b) ~= ""
        end, vim.api.nvim_list_bufs())
        if #bufs == 0 then
          return
        end
      end

      M.save()
    end,
  })
end

function M.stop()
  M.current = nil
  pcall(vim.api.nvim_del_augroup_by_name, "persistence")
end

function M.save()
  local tmp = vim.o.sessionoptions
  vim.o.sessionoptions = table.concat(Config.options.options, ",")
  vim.cmd("mks! " .. e(M.current or M.get_current()))
  vim.o.sessionoptions = tmp
end

function M.load(opt)
  opt = opt or {}
  local sfile = opt.last and M.get_last() or M.get_current()
  if sfile and vim.fn.filereadable(sfile) ~= 0 then
    vim.cmd("silent! source " .. e(sfile))
  end
end

function M.list()
  return vim.fn.glob(Config.options.dir .. "*.vim", true, true)
end

return M
