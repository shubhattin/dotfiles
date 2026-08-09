if vim.g.vscode then
    return
end

-- Always show signcolumn to avoid layout shifts
vim.opt.signcolumn = "yes"

-- Diagnostics UI
local diagnostic_signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " "
}
for type, icon in pairs(diagnostic_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = ""
    })
end
vim.diagnostic.config({
    virtual_text = {
        spacing = 2,
        prefix = "●"
    },
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "if_many"
    }
})

-- Optional: better Lua development (Neovim runtime)
pcall(function()
    require("neodev").setup({})
end)

-- Prefer global csharpier (.NET tool) over a broken Mason binary if needed
local csharpier_tool = vim.fn.expand("~/.dotnet/tools")
if vim.fn.isdirectory(csharpier_tool) == 1 then
    vim.env.PATH = csharpier_tool .. ":" .. (vim.env.PATH or "")
end

-- Mason and Mason-Lspconfig
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
    mason.setup({})
end

local mlsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mlsp_ok then
    mason_lspconfig.setup({
        ensure_installed = {
            "lua_ls",
            "clangd", -- C/C++ (not C#; csharp_ls handles C#)
            "csharp_ls",
            "ts_ls",
            "eslint",
            "rust_analyzer",
            "svelte",
            "tailwindcss",
            "pylsp",
            -- Java handled via nvim-jdtls when present; keep installed for bits
            "jdtls"
        },
        automatic_installation = true
    })
end

-- nvim-cmp setup
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
    local luasnip_ok, luasnip = pcall(require, "luasnip")
    if luasnip_ok then
        require("luasnip.loaders.from_vscode").lazy_load()
    end

    if vim.g.cmp_enabled == nil then
        vim.g.cmp_enabled = true
    end

    cmp.setup({
        enabled = function()
            return vim.g.cmp_enabled ~= false and vim.g.lsp_disabled ~= true
        end,
        snippet = {
            expand = function(args)
                if luasnip_ok then
                    luasnip.lsp_expand(args.body)
                end
            end
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({
                select = true
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip_ok and luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, {"i", "s"}),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip_ok and luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, {"i", "s"})
        }),
        sources = cmp.config.sources({{
            name = "nvim_lsp"
        }, {
            name = "luasnip"
        }, {
            name = "path"
        }}, {{
            name = "buffer"
        }}),
        experimental = {
            ghost_text = true
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered()
        }
    })

    -- Toggle suggestion keymaps
    vim.keymap.set("n", "<leader>sd", function()
        vim.g.cmp_enabled = false
        local okc, cmpm = pcall(require, "cmp")
        if okc then
            cmpm.abort()
        end
        vim.notify("Suggestions disabled", vim.log.levels.INFO)
    end, {
        desc = "Disable suggestions (nvim-cmp)"
    })

    vim.keymap.set("n", "<leader>se", function()
        vim.g.cmp_enabled = true
        vim.notify("Suggestions enabled", vim.log.levels.INFO)
    end, {
        desc = "Enable suggestions (nvim-cmp)"
    })
end

-- LSP capabilities (with cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_caps_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_caps_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Configure servers via mason-lspconfig handlers
local lspconfig = require("lspconfig")
if mlsp_ok then
    mason_lspconfig.setup_handlers({
        function(server_name)
            if vim.g.lsp_disabled then
                return
            end
            local opts = {
                capabilities = vim.tbl_deep_extend("force", {}, capabilities)
            }
            if server_name == "lua_ls" then
                opts.settings = {
                    Lua = {
                        diagnostics = {
                            globals = {"vim"}
                        },
                        workspace = {
                            checkThirdParty = false
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }
            elseif server_name == "clangd" then
                opts.cmd = {
                    "clangd", "--background-index", "--clang-tidy",
                    "--fallback-style={BasedOnStyle: LLVM, IndentWidth: 2, TabWidth: 2, UseTab: Never}"
                }
                opts.capabilities.offsetEncoding = {"utf-16"}
            elseif server_name == "csharp_ls" then
                -- Loose .cs files (no .csproj/.sln) still need a root or the server never attaches
                local util = require("lspconfig.util")
                opts.root_dir = function(fname)
                    return util.root_pattern("*.sln", "*.csproj")(fname)
                        or util.find_git_ancestor(fname)
                        or vim.fs.dirname(fname)
                end
                opts.single_file_support = true
                opts.init_options = {
                    AutomaticWorkspaceInit = true
                }
            elseif server_name == "pylsp" then
                opts.settings = {
                    pylsp = {
                        plugins = {
                            pyflakes = {
                                enabled = true
                            },
                            pycodestyle = {
                                enabled = false
                            },
                            pylint = {
                                enabled = true
                            },
                            jedi_completion = {
                                fuzzy = true
                            }
                        }
                    }
                }
            elseif server_name == "jdtls" then
                -- Handled by nvim-jdtls in ftplugin/java.lua when available
                return
            end
            lspconfig[server_name].setup(opts)
        end
    })
end

-- Keymaps on LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        if vim.g.lsp_disabled then
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client then
                client:stop(true)
            end
            return
        end
        local opts = {
            buffer = event.buf
        }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
        vim.keymap.set({"n", "x"}, "<F3>", function()
            vim.lsp.buf.format({
                async = true
            })
        end, opts)
        vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
    end
})

-- Practice mode: stop/start language servers
vim.keymap.set("n", "<leader>ld", function()
    vim.g.lsp_disabled = true
    vim.g.cmp_enabled = false
    for _, client in ipairs(vim.lsp.get_clients()) do
        client:stop(true)
    end
    vim.diagnostic.reset()
    vim.diagnostic.enable(false)
    local okc, cmpm = pcall(require, "cmp")
    if okc then
        cmpm.abort()
    end
    vim.notify("LSP + suggestions disabled (practice mode)", vim.log.levels.INFO)
end, {
    desc = "Disable LSP (practice mode)"
})

vim.keymap.set("n", "<leader>le", function()
    vim.g.lsp_disabled = false
    vim.g.cmp_enabled = true
    vim.diagnostic.enable(true)
    vim.cmd("edit")
    vim.notify("LSP + suggestions enabled", vim.log.levels.INFO)
end, {
    desc = "Enable LSP"
})
