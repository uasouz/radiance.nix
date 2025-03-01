local ollama = require "ollama_provider"

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
  -- Tabs
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
  -- Copilot
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- add any opts here
      -- for example
      provider = "ollama",
      vendors = {
        ollama = ollama.ollama
       -- ollama = {
       --   __inherited_from = "openai",
       --   endpoint = "http://localhost:11434/v1",
       --   model = "hhao/qwen2.5-coder-tools", -- your desired model (or use gpt-4o, etc.)
       --   timeout = 30000,                    -- timeout in milliseconds
       --   temperature = 0,                    -- adjust if needed
       --   max_tokens = 128000,
       --   -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
       -- },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick",         -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua",              -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  -- Theme
  {
    "navarasu/onedark.nvim",
    config = function()
      require('onedark').setup({
        style = 'deep',
        transparency = true
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
      require("mason-lspconfig").setup({
        ensure_installed = { "zls", "yamlls", "rust_analyzer", "lua_ls",
          "ts_ls", "pyright", "gopls", "pbls", "prismals", "sqlls", "rnix" }
      })
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
          lua = { "lua_ls" },
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
  signs = false,
  underline = false
})

vim.keymap.set(
  "n",
  "<leader>l",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)

-- Code Formatting
vim.keymap.set("n", "<leader>lf", function()
  vim.lsp.buf.format({ async = true })
  -- require("conform").format()
end, { desc = "Format Code" })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})


-- Bar
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<leader>bb', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<leader>bn', '<Cmd>BufferNext<CR>', opts)

-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

-- Pin/unpin buffer
map('n', '<leader>p', '<Cmd>BufferPin<CR>', opts)

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

-- Close buffer
map('n', '<leader>c', '<Cmd>BufferClose<CR>', opts)

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
map('n', '<leader>bj', '<Cmd>BufferPick<CR>', opts)

-- LSP setup
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      telemetry = { enable = false },
      runtime = {
        version = "LuaJIT",
        special = {
          reload = "require",
        },
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false, -- Disable annoying popup
      },
      format = {
        enable = true,
      },
    },
  },
})
lspconfig.ts_ls.setup({})
lspconfig.gopls.setup({})
lspconfig.pyright.setup({})

local lsp = vim.lsp.buf

vim.keymap.set("n", "<space>lD", lsp.type_definition, { desc = "Type Definition" })
vim.keymap.set("n", "gD", lsp.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gd", lsp.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gr", lsp.references, { desc = "Show References" })
vim.keymap.set("n", "K", lsp.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "<leader>rn", lsp.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>ca", lsp.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<space>li", "<cmd>LspInfo<CR>", { desc = "LSP Info" })
vim.keymap.set("n", "<space>lI", "<cmd>Mason<CR>", { desc = "Mason" })

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
