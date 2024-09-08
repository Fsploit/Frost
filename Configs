local config = "fluent.txt"
local configFilePath = "config.txt"

function saveConfig(config)
    local file = io.open(configFilePath, "w")
    if file then
        for key, value in pairs(config) do
            file:write(key .. "=" .. tostring(value) .. "\n")
        end
        file:close()
        print("Config saved successfully.")
    else
        print("Error saving config.")
    end
end


function loadConfig()
    local config = {}
    local file = io.open(configFilePath, "r")
    if file then
        for line in file:lines() do
            local key, value = line:match("([^=]+)=([^=]+)")
            if key and value then
                config[key] = tonumber(value) or value
            end
        end
        file:close()
        print("Config loaded successfully.")
    else
        print("Error loading config.")
    end
    return config
end


local config = {
    autoSpam = true, -- Set true
    auraParry = false, -- Set false
    aimAssist = true, -- wadafak
    parryDelay = 100, -- Triple is a skidder
}


saveConfig(config)

local loadedConfig = loadConfig()

for key, value in pairs(loadedConfig) do
    print(key, value)
end

