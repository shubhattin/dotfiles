if vim.g.vscode then
  return
end

-- nvim-treesitter `main` rewrite (required for Neovim 0.12+)
require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local langs = {
  "javascript",
  "typescript",
  "tsx",
  "c",
  "c_sharp",
  "lua",
  "rust",
  "python",
  "go",
  "markdown",
  "markdown_inline",
  "json",
  "yaml",
  "html",
  "css",
  "bash",
}

-- Async install; no-op if already present
pcall(function()
  require("nvim-treesitter").install(langs)
end)

-- Highlighting is built into Neovim; start per buffer when a parser exists
vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting",
  callback = function(event)
    local ok = pcall(vim.treesitter.start, event.buf)
    if not ok then
      return
    end
    -- Optional experimental indent (safe to enable for most langs)
    vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
