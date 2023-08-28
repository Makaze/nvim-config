---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    -- ["<Leader>", "<"] = { ":GuessIndent", "Guess settings buffer", opts = { nowait = true } },
    ["<Leader>ss"] = { "<cmd>SymbolsOutline<cr>", desc = "Toggle Symbols outline" },
    ["<Leader>u"] = { "<cmd>Telescope undo<cr>", desc = "Telescope undo" },
    ["s"] = { function() require("flash").jump() end, desc = "Flash" },
    ["S"] = { function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    ["<Leader>m"] = { '<cmd>MCunderCursor<cr>', desc = 'Create a selection for selected character under the cursor', },
  },
  o = {
    ["s"] = { function() require("flash").jump() end, desc = "Flash" },
    ["S"] = { function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    ["<Leader>rs"] = { function() require("flash").remote() end, desc = "Remote Flash" },
    ["<Leader>ts"] = { function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
  x = {
    ["s"] = { function() require("flash").jump() end, desc = "Flash" },
    ["S"] = { function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    ["<Leader>ts"] = { function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
  c = {
    ["<C-s>"] = { function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  v = {
    ["<Leader>m"] = { '<cmd>MCunderCursor<cr>', desc = 'Create a selection for selected character under the cursor', },
  }
}

-- more keybinds!

return M
