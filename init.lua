-- [[ Global variables  ]]
-- See `:help vim.g`

-- Set mapleader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Vim options ]]
-- See `:help vim.o`

-- Make line numbers default
vim.o.number = true

-- Relative line numbers
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
-- Customization example of listchars
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Autocomplete behaviour
vim.o.completeopt = vim.o.completeopt .. ",menuone,noselect,popup"

-- Default border style of floating windows
vim.o.winborder = 'rounded'

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Restart with configuration changes
vim.keymap.set('n', '<leader>r', ':restart<CR>')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Navigate through quick list items
vim.keymap.set('n', '<leader>]', ':cnext<CR>', { desc = 'Go to next item in quick list' })
vim.keymap.set('n', '<leader>[', ':cprev<CR>', { desc = 'Go to previous item in quick list' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
-- vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
-- vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
-- vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- Increase/decrease window size
vim.keymap.set('n', '<leader>-', ':vertical resize -5<CR>')
vim.keymap.set('n', '<leader>=', ':vertical resize +5<CR>')

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the variable under your cursor.
    -- Most Language Servers support renaming across files, etc.
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

    -- Find references for the word under your cursor.
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    -- Useful when your language has ways of declaring types without an actual implementation.
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

    -- Jump to the definition of the word under your cursor.
    -- This is where a variable was first declared, or where a function is defined, etc.
    -- To jump back, press <C-t>.
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

    -- This is not Goto Definition, this is Goto Declaration.
    -- For example, in C this would take you to the header.
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Fuzzy find all the symbols in your current document.
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

    -- Fuzzy find all the symbols in your current workspace.
    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

    --  Jump to the definition of its *type*, not where it was *defined*.
    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')


    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end
  end,
})

-- [[ LSP ]]
--  See `:help vim.lsp`

vim.lsp.enable({
  'lua_ls',
  'bashls',
  'pyright',
  'intelephense',
  'ts_ls',
  'gopls',
  'templ',
  'jdtls',
})
vim.diagnostic.config({ virtual_text = true })

-- [[ Plugins ]]
--  See `:help vim.pack`

vim.pack.add({
    { src = 'https://github.com/mason-org/mason.nvim' },
})
require('mason').setup({})

vim.pack.add({'https://github.com/nvim-treesitter/nvim-treesitter'})
require('nvim-treesitter').setup({
  ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'python', 'java', 'html', 'css', 'javascript', 'typescript', 'go' },
})

vim.pack.add({'https://github.com/stevearc/oil.nvim'})
require('oil').setup()
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

vim.pack.add({'https://github.com/lewis6991/gitsigns.nvim'})
require('gitsigns').setup({
  current_line_blame = true,
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')
    vim.keymap.set('n', ']c', function() gitsigns.nav_hunk('next') end, { buffer = bufnr })
    vim.keymap.set('n', '[c', function() gitsigns.nav_hunk('prev') end, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hQ', function() gitsigns.setqflist('all') end, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hq', gitsigns.setqflist, { buffer = bufnr })
  end,
})

-- Telescope dependency
vim.pack.add({'https://github.com/nvim-lua/plenary.nvim'})

vim.pack.add({'https://github.com/nvim-telescope/telescope.nvim'})
require('telescope').setup()
vim.keymap.set('n', '<leader>sk', ':Telescope keymaps<CR>', { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', ':Telescope find_files<CR>', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sw', ':Telescope grep_string<CR>', { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', ':Telescope live_grep<CR>', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', ':Telescope resume<CR>', { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sb', ':Telescope buffers<CR>', { desc = '[S]earch [B]uffers' })

vim.pack.add({'https://github.com/mbbill/undotree'})
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

vim.pack.add({'https://github.com/LunarVim/bigfile.nvim'})

vim.pack.add({'https://github.com/RRethy/vim-illuminate'})

vim.pack.add({'https://github.com/nvim-treesitter/nvim-treesitter-context'})

vim.pack.add({'https://github.com/folke/todo-comments.nvim'})
require('todo-comments').setup()
vim.keymap.set('n', '<leader>td', vim.cmd.TodoTelescope)

vim.pack.add({'https://github.com/numToStr/Comment.nvim'})
require('Comment').setup()

-- The line beneath this is called `modeline`.
-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
