repeat task.wait() until game:IsLoaded()

local Players = game:GetService('Players')
local CoreGui = game:GetService('CoreGui')
local Lighting = game:GetService("Lighting")

local PlayerGui = Players.LocalPlayer.PlayerGui
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local RunService = game:GetService('RunService')
local Ts = game:GetService('TweenService')
local Info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local UserInputService = game:GetService('UserInputService')
local HttpService = game:GetService('HttpService')

-- [NEW] Sound Function
local function PlayClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6042053626"
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

local Library = {
    Flags = {},
    Components = {}
}

function Library:Drag(v)
    v.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.Dragging = true
            
            self.DragStart = input.Position
            self.StartPosition = v.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self.Dragging = false
                end
            end)
  
        end
    end)

    v.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if self.Dragging and input.Position then
                local delta = input.Position - self.DragStart
                v.Position = UDim2.new(self.StartPosition.X.Scale, self.StartPosition.X.Offset + delta.X, self.StartPosition.Y.Scale, self.StartPosition.Y.Offset + delta.Y)
        
            end
        end
    end)
end

Library["1"] = Instance.new("ScreenGui", (RunService:IsStudio() and PlayerGui) or CoreGui);
Library["1"]["Name"] = [[Mobile_Gui]];
Library["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

Library["2"] = Instance.new("TextButton", Library["1"]);
Library["2"]["BorderSizePixel"] = 0;
Library["2"]["Modal"] = false;
Library["2"]["AutoButtonColor"] = false;
Library["2"]["TextSize"] = 14;
Library["2"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
Library["2"]["BackgroundColor3"] = Color3.fromRGB(28, 29, 34);
Library["2"]["FontFace"] = Font.new([[rbxasset://fonts/families/Montserrat.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
Library["2"]["Size"] = UDim2.new(0, 122, 0, 38);
Library["2"]["Name"] = [[Mobile]];
Library["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
Library["2"]["Text"] = [[]];
Library["2"]["Position"] = UDim2.new(0.021, -4, 0.918, -5);

Library["3"] = Instance.new("UICorner", Library["2"]);
Library["3"]["CornerRadius"] = UDim.new(0, 13);

Library["4"] = Instance.new("ImageLabel", Library["2"]);
Library["4"]["ZIndex"] = 0;
Library["4"]["BorderSizePixel"] = 0;
Library["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
Library["4"]["ImageTransparency"] = 0.2;
Library["4"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
Library["4"]["Image"] = [[rbxassetid://17183270335]];
Library["4"]["Size"] = UDim2.new(0, 144, 0, 58);
Library["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
Library["4"]["BackgroundTransparency"] = 1;
Library["4"]["Name"] = [[Shadow]];
Library["4"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

Library["5"] = Instance.new("ImageLabel", Library["2"]);
Library["5"]["BorderSizePixel"] = 0;
Library["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
Library["5"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
Library["5"]["Image"] = [[rbxassetid://134992015790041]];
Library["5"]["Size"] = UDim2.new(0, 15, 0, 15);
Library["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
Library["5"]["BackgroundTransparency"] = 1;
Library["5"]["Name"] = [[Icon]];
Library["5"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
function Library:Tween(object, goal, callback)
    local Tween = Ts:Create(object, Info, goal)
    Tween.Completed:Connect(callback or function() end)
    Tween:Play()
end

function Library:UpdateComponents()
    for _, comp in pairs(Library.Components) do
        if comp.type == 'toggle' then
            comp.obj:Toggle(Library.Flags[comp.flag], true)
        elseif comp.type == 'module_expanded' then
             comp.obj:Toggle(Library.Flags[comp.flag], true)
        elseif comp.type == 'mini_toggle' then
    
             if comp.obj and comp.obj.Set then
                comp.obj:Set(Library.Flags[comp.flag])
            end
        elseif comp.type == 'dropdown' then
            if comp.obj and comp.obj.Select then
                comp.obj:Select(Library.Flags[comp.flag] or nil, true)
            
            end
        elseif comp.type == 'slider' then
            if comp.obj and comp.obj.Set then
                comp.obj:Set(Library.Flags[comp.flag])
            end
        elseif comp.type == 'colorpicker' then
             if comp.obj and comp.obj.Set then
               
             comp.obj:Set(Library.Flags[comp.flag])
             end
        end
    end
end

function Library:SaveConfig(name)
    if name and name ~= '' then
        writefile('Byte/Configs/' .. name .. '.lua', HttpService:JSONEncode(Library.Flags))
    end
end

function Library:LoadConfig(name)
    if name and name ~= '' and isfile('Byte/Configs/' .. name .. '.lua') then
        local flags = HttpService:JSONDecode(readfile('Byte/Configs/' .. name .. '.lua'))
        Library.Flags = flags
    
        Library:UpdateComponents()
    end
end

function Library:DeleteConfig(name)
    if name and name ~= '' and isfile('Byte/Configs/' .. name .. '.lua') then
        delfile('Byte/Configs/' .. name .. '.lua')
    end
end

if not isfolder('Byte') then
    makefolder('Byte')
end

if not isfolder('Byte/Configs') then
    makefolder('Byte/Configs')
end

function Library.Add_Window(Title)
    local Gui = {}

    Gui["1"] = Instance.new("ScreenGui", (RunService:IsStudio() and PlayerGui) or CoreGui);
    Gui["1"]["Name"] = [[Stream]];
    Gui["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

    Gui["2"] = Instance.new("Frame", Gui["1"]);
    Gui["2"]["Active"] = true;
    Gui["2"]["BorderSizePixel"] = 0;
    Gui["2"]["BackgroundColor3"] = Color3.fromRGB(14, 14, 14);
    Gui["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    Gui["2"]["Size"] = UDim2.new(0, 640, 0, 355);
    Gui["2"]["Position"] = UDim2.new(0.5, 0, 0.4935, 0);
    Gui["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["2"]["Name"] = [[Container]];
    Gui["2"]["BackgroundTransparency"] = 0.1;
-- [NEW] Main UI Shadow
    Gui["Shadow"] = Instance.new("ImageLabel", Gui["2"]);
    Gui["Shadow"]["ZIndex"] = 0;
    Gui["Shadow"]["BorderSizePixel"] = 0;
    Gui["Shadow"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    Gui["Shadow"]["ImageTransparency"] = 0.2; -- Matches mobile button transparency
    Gui["Shadow"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    Gui["Shadow"]["Image"] = [[rbxassetid://17183270335]];
    Gui["Shadow"]["Size"] = UDim2.new(1, 24, 1, 24); -- Scaled relative to container + padding
    Gui["Shadow"]["ScaleType"] = Enum.ScaleType.Slice;
-- Ensures smooth edges on large UI
    Gui["Shadow"]["SliceCenter"] = Rect.new(25, 25, 25, 25);
    Gui["Shadow"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["Shadow"]["BackgroundTransparency"] = 1;
    Gui["Shadow"]["Name"] = [[Shadow]];
    Gui["Shadow"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    Gui["93"] = Instance.new("UIScale", Gui["2"]);
    
    Gui["3"] = Instance.new("Frame", Gui["2"]);
    Gui["3"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    Gui["3"]["Size"] = UDim2.new(0.95, 0, 0.95, 0);
    Gui["3"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    Gui["3"]["BackgroundTransparency"] = 1;
    
    Gui["4"] = Instance.new("UICorner", Gui["2"]);
    Gui["4"]["CornerRadius"] = UDim.new(0, 10);
-- Header Frame
    Gui["5"] = Instance.new("Frame", Gui["2"]);
    Gui["5"]["BorderSizePixel"] = 0;
    Gui["5"]["BackgroundColor3"] = Color3.fromRGB(28, 28, 28);
    Gui["5"]["Size"] = UDim2.new(0, 624, 0, 24);
    Gui["5"]["Position"] = UDim2.new(0.0125, 0, 0.02254, 0);
    Gui["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["5"]["Name"] = [[Header]];
    Gui["5"]["BackgroundTransparency"] = 0.5;

    Gui["6"] = Instance.new("UICorner", Gui["5"]);
    Gui["6"]["CornerRadius"] = UDim.new(0, 5);


    Gui["7"] = Instance.new("TextLabel", Gui["5"]);
    Gui["7"]["TextWrapped"] = true;
    Gui["7"]["BorderSizePixel"] = 0;
    Gui["7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    Gui["7"]["TextScaled"] = true;
    Gui["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    Gui["7"]["TextSize"] = 14;
    Gui["7"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    Gui["7"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
    Gui["7"]["BackgroundTransparency"] = 1;
    Gui["7"]["AnchorPoint"] = Vector2.new(0, 0.5);
    Gui["7"]["Size"] = UDim2.new(0, 78, 0, 12);
    Gui["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["7"]["Text"] = Title
    Gui["7"]["Name"] = [[Client]];
-- CHANGED POSITION TO ACCOUNT FOR ICON
    Gui["7"]["Position"] = UDim2.new(0.044, 0, 0.5, 0);

    Gui["8"] = Instance.new("UITextSizeConstraint", Gui["7"]);
    Gui["8"]["MaxTextSize"] = 12;
    Gui["8"]["MinTextSize"] = 12;

    Gui["9"] = Instance.new("Frame", Gui["5"]);
    Gui["9"]["BorderSizePixel"] = 0;
    Gui["9"]["BackgroundColor3"] = Color3.fromRGB(34, 34, 34);
    Gui["9"]["AnchorPoint"] = Vector2.new(1, 0.5);
    Gui["9"]["Size"] = UDim2.new(0, 64, 0, 17);
    Gui["9"]["Position"] = UDim2.new(0.995, 0, 0.5, 0);
    Gui["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["9"]["Name"] = [[SearchBar]];
    Gui["9"]["BackgroundTransparency"] = 0.5;

    Gui["a"] = Instance.new("UICorner", Gui["9"]);
    Gui["a"]["CornerRadius"] = UDim.new(0, 4);
    Gui["b"] = Instance.new("TextBox", Gui["9"]);
    Gui["b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
    Gui["b"]["PlaceholderColor3"] = Color3.fromRGB(255, 255, 255);
    Gui["b"]["BorderSizePixel"] = 0;
    Gui["b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
    Gui["b"]["TextWrapped"] = true;
    Gui["b"]["TextTransparency"] = 0.5;
    Gui["b"]["TextSize"] = 10;
    Gui["b"]["Name"] = [[Input]];
    Gui["b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    Gui["b"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
    Gui["b"]["AnchorPoint"] = Vector2.new(0, 0.5);
    Gui["b"]["ClearTextOnFocus"] = false;
    Gui["b"]["PlaceholderText"] = [[Search]];
    Gui["b"]["Size"] = UDim2.new(0, 39, 0, 14);
    Gui["b"]["Position"] = UDim2.new(0, 0, 0.5, 0);
    Gui["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["b"]["Text"] = [[]];
    Gui["b"]["BackgroundTransparency"] = 1;

    Gui["c"] = Instance.new("UITextSizeConstraint", Gui["b"]);
    Gui["c"]["MaxTextSize"] = 10;
    Gui["c"]["MinTextSize"] = 10;

    Gui["d"] = Instance.new("UIPadding", Gui["9"]);
    Gui["d"]["PaddingLeft"] = UDim.new(0, 9);

    Gui["e"] = Instance.new("ImageLabel", Gui["9"]);
    Gui["e"]["BorderSizePixel"] = 0;
    Gui["e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    Gui["e"]["AnchorPoint"] = Vector2.new(1, 0.5);
    Gui["e"]["Image"] = [[rbxassetid://72131122316767]];
    Gui["e"]["Size"] = UDim2.new(0, 17, 0, 17);
    Gui["e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["e"]["BackgroundTransparency"] = 1;
    Gui["e"]["Name"] = [[IconBG]];
    Gui["e"]["Position"] = UDim2.new(1, 0, 0.5, 0);

    Gui["f"] = Instance.new("ImageLabel", Gui["e"]);
    Gui["f"]["BorderSizePixel"] = 0;
    Gui["f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    Gui["f"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
    Gui["f"]["Image"] = [[rbxassetid://79243925523770]];
    Gui["f"]["Size"] = UDim2.new(0, 9, 0, 9);
    Gui["f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["f"]["BackgroundTransparency"] = 1;
    Gui["f"]["Name"] = [[Icon]];
    Gui["f"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

    Gui["10"] = Instance.new("ScrollingFrame", Gui["2"]);
    Gui["10"]["Active"] = true;
    Gui["10"]["BorderSizePixel"] = 0;
    Gui["10"]["CanvasSize"] = UDim2.new(0, 0, 0.5, 0);
    Gui["10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    Gui["10"]["Name"] = [[Tabs]];
    Gui["10"]["ScrollBarImageTransparency"] = 1;
    Gui["10"]["AutomaticCanvasSize"] = Enum.AutomaticSize.X;
    Gui["10"]["Size"] = UDim2.new(0, 138, 0, 308);
    Gui["10"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["10"]["Position"] = UDim2.new(0.0125, 0, 0.10986, 0);
    Gui["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
    Gui["10"]["ScrollBarThickness"] = 0;
    Gui["10"]["BackgroundTransparency"] = 1;

    Gui["11"] = Instance.new("UIListLayout", Gui["10"]);
    Gui["11"]["Padding"] = UDim.new(0, 6);
    Gui["11"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

    Library:Drag(Gui['2'])

    local Tween_Time = 0.65

    Library['2'].InputBegan:Connect(function(input, gpe)
        if gpe then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            PlayClickSound() -- [NEW]
            if Gui['1'].Enabled then
                local Tween_Out = Ts:Create(Gui["93"], TweenInfo.new(Tween_Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
      
                Scale = 0.01
                })

                Tween_Out:Play()
                Tween_Out.Completed:Wait()

                Gui['1'].Enabled = false
            else
     
                Gui['1'].Enabled = true
                Gui["93"].Scale = 0.01

                local Tween_In = Ts:Create(Gui["93"], TweenInfo.new(Tween_Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                    Scale = 1
                })
        
                Tween_In:Play()
            end
        end
    end)

    Library['2'].TouchTap:Connect(function()
        PlayClickSound() -- [NEW]
        if Gui['1'].Enabled then
            local Tween_Out = Ts:Create(Gui["93"], TweenInfo.new(Tween_Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
                Scale = 0.01
            })

     
            Tween_Out:Play()
            Tween_Out.Completed:Wait()

            Gui['1'].Enabled = false
        else
            Gui['1'].Enabled = true

            Gui["93"].Scale = 0.01

            local Tween_In = Ts:Create(Gui["93"], TweenInfo.new(Tween_Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {
            
                Scale = 1
            })

            Tween_In:Play()
        end
    end)

    Gui.CurrentTab = nil
    Gui.Tabs = Gui.Tabs or {} 
    Gui._defaultTab = nil 

    function Gui.Create_Tab(options)
        local Tab = {
            Active = false
      
        }

        table.insert(Gui.Tabs, Tab)

        Tab.Button = Instance.new("TextButton")
        Tab.Button.Parent = Gui["10"] 
        Tab.Button.BorderSizePixel = 0
        Tab.Button.AutoButtonColor = false
        Tab.Button.Text = ""
        Tab.Button.Size = UDim2.new(0, 138, 0, 27)
        Tab.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Tab.Button.BackgroundTransparency = 1
   
        Tab.Button.Name = "Tab"

        Instance.new("UICorner", Tab.Button).CornerRadius = UDim.new(0, 5)

        Tab.Icon = Instance.new("ImageLabel")
        Tab.Icon.Parent = Tab.Button
        Tab.Icon.BackgroundTransparency = 1
        Tab.Icon.BorderSizePixel = 0
        Tab.Icon.AnchorPoint = Vector2.new(0, 0.5)
        Tab.Icon.Position = UDim2.new(0.1, 0, 0.5, 0)
        Tab.Icon.Size = UDim2.new(0, 12, 0, 12)
    
        Tab.Icon.Image = options.icon
        Tab.Icon.ImageTransparency = 0
        Tab.Icon.ImageColor3 = Color3.fromRGB(170, 170, 170) 

        Tab.Title = Instance.new("TextLabel")
        Tab.Title.Parent = Tab.Button
        Tab.Title.BackgroundTransparency = 1
        Tab.Title.BorderSizePixel = 0
        Tab.Title.AnchorPoint = Vector2.new(0, 0.5)
        Tab.Title.Position = UDim2.new(0.225, 0, 0.5, 0)
       
        Tab.Title.Size = UDim2.new(0, 75, 0, 12)
        Tab.Title.TextWrapped = true
        Tab.Title.TextScaled = true
        Tab.Title.TextXAlignment = Enum.TextXAlignment.Left
        
        -- [FIXED] Updated font to match Byte UI (GothamSSm Bold Italic)
        Tab.Title.FontFace = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Bold, Enum.FontStyle.Italic)
        
        Tab.Title.TextSize = 12
        
        Tab.Title.Text = options.name
        Tab.Title.TextColor3 = Color3.fromRGB(170, 170, 170) 

        local constraint = Instance.new("UITextSizeConstraint", Tab.Title)
        constraint.MinTextSize = 12
        constraint.MaxTextSize = 12

        function Tab:SetActive(state)
            Tab.Active = state
            if state then
                
                Tab.Button.BackgroundTransparency = 0.4
                Tab.Title.TextColor3 = Color3.fromRGB(200, 200, 200)
                Tab.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            else
                Tab.Button.BackgroundTransparency = 1
                Tab.Title.TextColor3 = Color3.fromRGB(170, 170, 170)
        
                Tab.Icon.ImageColor3 = Color3.fromRGB(170, 170, 170)
            end
        end

        function Tab:Activate()
            for _, t in ipairs(Gui.Tabs) do
                t:SetActive(false) 
            end

            Tab:SetActive(true) 
 
            Gui.CurrentTab = Tab

            for _, folder in pairs(Gui["2"]:GetChildren()) do
                if folder:IsA('Folder') and folder.Name == 'Sections' then
                    for _, section in pairs(folder:GetChildren()) do
                      
                        if section:IsA('ScrollingFrame') then
                            section.Visible = false
                        end
                    end
                end
      
            end

            if Tab.Section then
                if Tab.Section.Left then Tab.Section.Left.Visible = true end
                if Tab.Section.Right then Tab.Section.Right.Visible = true end
            end
        end

        Tab.Button.MouseButton1Click:Connect(function() 
            PlayClickSound() -- [NEW]
            Tab:Activate() 
        end)
      
        Tab.Button.TouchTap:Connect(function() 
            PlayClickSound() -- [NEW]
            Tab:Activate() 
        end)

        Tab:SetActive(false)
        if #Gui.Tabs == 1 then Tab:Activate() end
        
       

        function Tab.Create_Section()
            local Section = {}

            Section.Folder = Instance.new("Folder", Gui["2"]);
            Section.Folder.Name = [[Sections]];

            Section["Left"] = Instance.new("ScrollingFrame", Section.Folder);
            Section["Left"]["Active"] = true;
            Section["Left"]["BorderSizePixel"] = 0;
            Section["Left"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
            Section["Left"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
            Section["Left"]["Name"] = options.name .. "_Left";
            Section["Left"]["ScrollBarImageTransparency"] = 1;
            Section["Left"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
            Section["Left"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
            Section["Left"]["Size"] = UDim2.new(0, 237, 0, 306);
            Section["Left"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
            Section["Left"]["Position"] = UDim2.new(0.24, 0, 0.11, 0);
            Section["Left"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
            Section["Left"]["ScrollBarThickness"] = 0;
            Section["Left"]["BackgroundTransparency"] = 1;
            Section["Left"].Visible = false 

            Section["LeftLayout"] = Instance.new("UIListLayout", Section["Left"]);
            Section["LeftLayout"]["Padding"] = UDim.new(0, 6);
            Section["LeftLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

            Section["Right"] = Instance.new("ScrollingFrame", Section.Folder);
            Section["Right"]["Active"] = true;
            Section["Right"]["BorderSizePixel"] = 0;
            Section["Right"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
            Section["Right"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
            Section["Right"]["Name"] = options.name .. "_Right";
            Section["Right"]["ScrollBarImageTransparency"] = 1;
            Section["Right"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
            Section["Right"]["ScrollingDirection"] = Enum.ScrollingDirection.Y;
            Section["Right"]["Size"] = UDim2.new(0, 237, 0, 306);
            Section["Right"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
            Section["Right"]["Position"] = UDim2.new(0.62, 0, 0.11, 0);
            Section["Right"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
            Section["Right"]["ScrollBarThickness"] = 0;
            Section["Right"]["BackgroundTransparency"] = 1;
            Section["Right"].Visible = false 

            Section["RightLayout"] = Instance.new("UIListLayout", Section["Right"]);
            Section["RightLayout"]["Padding"] = UDim.new(0, 6);
            Section["RightLayout"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

            Tab.Section = {
                Folder = Section.Folder,
                Left = Section["Left"],
                Right = Section["Right"]
            }

            if Tab.Active then
           
                Tab.Section.Left.Visible = true
                Tab.Section.Right.Visible = true
            else
                Tab.Section.Left.Visible = false
                Tab.Section.Right.Visible = false
            end

            if Gui._defaultTab == 
            Tab then
                Tab:Activate()
                Gui._defaultTab = nil
            end

            function Section.Create_Toggle(options)
                local Toggle = {
                    State 
                    = false,
                    flag = options.flag
                }

                local Target_Section
                if options.section == 'left' then
                    Target_Section = Section["Left"]
  
                else
                    Target_Section = Section["Right"]
                end

                Toggle["5a"] = Instance.new("Frame", Target_Section);
                Toggle["5a"]["BorderSizePixel"] = 0;
                Toggle["5a"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 27);
                Toggle["5a"]["ClipsDescendants"] = true;
                Toggle["5a"]["Size"] = UDim2.new(0, 237, 0, 28);
                Toggle["5a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Toggle["5a"]["Name"] = [[Module]];
                Toggle["5a"]["BackgroundTransparency"] = 0.5;
                
                Toggle["5b"] = Instance.new("UICorner", Toggle["5a"]);
                Toggle["5b"]["CornerRadius"] = UDim.new(0, 5);
                Toggle["88"] = Instance.new("ImageButton", Toggle["5a"])
                Toggle["88"]["BorderSizePixel"] = 0;
                Toggle["88"]["ImageTransparency"] = 1;
                Toggle["88"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Toggle["88"]["Image"] = [[rbxassetid://85806357619289]];
                Toggle["88"]["Size"] = UDim2.new(0, 237, 0, 28);
                Toggle["88"]["BackgroundTransparency"] = 1;
                Toggle["88"]["Name"] = [[Header]];
                Toggle["88"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);

                Toggle["89"] = Instance.new("ImageLabel", Toggle["88"]);
                Toggle["89"]["BorderSizePixel"] = 0;
                Toggle["89"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Toggle["89"]["ImageTransparency"] = 0.5;
                Toggle["89"]["Image"] = [[rbxassetid://119990362562133]];
                Toggle["89"]["Size"] = UDim2.new(0, 11, 0, 11);
                Toggle["89"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Toggle["89"]["BackgroundTransparency"] = 1;
                Toggle["89"]["Rotation"] = 0;
                Toggle["89"]["Name"] = [[Arrow]];
                Toggle["89"]["Position"] = UDim2.new(0.9, 0, 0.286, 0);

                Toggle["8a"] = Instance.new("TextButton", Toggle["88"]);
                Toggle["8a"]["BorderSizePixel"] = 0;
                Toggle["8a"]["AutoButtonColor"] = false;
                Toggle["8a"]["TextSize"] = 14;
                Toggle["8a"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
                Toggle["8a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Toggle["8a"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                Toggle["8a"]["AnchorPoint"] = Vector2.new(0, 0.5);
                Toggle["8a"]["Size"] = UDim2.new(0, 33, 0, 28);
                Toggle["8a"]["BackgroundTransparency"] = 1;
                Toggle["8a"]["Name"] = [[Keybind]];
                Toggle["8a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Toggle["8a"]["Text"] = [[]];
                Toggle["8a"]["Position"] = UDim2.new(0, 0, 0.5, 0);
                Toggle["8b"] = Instance.new("Frame", Toggle["8a"]);
                Toggle["8b"]["BorderSizePixel"] = 0;
                Toggle["8b"]["BackgroundColor3"] = Color3.fromRGB(63, 63, 63);
                Toggle["8b"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
                Toggle["8b"]["Size"] = UDim2.new(0, 20, 0, 20);
                Toggle["8b"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
                Toggle["8b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Toggle["8b"]["Name"] = [[Background]];
                Toggle["8b"]["BackgroundTransparency"] = 0.5;
                
                Toggle["8c"] = Instance.new("UICorner", Toggle["8b"]);
                Toggle["8c"]["CornerRadius"] = UDim.new(0, 4);

                Toggle["8d"] = Instance.new("TextLabel", Toggle["8b"]);
                Toggle["8d"]["BorderSizePixel"] = 0;
                Toggle["8d"]["TextTransparency"] = 0.5;
                Toggle["8d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Toggle["8d"]["TextSize"] = 10;
                Toggle["8d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                Toggle["8d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
                Toggle["8d"]["BackgroundTransparency"] = 1;
                Toggle["8d"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
                Toggle["8d"]["Size"] = UDim2.new(0, 12, 0, 12);
                Toggle["8d"]["Visible"] = false;
                Toggle["8d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Toggle["8d"]["Text"] = [[R]];
                Toggle["8d"]["Name"] = [[String]];
                Toggle["8d"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
                Toggle["8e"] = Instance.new("UITextSizeConstraint", Toggle["8d"]);
                Toggle["8e"]["MaxTextSize"] = 11;
                Toggle["8e"]["MinTextSize"] = 11;

                Toggle["8f"] = Instance.new("ImageLabel", Toggle["8b"]);
                Toggle["8f"]["BorderSizePixel"] = 0;
                Toggle["8f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Toggle["8f"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
                Toggle["8f"]["Image"] = [[rbxassetid://114520037763143]];
                Toggle["8f"]["Size"] = UDim2.new(0, 10, 0, 10);
                Toggle["8f"]["Visible"] = false;
                Toggle["8f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Toggle["8f"]["BackgroundTransparency"] = 1;
                Toggle["8f"]["Name"] = [[Delete]];
                Toggle["8f"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
                Toggle["90"] = Instance.new("ImageLabel", Toggle["8b"]);
                Toggle["90"]["BorderSizePixel"] = 0;
                Toggle["90"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Toggle["90"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
                Toggle["90"]["Image"] = [[rbxassetid://10734887784]];
                Toggle["90"]["Size"] = UDim2.new(0, 10, 0, 10);
                Toggle["90"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Toggle["90"]["BackgroundTransparency"] = 1;
                Toggle["90"]["Name"] = [[Edit]];
                Toggle["90"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

                Toggle["91"] = Instance.new("TextLabel", Toggle["8a"]);
                Toggle["91"]["TextWrapped"] = true;
                Toggle["91"]["BorderSizePixel"] = 0;
                Toggle["91"]["TextXAlignment"] = Enum.TextXAlignment.Left;
                Toggle["91"]["TextTransparency"] = 0.5;
                Toggle["91"]["TextScaled"] = true;
                Toggle["91"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Toggle["91"]["TextSize"] = 14;
                Toggle["91"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                Toggle["91"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
                Toggle["91"]["BackgroundTransparency"] = 1;
                Toggle["91"]["AnchorPoint"] = Vector2.new(0, 0.5);
                Toggle["91"]["Size"] = UDim2.new(0, 156, 0, 12);
                Toggle["91"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Toggle["91"]["Text"] = options.name;
                Toggle["91"]["Name"] = [[Title]];
                Toggle["91"]["Position"] = UDim2.new(1, 0, 0.5, 0);
                if Library.Flags[Toggle.flag] == nil then
                    Library.Flags[Toggle.flag] = false
                end

                if Library.Flags[Toggle.flag] then
                    Ts:Create(Toggle["88"], TweenInfo.new(0.2), { ImageTransparency = 0.5 }):Play()
              
                else
                    Ts:Create(Toggle["88"], TweenInfo.new(0.2), { ImageTransparency = 1 }):Play()
                end

                function Toggle:Toggle(state, silent)
                    if Library.Flags[self.flag] == nil then
              
                         Library.Flags[self.flag] = false
                    end

                    if state == nil then
                      Library.Flags[self.flag] = not Library.Flags[self.flag]
                   
                    else
                        Library.Flags[self.flag] = state
                    end

                    if Library.Flags[self.flag] then
                        Ts:Create(Toggle["88"], TweenInfo.new(0.2), { ImageTransparency = 0.5 }):Play()
 
                    else
                        Ts:Create(Toggle["88"], TweenInfo.new(0.2), { ImageTransparency = 1 }):Play()
                    end

                    if not silent and options.callback then
      
                        pcall(options.callback, Library.Flags[self.flag])
                    end
                end

                Toggle:Toggle(Library.Flags[Toggle.flag], true)

                Toggle['88'].InputBegan:Connect(function(input, gpe)
           
                    if gpe then return end
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        PlayClickSound() -- [NEW]
                        Toggle:Toggle()
                    end
                end)

  
                Toggle['88'].TouchTap:Connect(function()
                    PlayClickSound() -- [NEW]
                    Toggle:Toggle()
                end)

                table.insert(Library.Components, {type = 'toggle', obj = Toggle, flag = Toggle.flag})
                return Toggle
       
            end

            function Section.Create_Module(options)
                local Module = {
                    State = false,
                    flag = options.flag
                }

   
                local Target_Section
                if options.section == 'left' then
                    Target_Section = Section["Left"]
                else
                    Target_Section = Section["Right"]
      
                end

                Module["5a"] = Instance.new("Frame", Target_Section);
                Module["5a"]["BorderSizePixel"] = 0;
                Module["5a"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 27);
                Module["5a"]["ClipsDescendants"] = true;
                Module["5a"]["Size"] = UDim2.new(0, 237, 0, 28);
                Module["5a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Module["5a"]["Name"] = [[Module]];
                Module["5a"]["BackgroundTransparency"] = 0.5;

                Module["5b"] = Instance.new("UICorner", Module["5a"]);
                Module["5b"]["CornerRadius"] = UDim.new(0, 5);
                Module["5c"] = Instance.new("Frame", Module["5a"]);
                Module["5c"]["BorderSizePixel"] = 0;
                Module["5c"]["BackgroundColor3"] = Color3.fromRGB(28, 28, 28);
                Module["5c"]["AnchorPoint"] = Vector2.new(0, 1);
                Module["5c"]["ClipsDescendants"] = true;
                Module["5c"]["Size"] = UDim2.new(0, 237, 0, 0);
                Module["5c"]["Position"] = UDim2.new(0, 0, 1, 0);
                Module["5c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Module["5c"]["Name"] = [[Settings]];
                Module["5c"]["BackgroundTransparency"] = 1;

                Module["5d"] = Instance.new("UIListLayout", Module["5c"]);
                Module["5d"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
                Module["5d"]["VerticalAlignment"] = Enum.VerticalAlignment.Top;
                Module["5d"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
                Module["5d"]["Padding"] = UDim.new(0, 4);
                Module["5p"] = Instance.new("UIPadding", Module["5c"]);
                Module["5p"]["PaddingTop"] = UDim.new(0, 4);
                Module["5p"]["PaddingBottom"] = UDim.new(0, 4);
                Module["88"] = Instance.new("ImageButton", Module["5a"])
                Module["88"]["BorderSizePixel"] = 0;
                Module["88"]["ImageTransparency"] = 1;
                Module["88"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Module["88"]["Image"] = [[rbxassetid://85806357619289]];
                Module["88"]["Size"] = UDim2.new(0, 237, 0, 28);
                Module["88"]["BackgroundTransparency"] = 1;
                Module["88"]["Name"] = [[Header]];
                Module["88"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);

                Module["89"] = Instance.new("ImageLabel", Module["88"]);
                Module["89"]["BorderSizePixel"] = 0;
                Module["89"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Module["89"]["ImageTransparency"] = 0.5;
                Module["89"]["Image"] = [[rbxassetid://119990362562133]];
                Module["89"]["Size"] = UDim2.new(0, 11, 0, 11);
                Module["89"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Module["89"]["BackgroundTransparency"] = 1;
                Module["89"]["Rotation"] = 0;
                Module["89"]["Name"] = [[Arrow]];
                Module["89"]["Position"] = UDim2.new(0.9, 0, 0.286, 0);
                Module["8a"] = Instance.new("TextButton", Module["88"]);
                Module["8a"]["BorderSizePixel"] = 0;
                Module["8a"]["AutoButtonColor"] = false;
                Module["8a"]["TextSize"] = 14;
                Module["8a"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
                Module["8a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Module["8a"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                Module["8a"]["AnchorPoint"] = Vector2.new(0, 0.5);
                Module["8a"]["Size"] = UDim2.new(0, 33, 0, 28);
                Module["8a"]["BackgroundTransparency"] = 1;
                Module["8a"]["Name"] = [[Keybind]];
                Module["8a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Module["8a"]["Text"] = [[]];
                Module["8a"]["Position"] = UDim2.new(0, 0, 0.5, 0);
                Module["8b"] = Instance.new("Frame", Module["8a"]);
                Module["8b"]["BorderSizePixel"] = 0;
                Module["8b"]["BackgroundColor3"] = Color3.fromRGB(63, 63, 63);
                Module["8b"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
                Module["8b"]["Size"] = UDim2.new(0, 20, 0, 20);
                Module["8b"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
                Module["8b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Module["8b"]["Name"] = [[Background]];
                Module["8b"]["BackgroundTransparency"] = 0.5;
                
                Module["8c"] = Instance.new("UICorner", Module["8b"]);
                Module["8c"]["CornerRadius"] = UDim.new(0, 4);

                Module["8d"] = Instance.new("TextLabel", Module["8b"]);
                Module["8d"]["BorderSizePixel"] = 0;
                Module["8d"]["TextTransparency"] = 0.5;
                Module["8d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Module["8d"]["TextSize"] = 10;
                Module["8d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                Module["8d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
                Module["8d"]["BackgroundTransparency"] = 1;
                Module["8d"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
                Module["8d"]["Size"] = UDim2.new(0, 12, 0, 12);
                Module["8d"]["Visible"] = false;
                Module["8d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Module["8d"]["Text"] = [[R]];
                Module["8d"]["Name"] = [[String]];
                Module["8d"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
                Module["8e"] = Instance.new("UITextSizeConstraint", Module["8d"]);
                Module["8e"]["MaxTextSize"] = 11;
                Module["8e"]["MinTextSize"] = 11;

                Module["8f"] = Instance.new("ImageLabel", Module["8b"]);
                Module["8f"]["BorderSizePixel"] = 0;
                Module["8f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Module["8f"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
                Module["8f"]["Image"] = [[rbxassetid://114520037763143]];
                Module["8f"]["Size"] = UDim2.new(0, 10, 0, 10);
                Module["8f"]["Visible"] = false;
                Module["8f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Module["8f"]["BackgroundTransparency"] = 1;
                Module["8f"]["Name"] = [[Delete]];
                Module["8f"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
                Module["90"] = Instance.new("ImageLabel", Module["8b"]);
                Module["90"]["BorderSizePixel"] = 0;
                Module["90"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Module["90"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
                Module["90"]["Image"] = [[rbxassetid://10734887784]];
                Module["90"]["Size"] = UDim2.new(0, 10, 0, 10);
                Module["90"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Module["90"]["BackgroundTransparency"] = 1;
                Module["90"]["Name"] = [[Edit]];
                Module["90"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

                Module["91"] = Instance.new("TextLabel", Module["8a"]);
                Module["91"]["TextWrapped"] = true;
                Module["91"]["BorderSizePixel"] = 0;
                Module["91"]["TextXAlignment"] = Enum.TextXAlignment.Left;
                Module["91"]["TextTransparency"] = 0.5;
                Module["91"]["TextScaled"] = true;
                Module["91"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
                Module["91"]["TextSize"] = 14;
                Module["91"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                Module["91"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
                Module["91"]["BackgroundTransparency"] = 1;
                Module["91"]["AnchorPoint"] = Vector2.new(0, 0.5);
                Module["91"]["Size"] = UDim2.new(0, 156, 0, 12);
                Module["91"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
                Module["91"]["Text"] = options.name;
                Module["91"]["Name"] = [[Title]];
                Module["91"]["Position"] = UDim2.new(1, 0, 0.5, 0);
                function Module:UpdateHeight()
    -- Use specific TweenInfo for smoothness (Time, EasingStyle, EasingDirection)
                    local smoothTween = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

                    if Library.Flags[Module.flag] then
                        local ContentHeight = Module["5d"].AbsoluteContentSize.Y + 8
                        local TotalHeight = 28 + ContentHeight 
        
        -- Open Tween
                        Ts:Create(Module["5c"], smoothTween, { Size = UDim2.new(0, 237, 0, ContentHeight) }):Play()
                        Ts:Create(Module["5a"], smoothTween, 
                        { Size = UDim2.new(0, 237, 0, TotalHeight) }):Play()
                    else
        -- Close Tween
                        Ts:Create(Module["5c"], smoothTween, { Size = UDim2.new(0, 237, 0, 0) }):Play()
                        Ts:Create(Module["5a"], smoothTween, { Size = UDim2.new(0, 237, 0, 28) }):Play()
                    end
                end

                function Module:Toggle(state, silent)
                    if Library.Flags[self.flag] == 
                    nil then
                         Library.Flags[self.flag] = false
                    end

                    if state == nil then
                        Library.Flags[self.flag] = not Library.Flags[self.flag]
 
                    else
                        Library.Flags[self.flag] = state
                    end

                    if not silent and options.callback then
          
                        pcall(options.callback, Library.Flags[self.flag])
                    end

                    if Library.Flags[Module.flag] then
                        Ts:Create(Module["88"], TweenInfo.new(0.2), { ImageTransparency = 0.5 }):Play()
             
                        Ts:Create(Module["89"], TweenInfo.new(0.2), { Rotation = -90 }):Play()
                    else
                        Ts:Create(Module["88"], TweenInfo.new(0.2), { ImageTransparency = 1 }):Play()
                        -- FIXED: Always point arrow to 0 (Left/Standard) when 
                        -- closed
                        Ts:Create(Module["89"], TweenInfo.new(0.2), { Rotation = 0 }):Play()
                    end
                    
                    Module:UpdateHeight()
          
                end

                 if Library.Flags[Module.flag] == nil then
                    Library.Flags[Module.flag] = false
                end
                
                if Library.Flags[Module.flag] then 
                    Module:Toggle(true, true) else Module:Toggle(false, true) end
                
                Module['88'].MouseButton1Click:Connect(function()
                    PlayClickSound() -- [NEW]
                    Module:Toggle()
                end)

                function Module:Add_Dropdown(options)
          
                    local Drop = {}
                    local flag = options.flag or options.name

                    local parentWidth = 218
                    local titleHeight = 14
                
                    local headerHeight = 18
                    local optionsHeight = 85

                    Drop.Open = false

                    local Holder = Instance.new("Frame", Module["5c"])
                    Holder.Name = "DropdownHolder"
  
                    Holder.BackgroundTransparency = 1
                    Holder.Size = UDim2.new(0, parentWidth, 0, titleHeight + headerHeight)
                    Holder.ClipsDescendants = true
                    Holder.LayoutOrder = options.layoutorder or 0

       
                    local Title = Instance.new("TextLabel", Holder)
                    Title.Name = "Title"
                    Title.Size = UDim2.new(1, 0, 0, titleHeight)
                    Title.BackgroundTransparency = 1
              
                    Title.TextXAlignment = Enum.TextXAlignment.Left
                    Title.Text = options.name
                    Title.TextSize = 12
                    Title.TextTransparency = 0.35
                    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
  
                    Title.FontFace = Font.new(
                       "rbxasset://fonts/families/GothamSSm.json",
                        Enum.FontWeight.Medium
                    )

             
                    local Box = Instance.new("Frame", Holder)
                    Box.Name = "Box"
                    Box.Size = UDim2.new(0, parentWidth, 0, headerHeight)
                    Box.Position = UDim2.new(0, 0, 0, titleHeight)
                 
                    Box.BackgroundTransparency = 1
                    Box.BorderSizePixel = 0

                    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 5)

                    local Header = Instance.new("ImageButton", Box)
                    Header.Name = "Header"
   
                    Header.Size = UDim2.new(1, 0, 1, 0)
                    Header.BackgroundTransparency = 1
                    Header.BorderSizePixel = 0
                    Header.Image = "rbxassetid://101868605252082"
            
                    Header.ScaleType = Enum.ScaleType.Slice
                    Header.SliceCenter = Rect.new(6, 6, 6, 6)

                    local Value = Instance.new("TextLabel", Header)
                    Value.Name = "Option"
                   
                    Value.Size = UDim2.new(1, -24, 1, 0)
                    Value.Position = UDim2.new(0, 8, 0, 0)
                    Value.BackgroundTransparency = 1
                    Value.TextXAlignment = Enum.TextXAlignment.Left
                    Value.TextYAlignment = Enum.TextYAlignment.Center
   
                    Value.TextSize = 12
                    Value.TextTransparency = 0.5
                    Value.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Value.FontFace = Font.new(
             
                        "rbxasset://fonts/families/GothamSSm.json",
                        Enum.FontWeight.Medium
                    )

                    local Arrow = Instance.new("ImageLabel", Header)
                    Arrow.Name 
                    = "Arrow"
                    Arrow.Size = UDim2.new(0, 10, 0, 10)
                    Arrow.Position = UDim2.new(1, -14, 0.5, -5)
                    Arrow.BackgroundTransparency = 1
                    Arrow.ImageTransparency = 0.5
     
                    Arrow.Image = "rbxassetid://119990362562133"

                    local OptionsFrame = Instance.new("Frame", Box)
                    OptionsFrame.Name = "Options"
                    OptionsFrame.Position = UDim2.new(0, 0, 1, 4)
            
                    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                    OptionsFrame.BackgroundTransparency = 1
                    OptionsFrame.ClipsDescendants = true

                    local OptionsBg = Instance.new("ImageLabel", OptionsFrame)
                   
                    OptionsBg.Name = "Background"
                    OptionsBg.Size = UDim2.new(1, 0, 1, 0)
                    OptionsBg.BackgroundTransparency = 1
                    OptionsBg.Image = "rbxassetid://101868605252082"
                    OptionsBg.ScaleType = Enum.ScaleType.Slice
      
                    OptionsBg.SliceCenter = Rect.new(6, 6, 6, 6)
                    OptionsBg.ZIndex = 0

                    Instance.new("UICorner", OptionsBg).CornerRadius = UDim.new(0, 5)

                    local List = Instance.new("ScrollingFrame", OptionsFrame)
           
                    List.Name = "List"
                    List.Size = UDim2.new(1, -6, 0, optionsHeight)
                    List.Position = UDim2.new(0, 3, 0, 3)
                    List.AutomaticCanvasSize = Enum.AutomaticSize.Y
                 
                    List.ScrollBarThickness = 0
                    List.BackgroundTransparency = 1
                    List.BorderSizePixel = 0
                    List.ZIndex = 1

                    local Layout = Instance.new("UIListLayout", List)
     
                    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

                    function Drop:Select(value, silent)
                        if not table.find(options.options, value) then
                            value = options.options[1]
   
                        end

                        Value.Text = value
                        Library.Flags[flag] = value

                        if not silent 
                        and options.callback then
                            pcall(options.callback, value)
                        end
                    end

                    for _, opt in ipairs(options.options) 
                    do
                        local Btn = Instance.new("TextButton", List)
                        Btn.Size = UDim2.new(1, -4, 0, 18)
                        Btn.BackgroundTransparency = 1
                 
                        Btn.Text = opt
                        Btn.TextXAlignment = Enum.TextXAlignment.Left
                        Btn.TextSize = 12
                        Btn.TextTransparency = 0.5
             
                        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Btn.FontFace = Font.new(
                            "rbxasset://fonts/families/GothamSSm.json",
                            Enum.FontWeight.Medium
   
                        )
                        Btn.BorderSizePixel = 0
                        Btn.ZIndex = 2

                        Btn.MouseButton1Click:Connect(function()
                            PlayClickSound() -- [NEW]
                            Drop:Select(opt)
                            Drop.Open = false

                            Ts:Create(Arrow, TweenInfo.new(0.3), { Rotation = 0 }):Play()
           
                            Ts:Create(OptionsFrame, TweenInfo.new(0.3), {
                               Size = UDim2.new(1, 0, 0, 0)
                            }):Play()

                 
                            -- FIXED: Removed wait to remove delay
                            Holder.Size = UDim2.new(0, parentWidth, 0, titleHeight + headerHeight)
                            Module:UpdateHeight()
                    
                        end)
                    end

                    Header.MouseButton1Click:Connect(function()
                        PlayClickSound() -- [NEW]
                        Drop.Open = not Drop.Open

                        Ts:Create(Arrow, TweenInfo.new(0.3), {
   
                            Rotation = Drop.Open and -90 or 0
                        }):Play()

                        Ts:Create(OptionsFrame, TweenInfo.new(0.3), {
                  
                            Size = Drop.Open and UDim2.new(1, 0, 0, optionsHeight + 6)
                                          or UDim2.new(1, 0, 0, 0)
                        }):Play()

           
                        -- FIXED: Removed wait to remove delay
                        Holder.Size = Drop.Open
                            and UDim2.new(0, parentWidth, 0, titleHeight + headerHeight + optionsHeight + 10)
                 
                        or UDim2.new(0, parentWidth, 0, titleHeight + headerHeight)

                        Module:UpdateHeight()
                    end)

                    Drop:Select(Library.Flags[flag] or options.default, true)

                
                    table.insert(Library.Components, { type = 'dropdown', obj = Drop, flag = flag })

                    return Drop
                end

                local TweenService = game:GetService("TweenService")
                local Ts = TweenService

          
                local function clamp(n, a, b)
                    return math.max(a, math.min(b, n))
                end

                function Module:Add_MiniToggle(opts)
                    local options = opts or {}
         
                    local flag = options.flag or options.name or "mini_toggle"
                    local default = options.default == nil and false or options.default
                    local callback = options.callback

                    if Library.Flags[flag] == nil then
      
                        Library.Flags[flag] = default
                    end

                    local ui_scale = Library._ui_scale or 1
                    local width = 218
            
                    local height = 18
                    local trackW = 28 * ui_scale
                    local trackH = 12 * ui_scale
                    local circleSize = 6 * ui_scale

              
                    local Row = Instance.new("Frame", Module["5c"])
                    Row.Name = "MiniToggleRow"
                    Row.Size = UDim2.new(0, width, 0, height)
                    Row.BackgroundTransparency = 1
                    Row.LayoutOrder 
                    = options.layoutorder or 0

                    local Label = Instance.new("TextLabel", Row)
                    Label.Size = UDim2.new(1, -(trackW + 8), 1, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = options.name or 
                    "MiniToggle"
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
                    Label.TextSize = 12
                    Label.Font = Enum.Font.GothamMedium

          
                    local Holder = Instance.new("Frame", Row)
                    Holder.AnchorPoint = Vector2.new(1, 0.5)
                    Holder.Position = UDim2.new(1, -4, 0.5, 0)
                    Holder.Size = UDim2.new(0, trackW, 0, trackH)
             
                    Holder.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    Holder.BorderSizePixel = 0
                    Holder.BackgroundTransparency = 0.2

                    Instance.new("UICorner", Holder).CornerRadius = UDim.new(1, 0)

                    local 
                    fill = Instance.new("Frame", Holder)
                    fill.AnchorPoint = Vector2.new(0, 0.5)
                    fill.Position = UDim2.new(0, 0, 0.5, 0)
                    fill.Size = Library.Flags[flag] and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 0, 1, 0)
                 
                    fill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
                    fill.BorderSizePixel = 0
                    fill.BackgroundTransparency = Library.Flags[flag] and 0 or 0.6

                    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

                    local 
                    circle = Instance.new("Frame", Holder)
                    circle.AnchorPoint = Vector2.new(0.5, 0.5)
                    circle.Size = UDim2.new(0, circleSize, 0, circleSize)
                    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    circle.BorderSizePixel = 0
   
                    circle.ZIndex = 3

                    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

                    local offPos = UDim2.new(0, 4 + (circleSize / 2), 0.5, 0)
                    local onPos = UDim2.new(1, -(4 + (circleSize 
                    / 2)), 0.5, 0)

                    local function setVisual(state, instant)
                        Library.Flags[flag] = state

                        if instant then
                      
                            fill.Size = state and UDim2.new(1,0,1,0) or UDim2.new(0,0,1,0)
                            fill.BackgroundTransparency = state and 0 or 0.6
                            circle.Position = state and onPos or offPos
                     
                        return
                        end

                        Ts:Create(fill, TweenInfo.new(0.18), {
                            Size = state and UDim2.new(1,0,1,0) or UDim2.new(0,0,1,0),
         
                            BackgroundTransparency = state and 0 or 0.6
                        }):Play()

                        Ts:Create(circle, TweenInfo.new(0.18), {
                         
                        Position = state and onPos or offPos
                        }):Play()
                    end

                    setVisual(Library.Flags[flag], true)

                    local ToggleObj = {}

   
                    function ToggleObj:Set(state)
                        state = not not state
                        if Library.Flags[flag] == state then return end
                        
                        setVisual(state)
                        if callback then
                            pcall(callback, state)
                        end
                    end

 
                    function ToggleObj:Toggle()
                        self:Set(not Library.Flags[flag])
                    end

                    function ToggleObj:Get()
              
                        return Library.Flags[flag]
                    end

                    local function onClick()
                        ToggleObj:Toggle()
                    end

   
                    Holder.InputBegan:Connect(function(i, gpe)
                        if gpe then return end
                        if i.UserInputType == Enum.UserInputType.MouseButton1
                        or i.UserInputType == 
                        Enum.UserInputType.Touch then
                            PlayClickSound() -- [NEW]
                            onClick()
                        end
                    end)

                    Row.InputBegan:Connect(function(i, gpe)
      
                        if gpe then return end
                        if i.UserInputType == Enum.UserInputType.MouseButton1
                        or i.UserInputType == Enum.UserInputType.Touch then
                            PlayClickSound() -- [NEW]
                            onClick()
                        end
                    end)

                    table.insert(Library.Components, {
                        type = "mini_toggle",
    
                        obj = ToggleObj,
                        flag = flag
                    })

                    if default and callback then
        
                        task.defer(callback, true)
                    end

                    return ToggleObj
                end

                function Module:Add_Slider(s_opts)
         
                    local s_flag = s_opts.flag or s_opts.name
                    if Library.Flags[s_flag] == nil then Library.Flags[s_flag] = s_opts.default or s_opts.min end

                    local SliderFrame = Instance.new("Frame", Module["5c"])
                    SliderFrame.BackgroundTransparency = 1
        
                    SliderFrame.Size = UDim2.new(0, 218, 0, 35)
                    SliderFrame.LayoutOrder = s_opts.layoutorder or 0

                    local Title = Instance.new("TextLabel", SliderFrame)
                    Title.Text = s_opts.name
             
                    Title.Size = UDim2.new(1, 0, 0, 15)
                    Title.BackgroundTransparency = 1
                    Title.TextXAlignment = Enum.TextXAlignment.Left
                    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
                    
                    Title.Font = Enum.Font.GothamMedium
                    Title.TextSize = 12

                    local Value = Instance.new("TextLabel", SliderFrame)
                    Value.Text = tostring(Library.Flags[s_flag])
                    Value.Size = UDim2.new(1, 0, 0, 15)
     
                    Value.BackgroundTransparency = 1
                    Value.TextXAlignment = Enum.TextXAlignment.Right
                    Value.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Value.Font = Enum.Font.GothamMedium
               
                    Value.TextSize = 12

                    local BarBG = Instance.new("Frame", SliderFrame)
                    BarBG.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    BarBG.Size = UDim2.new(1, 0, 0, 4)
                    
                    BarBG.Position = UDim2.new(0, 0, 0, 22)
                    BarBG.BorderSizePixel = 0
                    Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

                    local Fill = Instance.new("Frame", BarBG)
                    Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 
                    Fill.Size = UDim2.new(0, 0, 1, 0)
                    Fill.BorderSizePixel = 0
                    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                    local Knob = Instance.new("Frame", BarBG)
      
                    Knob.Name = "Knob"
                    Knob.Visible = false 
                    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
                    Knob.Size = UDim2.new(0, 12, 0, 12)
             
                    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Knob.BorderSizePixel = 0
                    Knob.ZIndex = 2
                    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

                    local 
                    function Update(input)
                        local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                        local val = math.floor(((s_opts.max - s_opts.min) * pos) + s_opts.min)

                        Fill.Size = UDim2.new(pos, 0, 1, 0)
    
                        Knob.Position = UDim2.new(pos, 0, 0.5, 0) 
                        Value.Text = tostring(val)
                        Library.Flags[s_flag] = val
                      
                        if s_opts.callback then
                            pcall(s_opts.callback, val)
                        end
                    end

                    local p = 
                    (Library.Flags[s_flag] - s_opts.min) / (s_opts.max - s_opts.min)
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    Knob.Position = UDim2.new(p, 0, 0.5, 0) 

                    local Dragging = false
                    
                    BarBG.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            
                            Dragging = true;
                            Update(input)
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                
                        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            Update(input)
                        end
                    end)
          
           
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            Dragging = false
        
                        end
                    end)

                    local SliderObj = {}
                    function SliderObj:Set(val)
                    
                        if type(val) ~= "number" then return end
                        val = math.clamp(val, s_opts.min, s_opts.max)
                        Library.Flags[s_flag] = val
                        local p = (val - s_opts.min) / (s_opts.max - s_opts.min)
   
                        Fill.Size = UDim2.new(p, 0, 1, 0)
                        Knob.Position = UDim2.new(p, 0, 0.5, 0) 
                        Value.Text = tostring(val)
                  
                    end
                    table.insert(Library.Components, { type = 'slider', obj = SliderObj, flag = s_flag })
                    SliderObj:Set(Library.Flags[s_flag])
                end

function Module:Add_ColorPicker(cp_opts)
    local cp_flag = cp_opts.flag or cp_opts.name
    local default_color = cp_opts.default or Color3.fromRGB(255, 255, 255)
    
    if Library.Flags[cp_flag] 
    == nil then
        Library.Flags[cp_flag] = default_color
    end

    local h, s, v = Color3.toHSV(Library.Flags[cp_flag])
    local currentHue = h
    local currentSat = s
    local currentVal = v
    
    local ui_scale = Library._ui_scale or 1
    local trackW = 28 * ui_scale
    local trackH = 12 * ui_scale
    
    local CPFrame = Instance.new("Frame", Module["5c"])
    CPFrame.BackgroundTransparency = 1
    CPFrame.Size 
    = UDim2.new(0, 218, 0, 20)
    CPFrame.LayoutOrder = cp_opts.layoutorder or 0

    local Title = Instance.new("TextLabel", CPFrame)
    Title.Text = cp_opts.name
    Title.Size = UDim2.new(1, -30, 1, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 12

    local PreviewBox = Instance.new("ImageButton", CPFrame)
    PreviewBox.Name = "Preview"
    PreviewBox.AnchorPoint = Vector2.new(1, 0.5)
    PreviewBox.Position = UDim2.new(1, -4, 0.5, 0)
   
    PreviewBox.Size = UDim2.new(0, trackW, 0, trackH)
    PreviewBox.BackgroundColor3 = Library.Flags[cp_flag]
    PreviewBox.BorderSizePixel = 0
    Instance.new("UICorner", PreviewBox).CornerRadius = UDim.new(1, 0)

    -- POPUP CREATION (Outside Main Frame)
    local PickerPopup = Instance.new("Frame", Library["1"]) 
    PickerPopup.Name = "ColorPickerPopup"
    PickerPopup.Size = UDim2.new(0, 170, 0, 140)
    PickerPopup.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    PickerPopup.BorderSizePixel = 0
    PickerPopup.Visible = false
    PickerPopup.ZIndex = 100 
    Instance.new("UICorner", PickerPopup).CornerRadius = UDim.new(0, 6)
    
  
    -- DRAG LOGIC FOR POPUP (Mobile & PC)
    local draggingPopup = false
    local dragInputPopup, dragStartPopup, startPosPopup

    local function updatePopup(input)
        local delta = input.Position - dragStartPopup
        PickerPopup.Position = UDim2.new(startPosPopup.X.Scale, startPosPopup.X.Offset + delta.X, startPosPopup.Y.Scale, startPosPopup.Y.Offset + delta.Y)
    end

    PickerPopup.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingPopup = true
   
            dragStartPopup = input.Position
            startPosPopup = PickerPopup.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingPopup = false
         
                end
            end)
        end
    end)

    PickerPopup.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputPopup = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInputPopup and draggingPopup then
     
            updatePopup(input)
        end
    end)

    local PopupShadow = Instance.new("ImageLabel", PickerPopup)
    PopupShadow.ZIndex = 99
    PopupShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    PopupShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    PopupShadow.Size = UDim2.new(1, 24, 1, 24)
    PopupShadow.BackgroundTransparency = 1
    PopupShadow.Image = "rbxassetid://17183270335"
    PopupShadow.ImageTransparency = 0.3
    PopupShadow.ScaleType = Enum.ScaleType.Slice
    PopupShadow.SliceCenter = Rect.new(25, 25, 25, 25)

    local SVBox = Instance.new("Frame", PickerPopup)
 
    SVBox.Name = "SVBox"
    SVBox.Size = UDim2.new(1, -20, 1, -40)
    SVBox.Position = UDim2.new(0, 10, 0, 10)
    SVBox.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
    SVBox.BorderSizePixel = 0
    SVBox.ZIndex = 101
    Instance.new("UICorner", SVBox).CornerRadius = UDim.new(0, 4)

    local SatGradient = Instance.new("UIGradient", SVBox)
    SatGradient.Rotation = 0
    SatGradient.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
    SatGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})

    local ValBox = Instance.new("Frame", SVBox)
    ValBox.Name = "ValBox"
    ValBox.Size = UDim2.new(1,0,1,0)
 
    ValBox.BackgroundTransparency = 1
    ValBox.ZIndex = 102
    Instance.new("UICorner", ValBox).CornerRadius = UDim.new(0, 4)

    local ValGradient = Instance.new("UIGradient", ValBox)
    ValGradient.Rotation = 90
    ValGradient.Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0))
    ValGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})

    local SVCursor = Instance.new("Frame", SVBox)
    SVCursor.Name = "Cursor"
    SVCursor.Size = UDim2.new(0, 8, 0, 8)
    SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    SVCursor.BackgroundColor3 = Color3.new(1,1,1)
    SVCursor.BorderSizePixel = 0
    SVCursor.ZIndex = 103
    SVCursor.Position 
    = UDim2.new(currentSat, 0, 1 - currentVal, 0)
    Instance.new("UICorner", SVCursor).CornerRadius = UDim.new(1,0)

    local HueBox = Instance.new("Frame", PickerPopup)
    HueBox.Name = "HueBox"
    HueBox.Size = UDim2.new(1, -20, 0, 10)
    HueBox.Position = UDim2.new(0, 10, 1, -20)
    HueBox.BackgroundColor3 = Color3.new(1,1,1)
    HueBox.BorderSizePixel = 0
    HueBox.ZIndex = 101
    Instance.new("UICorner", HueBox).CornerRadius = UDim.new(0, 4)
    
    local HueGradient = Instance.new("UIGradient", HueBox)
    HueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)),
  
        ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167,1,1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333,1,1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)),
        ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667,1,1)),
        ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833,1,1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
    })

    local HueCursor = Instance.new("Frame", HueBox)
    HueCursor.Name = "Cursor"
    HueCursor.Size = UDim2.new(0, 4, 1, 0)
    HueCursor.AnchorPoint = Vector2.new(0.5, 0)
    HueCursor.BackgroundColor3 = Color3.new(1,1,1)
    HueCursor.BorderSizePixel = 0
  
    HueCursor.ZIndex = 103
    HueCursor.Position = UDim2.new(currentHue, 0, 0, 0)
    Instance.new("UICorner", HueCursor).CornerRadius = UDim.new(0, 2)

    local function UpdateColor()
        local newColor = Color3.fromHSV(currentHue, currentSat, currentVal)
        Library.Flags[cp_flag] = newColor
        PreviewBox.BackgroundColor3 = newColor
        SVBox.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
        if cp_opts.callback then
            pcall(cp_opts.callback, newColor)
     
        end
    end

    local draggingSV = false
    local draggingHue = false

    local function UpdateSV(input)
        local inputPos = Vector2.new(input.Position.X, input.Position.Y)
        local pos = inputPos - SVBox.AbsolutePosition 
        local size = SVBox.AbsoluteSize
        
        local relativeX = math.clamp(pos.X / size.X, 0, 1)
        local relativeY = math.clamp(pos.Y / 
        size.Y, 0, 1)
        
        currentSat = relativeX
        currentVal = 1 - relativeY
        
        Ts:Create(SVCursor, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { 
            Position = UDim2.new(currentSat, 0, 1 - currentVal, 0) 
        }):Play()
        
        UpdateColor()
   
    end

    local function UpdateHue(input)
        local inputPos = Vector2.new(input.Position.X, input.Position.Y)
        local pos = inputPos - HueBox.AbsolutePosition
        local size = HueBox.AbsoluteSize
        
        local relativeX = math.clamp(pos.X / size.X, 0, 1)
        currentHue = relativeX
        
        Ts:Create(HueCursor, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { 
   
         Position = UDim2.new(currentHue, 0, 0.5, 0) 
        }):Play()
        
        UpdateColor()
    end
    
    SVBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = true
            UpdateSV(input)
       
        end
    end)
    
    HueBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true
            UpdateHue(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if 
            draggingSV then UpdateSV(input) end
            if draggingHue then UpdateHue(input) end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSV = false
            draggingHue = false
        end
    end)

    PreviewBox.MouseButton1Click:Connect(function()
        PlayClickSound() -- [NEW]
        PickerPopup.Visible = not PickerPopup.Visible
        if PickerPopup.Visible then
            -- Initial Spawn Position (Right side of the preview box)
            local x = PreviewBox.AbsolutePosition.X + PreviewBox.AbsoluteSize.X + 15
            local y = PreviewBox.AbsolutePosition.Y
            PickerPopup.Position = UDim2.fromOffset(x, y)
        end
    end)

  
    local PickerObj = {}
    function PickerObj:Set(col)
        if typeof(col) ~= "Color3" then return end
        Library.Flags[cp_flag] = col
        h, s, v = Color3.toHSV(col)
        currentHue, currentSat, currentVal = h, s, v
        
        PreviewBox.BackgroundColor3 = col
        SVCursor.Position = UDim2.new(currentSat, 0, 1 - currentVal, 0)
       
        HueCursor.Position = UDim2.new(currentHue, 0, 0, 0)
        SVBox.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
    end

    table.insert(Library.Components, { type = 'colorpicker', obj = PickerObj, flag = cp_flag })

    return PickerObj
end

                table.insert(Library.Components, {type = 'module_expanded', obj = Module, flag = Module.flag})
                return Module
            end
    
         
            return Section
        end
        return Tab
    end

    function Gui:DefaultTab(identifier)
        local target = nil

        if identifier == nil then
            target = self.Tabs[1]
        elseif type(identifier) == "number" then
    
         target = self.Tabs[identifier]
        elseif type(identifier) == "string" then
            for _, t in ipairs(self.Tabs) do
                if t.Title and t.Title.Text == identifier then
                    target = t
                 
                    break
                end
            end
        elseif type(identifier) == "table" then
            target = identifier
        end

        if target then
            if target.Section then
           
                target:Activate()
            else
                self._defaultTab = target
            end
        end
    end

    return Gui
end

return Library
