-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.opt.termguicolors = true

-- [[ Setting options ]]
-- See `:help vim.opt`
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.g.autoformat = true

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
if not vim.env.SSH_TTY then
    vim.opt.clipboard = "unnamedplus"
end

-- Enable break indent
vim.opt.breakindent = true

vim.opt.expandtab = true

vim.opt.formatoptions = "jcroqlnt"

vim.opt.grepformat = "%f:%l:%c:%m"

vim.opt.grepprg = "rg --vimgrep"

vim.opt.laststatus = 3

vim.opt.pumblend = 10

vim.opt.pumheight = 10

vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

vim.opt.shiftround = true

vim.opt.shiftwidth = 4

vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })

vim.opt.sidescrolloff = 8

vim.opt.wildmode = "longest:full,full" -- Command-line completion mode

vim.opt.foldlevel = 99

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.confirm = true

-- if vim.fn.has("nvim-0.9.0") == 1 then
--     vim.opt.statuscolumn = [[%!v:lua.require'lazyvim.util'.ui.statuscolumn()]]
--     vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
-- end
--
-- -- HACK: causes freezes on <= 0.9, so only enable on >= 0.10 for now
-- if vim.fn.has("nvim-0.10") == 1 then
--     vim.opt.foldmethod = "expr"
--     vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
--     vim.opt.foldtext = ""
--     vim.opt.fillchars = "fold: "
-- else
--     vim.opt.foldmethod = "indent"
-- end
--
-- vim.o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

if vim.fn.has("nvim-0.10") == 1 then
    vim.opt.smoothscroll = true
end
