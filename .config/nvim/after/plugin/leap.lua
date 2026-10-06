-- This will also be loaded in vsocde
--
local ok, leap = pcall(require, "leap")
if ok then
    leap.add_default_mappings()
end
