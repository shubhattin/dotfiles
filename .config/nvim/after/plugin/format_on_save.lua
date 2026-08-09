if vim.g.vscode then
  return
end
local format_on_save = require("format-on-save")
local formatters = require("format-on-save.formatters")

-- Prefer the global .NET tool; Mason's csharpier needs aspnet-runtime on Arch
local csharpier_bin = (vim.fn.executable(vim.fn.expand("~/.dotnet/tools/csharpier")) == 1)
    and vim.fn.expand("~/.dotnet/tools/csharpier")
  or "csharpier"
local csharpier_config = vim.fn.stdpath("config") .. "/.csharpierrc.json"
-- csharpier needs a real file path (stdin-only / empty % crashes with directoryPath null)
local csharpier = formatters.shell({
  cmd = {
    csharpier_bin,
    "format",
    "--config-path",
    csharpier_config,
    "%",
  },
  tempfile = "random",
})

format_on_save.setup({
  experiments = {
    partial_update = "diff", -- or 'line-by-line'
  },
  exclude_path_patterns = {
    "/node_modules/",
    --".local/share/nvim/lazy",
  },
  formatter_by_ft = {
    css = formatters.lsp,
    c = formatters.lsp,
    cpp = formatters.lsp,
    cs = csharpier,
    java = formatters.lsp,
    html = formatters.lsp,
    javascript = formatters.lsp,
    javascriptreact = formatters.prettierd,
    json = formatters.lsp,
    lua = formatters.lsp,
    markdown = formatters.prettier,
    openscad = formatters.lsp,
    python = formatters.black,
    rust = formatters.lsp,
    scad = formatters.lsp,
    scss = formatters.lsp,
    sh = formatters.shfmt,
    terraform = formatters.lsp,
    typescript = formatters.prettierd,
    typescriptreact = formatters.prettierd,
    yaml = formatters.lsp,
    zig = formatters.lsp
  },
})
