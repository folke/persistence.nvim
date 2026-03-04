local M = {}

---@type {[integer]: Persistence.Popup}
local state = {}

local Popup = {}

---@class Persistence.Popup.CloseCallbackOpts
---@field buf integer
---@field ns number
---@field cascade boolean
---@field close fun()

---@class Persistence.Popup.Opts
---@field win Persistence.WinOpts
---@field scratch boolean
---@field ns integer namespace
---@field content string[]
---@field keymaps {[string]: Persistence.KeyMap}
---@field close_callback nil|fun(x:Persistence.Popup.CloseCallbackOpts)
---@field prepare nil|fun(o:{buf: integer, ns: integer})
---@field after_win_create nil|fun(opts:{buf: integer, ns: number, win: integer})

---@class Persistence.Popup
---@field win integer
---@field buf integer
---@field opts Persistence.Popup.Opts

---Open a simple popup window
---@param opts Persistence.Popup.Opts
---@return Persistence.Popup
function Popup.open(opts)
  local buf = vim.api.nvim_create_buf(false, opts.scratch)

  local col = (vim.o.columns / 2) - (opts.win.width / 2)
  local row = ((vim.o.lines - vim.o.cmdheight) / 2) - (opts.win.height / 2)

  local config = vim.tbl_deep_extend("force", {
    style = "minimal",
    relative = "editor",
    row = row,
    col = col,
    title_pos = "center",
    border = "rounded",
  }, opts.win)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.content)

  if opts.prepare ~= nil then
    opts.prepare({ buf = buf, ns = opts.ns })
  end

  for key, map in pairs(opts.keymaps) do
    map.opts.buffer = buf
    vim.keymap.set(map.mode, key, map.action, map.opts)
  end

  local win = vim.api.nvim_open_win(buf, true, config)
  if opts.after_win_create ~= nil then
    opts.after_win_create({ buf = buf, ns = opts.ns, win = win })
  end

  return {
    win = win,
    buf = buf,
    opts = opts,
  }
end

---@param popup Persistence.Popup
---@param opts {cascade: boolean}
function Popup.close(popup, opts)
  if popup.opts.close_callback ~= nil then
    popup.opts.close_callback({
      buf = popup.buf,
      ns = popup.opts.ns,
      cascade = opts.cascade,
      close = function()
        -- close and remove the buffer
        vim.api.nvim_buf_delete(popup.buf, { force = true })
        if vim.api.nvim_win_is_valid(popup.win) then
          vim.api.nvim_win_close(popup.win, true)
        end
      end,
    })
  else
    -- close and remove the buffer
    vim.api.nvim_buf_delete(popup.buf, { force = true })
    if vim.api.nvim_win_is_valid(popup.win) then
      vim.api.nvim_win_close(popup.win, true)
    end
  end
end

---Open a popup according to the given options.
---@param opts Persistence.Popup.Opts
---@return integer buf buffer number of the popup
function M.open(opts)
  local p = Popup.open(opts)
  state[p.buf] = p

  return p.buf
end

--- Closes the popup for given buffer number according to the configured
--- `close_callback`.
---@param buf integer buffer number of the popup
---@param opts nil|{cascade: boolean?}
function M.close(buf, opts)
  local popup = state[buf]
  state[buf] = nil
  Popup.close(popup, vim.tbl_deep_extend("force", { cascade = true }, opts or {}))
end

return M
