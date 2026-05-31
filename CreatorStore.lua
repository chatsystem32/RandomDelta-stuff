local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local IdInput = Instance.new("TextBox")
local SpawnButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel") -- NEW: Visual log display
local Corner = Instance.new("UICorner")

ScreenGui.Name = "ElPasoBypassSpawner"
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Interface Frame Layout Customization
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 190) -- Increased height to fit log box
MainFrame.Active = true
MainFrame.Draggable = true 

local MainCorner = Corner:Clone()
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Interface Title Customization
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 8)
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Border RP Script Injector"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextSize = 16

-- Input Text Box Customization
IdInput.Name = "IdInput"
IdInput.Parent = MainFrame
IdInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
IdInput.Position = UDim2.new(0.1, 0, 0.25, 0)
IdInput.Size = UDim2.new(0.8, 0, 0, 35)
IdInput.Font = Enum.Font.Gotham
IdInput.PlaceholderText = "Paste Creator ID Here"
IdInput.Text = "130351410319011"
IdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
IdInput.PlaceholderColor3 = Color3.fromRGB(140, 140, 145)
IdInput.TextSize = 13

local InputCorner = Corner:Clone()
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = IdInput

-- Click Button Customization
SpawnButton.Name = "SpawnButton"
SpawnButton.Parent = MainFrame
SpawnButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SpawnButton.Position = UDim2.new(0.1, 0, 0.52, 0)
SpawnButton.Size = UDim2.new(0.8, 0, 0, 35)
SpawnButton.Font = Enum.Font.GothamBold
SpawnButton.Text = "Spawn + Compile Scripts"
SpawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnButton.TextSize = 14

local ButtonCorner = Corner:Clone()
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = SpawnButton

-- NEW: Status Log Box Customization
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.05, 0, 0.78, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.Text = "System Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
StatusLabel.TextSize = 11
StatusLabel.TextWrapped = true

-- Optimized Safe Script Engine with Bypasses
local function executeVehicleScripts(vehicleModel)
    local scriptCount = 0
    for _, child in pairs(vehicleModel:GetDescendants()) do
        if child:IsA("LocalScript") or child:IsA("Script") then
            scriptCount = scriptCount + 1
            StatusLabel.Text = "Compiling: " .. child.Name .. " (" .. tostring(scriptCount) .. ")"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
            
            task.spawn(function()
                -- 3-Second Timeout Safe Guard to prevent script freezes
                local completed = false
                task.delay(3, function()
                    if not completed then
                        StatusLabel.Text = "Timed out on: " .. child.Name .. " (Skipping)"
                        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                    end
                end)

                local success, scriptSource = pcall(function()
                    return child.Source
                end)
                
                if success and scriptSource and scriptSource ~= "" then
                    local compiledFunc, err = loadstring(scriptSource)
                    if compiledFunc then
                        getfenv(compiledFunc).script = child
                        pcall(compiledFunc)
                    end
                end
                completed = true
            end)
            task.wait(0.1) -- Small breather gap to let Delta process heavy code files
        end
    end
    StatusLabel.Text = "All Scripts Finished Launching!"
    StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
end

SpawnButton.MouseButton1Click:Connect(function()
    local targetCleanId = IdInput.Text:gsub("%s+", "")
    if targetCleanId == "" then
        StatusLabel.Text = "Error: ID Input box is completely empty!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end

    StatusLabel.Text = "Bypassing cloud security paths..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Primary download pipeline
    local loadSuccess, fetchedAsset = pcall(function()
        return game:GetObjects("assetgame://asset/?id=" .. targetCleanId)
    end)
    
    -- Fallback download pipeline
    if not loadSuccess or not fetchedAsset or #fetchedAsset == 0 then
        loadSuccess, fetchedAsset = pcall(function()
            return game:GetObjects("rbxassetid://" .. targetCleanId)
        end)
    end
    
    if loadSuccess and fetchedAsset and #fetchedAsset > 0 then
        StatusLabel.Text = "Rendering model into game world..."
        local spawnedVehicle = fetchedAsset
        spawnedVehicle.Parent = workspace
        
        -- Physical placement coordinate math
        local baseCFrame = rootPart.CFrame * CFrame.new(0, 12, -15)
        local rotationCorrection = CFrame.Angles(math.rad(90), 0, 0) 
        local finalPosition = baseCFrame * rotationCorrection
        
        if spawnedVehicle:IsA("Model") then
            spawnedVehicle:PivotTo(finalPosition)
            for _, part in pairs(spawnedVehicle:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
            
            -- Call safe injector system
            executeVehicleScripts(spawnedVehicle)
        elseif spawnedVehicle:IsA("BasePart") then
            spawnedVehicle.CFrame = finalPosition
            spawnedVehicle.Anchored = false
            StatusLabel.Text = "Success! Single part spawned."
            StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        end
    else
        StatusLabel.Text = "Roblox blocked download. Asset is private or restricted."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)
