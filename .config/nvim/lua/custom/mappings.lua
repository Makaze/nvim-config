---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader><"] = { ":GuessIndent<CR>", "Guess settings buffer", opts = { nowait = true } },
    -- ["<leader>ss"] = { "<cmd>SymbolsOutline<cr>", desc = "Toggle Symbols outline" },
    -- ["<leader>u"] = { "<cmd>Telescope undo<cr>", desc = "Telescope undo" },
    -- ["s"] = { function() require("flash").jump() end, desc = "Flash", opts = { noremap = true } },
    -- ["S"] = { function() require("flash").treesitter() end, desc = "Flash Treesitter" , opts = { noremap = true } },
    -- ["<leader>mc"] = { '<cmd>MCunderCursor<cr>', desc = 'Create a selection for selected character under the cursor', },
  },
  o = {
    -- ["s"] = { function() require("flash").jump() end, desc = "Flash", opts = { noremap = true } },
    -- ["S"] = { function() require("flash").treesitter() end, desc = "Flash Treesitter", opts = { noremap = true } },
    -- ["<leader>rs"] = { function() require("flash").remote() end, desc = "Remote Flash" },
    -- ["<leader>ts"] = { function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
  x = {
    -- ["s"] = { function() require("flash").jump() end, desc = "Flash", opts = { noremap = true } },
    -- ["S"] = { function() require("flash").treesitter() end, desc = "Flash Treesitter", opts = { noremap = true } },
    -- ["<leader>ts"] = { function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
  c = {
    -- ["<C-s>"] = { function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  v = {
    -- ["<leader>mc"] = { '<cmd>MCunderCursor<cr>', desc = 'Create a selection for selected character under the cursor', },
  }
}

M.disabled = {
  n = {
    ["<tab>"] = "",
    ["<S-tab>"] = "",
    ["<Up>"] = "",
    ["<Down>"] = "",
    ["<Left>"] = "",
    ["<Right>"] = "",
  },
}

M.tabufline = {
  n = {
    -- cycle through buffers
    ["<A-.>"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },
    ["<A->>"] = {
      function()
        require("nvchad.tabufline").move_buf(1)
      end,
      "Goto next buffer",
    },


    ["<A-,>"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },
    ["<A-<>"] = {
      function()
        require("nvchad.tabufline").move_buf(-1)
      end,
      "Goto next buffer",
    },

    -- close buffer + hide terminal buffer
    ["<A-c>"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },

    ["<A-p>"] = {
      ":Telescope buffers<CR>",
      "Search buffers"
    }
  },
}

-- more keybinds!

return M
