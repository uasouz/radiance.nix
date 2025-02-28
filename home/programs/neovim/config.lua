-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end

vim.opt.rtp:prepend(lazypath)

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
end

require("lazy").setup({
  -- Theme
  { "navarasu/onedark.nvim",
    config = function()

require('onedark').setup({
  style = 'deep'
})
require('onedark').load()
    end
  },
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({
        on_attach = my_on_attach
      })
    end
  },

  -- LSP + Completion
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({ ensure_installed = { "zls","yamlls","rust_analyzer","lua_ls",
        "ts_ls", "pyright", "gopls","pbls", "prismals", "sqlls", "rnix" } })
    end
  },
  { "hrsh7th/nvim-cmp",              dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" } },

  -- Treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "go", "javascript", "python", "typescript", "rust", "zig"
        },
        highlight = { enable = true },
        incremental_selection = { enable = true },
      })
    end
  },

  -- Fuzzy Finder (Telescope)
  { "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim" },

  -- Statusline (Lualine)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("lualine").setup({ options = { theme = "auto" } })
    end
  },

  -- Git integration
  { "lewis6991/gitsigns.nvim", config = true },

  -- Auto pairs
  { "windwp/nvim-autopairs",   config = true },
  -- LazyGit Plugin
  {
    "kdheepak/lazygit.nvim",
    config = function()
      -- Optional: Keybinding to open LazyGit
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true }) -- LazyGit keybinding
    end
  },
  -- Terminal Toggle
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({

        shade_terminals = true,
        start_in_insert = true,
        float_opts = {
          border = "curved",
          width = 180,
          height = 35,
          winblend = 10,
        },
        size = function(term)
          if term.direction == "vertical" then
            return vim.o.columns * 0.3
          elseif term.direction == "horizontal" then
            return 15
          else
            return 25
          end
        end,
      })

      -- Floating Terminal
      local float_term = require("toggleterm.terminal").Terminal:new({
        direction = "float",
        hidden = true
      })

      -- Left Side Terminal
      local left_term = require("toggleterm.terminal").Terminal:new({
        direction = "vertical",
        hidden = true
      })

      -- Keybindings
      vim.keymap.set("n", "<M-3>", function() float_term:toggle() end, { silent = true }) -- Alt+3 for floating terminal
      vim.keymap.set("n", "<M-2>", function() left_term:toggle() end, { silent = true })  -- Alt+2 for left side terminal
    end
  },
  {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
},
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup()
    end,
  },
  {
    'wfxr/minimap.vim',
    build = "cargo install --locked code-minimap",
    -- cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
    config = function()
      -- lvim.builtin.which_key.mappings["m"] = {
      --   "<cmd>MinimapToggle<CR>", "Toggle Minimap"
      -- }
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      require('notify').setup({
        -- other stuff
        background_colour = "#000000"
      })
    end
  },
{
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    require("lsp_lines").setup()
  end,
},
{
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    })
  end
}
})

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true

-- Keybindings
vim.g.mapleader = " "

-- NvimTree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true }) -- File Explorer

-- Telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { silent = true }) -- Find Files
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { silent = true })  -- Grep
vim.keymap.set("n", "<leader>st", ":Telescope live_grep<CR>", { silent = true })  -- Grep

-- Git
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true }) -- Lazygit

-- Navigation
vim.keymap.set('n', '<C-l>', function() vim.cmd [[wincmd l]] end) -- move right
vim.keymap.set('n', '<C-k>', function() vim.cmd [[wincmd k]] end) -- move up
vim.keymap.set('n', '<C-j>', function() vim.cmd [[wincmd j]] end) -- move down
vim.keymap.set('n', '<C-h>', function() vim.cmd [[wincmd h]] end) -- move left

-- Diagnostic
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

vim.diagnostic.config({
  virtual_text = false,
})

vim.keymap.set(
  "n",
  "<leader>l",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)

-- Code Formatting
vim.keymap.set("n", "<leader>lf", function()
    require("conform").format()
end, { desc = "Format Code" })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf})
  end,
})

-- LSP setup
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      format = {
        enable = true,
      },
    },
  },
})
lspconfig.ts_ls.setup({})
lspconfig.gopls.setup({})
lspconfig.pyright.setup({})

-- Autocompletion setup
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = { { name = "nvim_lsp" } },
})
