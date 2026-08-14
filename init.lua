local function get_configs(config_prefix)
    local cmd = "find " .. config_prefix .. " -iname \"*.lua\" -type f"
    local p = io.popen(cmd)
    local ret = {}
    if p == nil then
        return ret
    end
    for cfg in p:lines() do
        if string.find(cfg, "init") == nil then
            table.insert(ret, cfg)
        end
    end
    p:close()
    return ret
end

local config_prefix = os.getenv("HOME") .. "/.config/nvim/"

local configs = get_configs(config_prefix)

vim.cmd('source ' .. config_prefix .. "lazy.lua")
for i=1, #(configs) do
	vim.cmd('source '  .. configs[i])
end
