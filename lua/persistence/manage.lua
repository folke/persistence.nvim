local Config = require("persistence.config")
local Popup = require("persistence.popup")
local ops = require("persistence.ops")
local state = require("persistence.actions").state

local M = {}

---Restore original window focus and cursor position
---@param current_win integer window id
---@param cursor_pos integer[] cursor position tuple
local function restore_window_cursor(current_win, cursor_pos)
  vim.api.nvim_win_set_cursor(current_win, cursor_pos)
  vim.fn.win_gotoid(current_win)
end

---@param sessions string[]
---@return string[]
local function to_session_files(sessions)
  local files = {}
  for _, session in ipairs(sessions) do
    local name = ops.to_session_file_name(session)
    table.insert(files, name)
  end

  return files
end

---@param parent_opts Persistence.Popup.CloseCallbackOpts
---@param entries string[]
---@param current_win integer
---@param cursor_pos integer[]
local function open_confirm_popup(parent_opts, entries, current_win, cursor_pos)
  local lines = vim.api.nvim_buf_get_lines(parent_opts.buf, 0, -1, false)

  local content = { "Are you sure you want to delete following sessions?" }

  ---@type string[]
  local removed = vim
    .iter(entries)
    :filter(function(v)
      return vim.iter(lines):any(function(l)
        return l == v
      end) == false
    end)
    :totable()
  content = vim.list_extend(content, removed)
  local confirm_actions = "(Y)es     (N)o"
  local padding = ""
  for _ = 1, (Config.options.manage.confirm.width / 2 - (#confirm_actions / 2)) do
    padding = padding .. " "
  end
  vim.list_extend(content, { "", padding .. confirm_actions })

  if #removed > 0 then
    local buf = Popup.open({
      scratch = true,
      ns = parent_opts.ns,
      keymaps = Config.options.manage.keymaps.confirm,
      ---@diagnostic disable-next-line: assign-type-mismatch
      win = vim.tbl_deep_extend("force", Config.options.manage.confirm, { height = #content }),
      content = content,
      prepare = function(o)
        for i, line in ipairs(content) do
          if i > 1 and i < (#content - 1) then
            vim.api.nvim_buf_set_extmark(
              o.buf,
              o.ns,
              i - 1,
              0,
              { hl_group = Config.options.manage.highlight.confirm_warning, end_col = #line }
            )
          end
          if i == #content then
            local yes = line:find("%(Y%)")
            vim.api.nvim_buf_set_extmark(
              o.buf,
              o.ns,
              i - 1,
              yes - 1,
              { hl_group = Config.options.manage.highlight.confirm_warning, end_col = yes + 4 }
            )
            local no = line:find("%(N%)")
            vim.api.nvim_buf_set_extmark(
              o.buf,
              o.ns,
              i - 1,
              no - 1,
              { hl_group = Config.options.manage.highlight.neutral, end_col = no + 3 }
            )
          end
        end
      end,
      after_win_create = function(o)
        local no_pos = content[#content]:find("%(N%)")
        vim.api.nvim_win_set_cursor(o.win, { #content, no_pos })
      end,
      close_callback = function(opts)
        opts.close()
        if opts.cascade then
          parent_opts.close()
          restore_window_cursor(current_win, cursor_pos)
        end
      end,
    })

    state[buf] = { remove_sessions = to_session_files(removed) }
  else
    -- nothing to remove, just close the thing
    parent_opts.close()
    restore_window_cursor(current_win, cursor_pos)
  end
end

---@param ns integer
---@param entries string[]
---@param current_win integer
---@param cursor_pos integer[]
local function open_popup(ns, entries, current_win, cursor_pos)
  Popup.open({
    scratch = false,
    ns = ns,
    content = entries,
    keymaps = Config.options.manage.keymaps.list,
    win = Config.options.manage.list,
    prepare = function(o)
      for i, line in ipairs(entries) do
        local branch_icon_index = line:find("(" .. ops.branch_icon .. ")")
        if branch_icon_index ~= nil then
          local len = line:len()
          vim.api.nvim_buf_set_extmark(
            o.buf,
            o.ns,
            i - 1,
            branch_icon_index - 1,
            { hl_group = Config.options.manage.highlight.neutral, end_col = len }
          )
        end
      end
    end,
    close_callback = function(opts)
      open_confirm_popup(opts, entries, current_win, cursor_pos)
    end,
  })
end

---Open persistence session manager popup
---@param sessions string[]
function M.open(sessions)
  local current_win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

  local ns = vim.api.nvim_create_namespace("persistence.manage")
  local sessions_dir = Config.options.dir

  ---@type string[]
  local entries = {}
  for _, session in ipairs(sessions) do
    if vim.uv.fs_stat(session) then
      local file = session:sub(#sessions_dir + 1, -5)
      local dir = ops.to_display_line(file)
      table.insert(entries, dir)
    else
      table.insert(entries, session)
    end
  end
  open_popup(ns, entries, current_win, cursor_pos)
end

return M
