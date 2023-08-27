---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    -- ["<Leader>", "<"] = { ":GuessIndent", "Guess settings buffer", opts = { nowait = true } }
  }
}

-- more keybinds!

return M
