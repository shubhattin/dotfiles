if vim.g.vscode then
  return
end

-- Non-LSP Mason tools (formatters). LSP servers are handled in lsp.lua.
local tools = {
  "prettierd",
  "prettier",
  "black",
  "shfmt",
  "stylua",
}

local ok, registry = pcall(require, "mason-registry")
if not ok then
  return
end

local function ensure_tool(name)
  local success, pkg = pcall(registry.get_package, name)
  if not success or not pkg then
    return
  end
  if not pkg:is_installed() then
    pkg:install()
  end
end

registry.refresh(function()
  for _, name in ipairs(tools) do
    ensure_tool(name)
  end
end)
