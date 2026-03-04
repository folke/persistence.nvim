local Popup = require("persistence.popup")

local M = {}

local state = {}
M.state = state

---@param win integer window id
---@return string
local function get_current_char(win)
  local current_pos = vim.api.nvim_win_get_cursor(win)
  local current_line = vim.api.nvim_get_current_line()
  local current_char = current_line:match("(.)", current_pos[2] + 1)

  return current_char
end

---Close the popup window according to `close_callback` if defined, otherwise bluntly closes the popup.
---`cascade` option only works with nested popups having `close_callback` set.
---@param opts nil|{cascade: boolean?}
function M.close_popup(opts)
  local buf = vim.api.nvim_get_current_buf()
  Popup.close(buf, opts)
end

---Delete selected sessions from given buffer of a popup
---@param sessions string[]
local function delete_selected_sessions(sessions)
  for _, session in ipairs(sessions) do
    local result = vim.fn.delete(session)
    if result > 0 then
      vim.notify("Failed to delete file: " .. session .. " , exited with status: " .. result, vim.log.levels.ERROR)
    end
  end
end

---Close the confirmation popup. The `confirm_close` popup behaves the same as `close_popup` but additionally
---deletes sessions that are removed from the buffer.
function M.confirm_close()
  local buf = vim.api.nvim_get_current_buf()
  local remove_sessions = (state[buf] or {}).remove_sessions or {}

  delete_selected_sessions(remove_sessions)
  Popup.close(buf, { cascade = true })
end

---Toggles cursor selection between Y and N actions
function M.toggle_action_selection()
  local buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local no_pos = lines[#lines]:find("%(N%)")
  local yes_pos = lines[#lines]:find("%(Y%)")
  local win = vim.api.nvim_get_current_win()

  local current_char = get_current_char(win)
  if current_char == "Y" then
    vim.api.nvim_win_set_cursor(win, { #lines, no_pos })
  elseif current_char == "N" then
    vim.api.nvim_win_set_cursor(win, { #lines, yes_pos })
  else
    vim.api.nvim_win_set_cursor(win, { #lines, no_pos })
  end
end

---Executes the action currently focused by the cursor. No-op if neither Y nor N is focused.
function M.execute_selected_action()
  local win = vim.api.nvim_get_current_win()
  local current_char = get_current_char(win)

  if current_char == "Y" then
    M.confirm_close()
  elseif current_char == "N" then
    M.close_popup({ cascade = false })
  end
end

return M
