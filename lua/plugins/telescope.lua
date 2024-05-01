return { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            "nvim-telescope/telescope-fzf-native.nvim",

            -- `build` is used to run some command when the plugin is installed/updated.
            -- This is only run then, not every time Neovim starts up.
            build = "make",

            -- `cond` is a condition used to determine whether this plugin should be
            -- installed and loaded.
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        { "nvim-telescope/telescope-ui-select.nvim" },

        -- Useful for getting pretty icons, but requires a Nerd Font.
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
        local builtin = require("telescope.builtin")

        local actions = require("telescope.actions")

        local open_with_trouble = function(...)
            return require("trouble.providers.telescope").open_with_trouble(...)
        end
        local open_selected_with_trouble = function(...)
            return require("trouble.providers.telescope").open_selected_with_trouble(...)
        end
        local find_files_no_ignore = function()
            local action_state = require("telescope.actions.state")
            local line = action_state.get_current_line()
            builtin.find_files({ no_ignore = true, default_text = line })
            -- LazyVim.telescope("find_files", { no_ignore = true, default_text = line })()
        end
        local find_files_with_hidden = function()
            local action_state = require("telescope.actions.state")
            local line = action_state.get_current_line()
            builtin.find_files({ hidden = true, default_text = line })
            -- LazyVim.telescope("find_files", { hidden = true, default_text = line })()
        end

        local function flash(prompt_bufnr)
            require("flash").jump({
                pattern = "^",
                label = { after = { 0, 0 } },
                search = {
                    mode = "search",
                    exclude = {
                        function(win)
                            return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                        end,
                    },
                },
                action = function(match)
                    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                    picker:set_selection(match.pos[1] - 1)
                end,
            })
        end

        -- Telescope is a fuzzy finder that comes with a lot of different things that
        -- it can fuzzy find! It's more than just a "file finder", it can search
        -- many different aspects of Neovim, your workspace, LSP, and more!
        --
        -- The easiest way to use Telescope, is to start by doing something like:
        --  :Telescope help_tags
        --
        -- After running this command, a window will open up and you're able to
        -- type in the prompt window. You'll see a list of `help_tags` options and
        -- a corresponding preview of the help.
        --
        -- Two important keymaps to use while in Telescope are:
        --  - Insert mode: <c-/>
        --  - Normal mode: ?
        --
        -- This opens a window that shows you all of the keymaps for the current
        -- Telescope picker. This is really useful to discover what Telescope can
        -- do as well as how to actually do it!

        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        require("telescope").setup({
            -- You can put your default mappings / updates / etc. in here
            --  All the info you're looking for is in `:help telescope.setup()`
            -- pickers = {}
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                -- open files in the first window that is an actual file.
                -- use the current window if no other window is available.
                get_selection_window = function()
                    local wins = vim.api.nvim_list_wins()
                    table.insert(wins, 1, vim.api.nvim_get_current_win())
                    for _, win in ipairs(wins) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        if vim.bo[buf].buftype == "" then
                            return win
                        end
                    end
                    return 0
                end,
                mappings = {
                    i = {
                        ["<c-t>"] = open_with_trouble,
                        ["<a-t>"] = open_selected_with_trouble,
                        ["<a-i>"] = find_files_no_ignore,
                        ["<a-h>"] = find_files_with_hidden,
                        ["<C-Down>"] = actions.cycle_history_next,
                        ["<C-Up>"] = actions.cycle_history_prev,
                        ["<C-f>"] = actions.preview_scrolling_down,
                        ["<C-b>"] = actions.preview_scrolling_up,
                        ["<c-s>"] = flash,
                    },
                    n = {
                        ["q"] = actions.close,
                        s = flash,
                    },
                },
            },
        })

        local kind_filter = {
            default = {
                "Class",
                "Constructor",
                "Enum",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Package",
                "Property",
                "Struct",
                "Trait",
            },
            markdown = false,
            help = false,
            -- you can specify a different filter for each filetype
            lua = {
                "Class",
                "Constructor",
                "Enum",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                -- "Package", -- remove package since luals uses it for control flow structures
                "Property",
                "Struct",
                "Trait",
            },
        }

        local function get_kind_filter(buf)
            buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
            local ft = vim.bo[buf].filetype
            if kind_filter == false then
                return
            end
            if kind_filter[ft] == false then
                return
            end
            if type(kind_filter[ft]) == "table" then
                return kind_filter[ft]
            end
            ---@diagnostic disable-next-line: return-type-mismatch
            return type(kind_filter) == "table" and type(kind_filter.default) == "table" and kind_filter.default or nil
        end

        -- Enable Telescope extensions if they are installed
        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        -- See `:help telescope.builtin`
        vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Switch Buffer" })
        vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Grep (Root Dir)" })
        vim.keymap.set("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
        vim.keymap.set("n", "<leader><space>", builtin.find_files, { desc = "Find Files (Root Dir)" })
        -- find
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Buffers" })
        -- TODO: maybe figure out the find config files command?
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files (Root Dir)" })
        vim.keymap.set("n", "<leader>fF", function()
            local utils = require("telescope.utils")
            builtin.find_files({ cwd = utils.buffer_dir() })
        end, { desc = "Find Files (cwd)" })
        vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Find Files (git files)" })
        vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent" })
        vim.keymap.set("n", "<leader>fR", function()
            local utils = require("telescope.utils")
            builtin.oldfiles({ cwd = utils.buffer_dir() })
        end, { desc = "Recent (cwd)" })
        -- git
        vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Commits" })
        vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Status" })
        -- search
        vim.keymap.set("n", '<leader>s"', "<cmd>Telescope registers<cr>", { desc = "Registers" })
        vim.keymap.set("n", "<leader>sa", "<cmd>Telescope autocommands<cr>", { desc = "Auto Commands" })
        vim.keymap.set("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer" })
        vim.keymap.set("n", "<leader>sc", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
        vim.keymap.set("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
        vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document Diagnostics" })
        vim.keymap.set("n", "<leader>sD", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace Diagnostics" })
        vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep (Root Dir)" })
        vim.keymap.set("n", "<leader>sG", function()
            local utils = require("telescope.utils")
            builtin.live_grep({ cwd = utils.buffer_dir() })
        end, { desc = "Grep (cwd)" })
        vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help Pages" })
        vim.keymap.set("n", "<leader>sH", "<cmd>Telescope highlights<cr>", { desc = "Search Highlight Groups" })
        vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })
        vim.keymap.set("n", "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages" })
        vim.keymap.set("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Jump to Mark" })
        vim.keymap.set("n", "<leader>so", "<cmd>Telescope vim_options<cr>", { desc = "Options" })
        vim.keymap.set("n", "<leader>sR", "<cmd>Telescope resume<cr>", { desc = "Resume" })
        vim.keymap.set("n", "<leader>sw", function()
            builtin.grep_string({ word_match = "-w" })
        end, { desc = "Word (Root Dir)" })
        vim.keymap.set("n", "<leader>sW", function()
            local utils = require("telescope.utils")
            builtin.grep_string({ cwd = utils.buffer_dir(), word_match = "-w" })
        end, { desc = "Word (cwd)" })
        vim.keymap.set("v", "<leader>sw", builtin.grep_string, { desc = "Selection (Root Dir)" })
        vim.keymap.set("v", "<leader>sW", function()
            local utils = require("telescope.utils")
            builtin.grep_string({ cwd = utils.buffer_dir() })
        end, { desc = "Selection (cwd)" })
        vim.keymap.set("n", "<leader>uC", function()
            builtin.colorscheme({ enable_preview = true })
        end, { desc = "Colorscheme with Preview" })
        vim.keymap.set("n", "<leader>ss", function()
            builtin.lsp_document_symbols({
                symbols = get_kind_filter(),
            })
        end, { desc = "Goto Symbol" })
        vim.keymap.set("n", "<leader>sS", function()
            builtin.lsp_dynamic_workspace_symbols({
                symbols = get_kind_filter(),
            })
        end, { desc = "Goto Symbol (Workspace)" })
    end,
}
