local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local IdInput = Instance.new("TextBox")
local SpawnButton = Instance.new("TextButton")
local Corner = Instance.new("UICorner")

ScreenGui.Name = "ElPasoBypassSpawner"
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true 

local MainCorner = Corner:Clone()
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 8)
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Border RP Script Injector"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
TitleLabel.TextSize = 16

IdInput.Name = "IdInput"
IdInput.Parent = MainFrame
IdInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
IdInput.Position = UDim2.new(0.1, 0, 0.3, 0)
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

SpawnButton.Name = "SpawnButton"
SpawnButton.Parent = MainFrame
SpawnButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SpawnButton.Position = UDim2.new(0.1, 0, 0.65, 0)
SpawnButton.Size = UDim2.new(0.8, 0, 0, 35)
SpawnButton.Font = Enum.Font.GothamBold
SpawnButton.Text = "Spawn + Compile Scripts"
SpawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnButton.TextSize = 14

local ButtonCorner = Corner:Clone()
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = SpawnButton

-- ADVANCED: Internal script compiler loop
local function executeVehicleScripts(vehicleModel)
    for _, child in pairs(vehicleModel:GetDescendants()) do
        -- Check for both regular Scripts and LocalScripts inside the model
        if child:IsA("LocalScript") or child:IsA("Script") then
            task.spawn(function()
                -- Bypasses the engine block by extracting raw source code directly 
                local success, scriptSource = pcall(function()
                    return child.Source
                end)
                
                -- Force compilation via Delta's environment thread injection wrapper
                if success and scriptSource and scriptSource ~= "" then
                    local compiledFunc, err = loadstring(scriptSource)
                    if compiledFunc then
                        -- Set the context environment so variables like 'script' refer to the correct part
                        getfenv(compiledFunc).script = child
                        local ran, executeError = pcall(compiledFunc)
                        if not ran then
                            print("[Script Error in " .. child.Name .. "]: " .. tostring(executeError))
                        end
                    else
                        print("[Compile Error in " .. child.Name .. "]: " .. tostring(err))
                    end
                end
            end)
        end
    end
end

SpawnButton.MouseButton1Click:Connect(function()
    local targetCleanId = IdInput.Text:gsub("%s+", "")
    if targetCleanId == "" then
        SpawnButton.Text = "ID Box Empty!"
        task.wait(1)
        SpawnButton.Text = "Spawn Vehicle"
        return
    end

    SpawnButton.Text = "Compiling Model..."
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    local loadSuccess, fetchedObjects = pcall(function()
        return game:GetObjects("rbxassetid://" .. targetCleanId)
    end)
    
    if loadSuccess and fetchedObjects and #fetchedObjects > 0 then
        local spawnedVehicle = fetchedObjects
        spawnedVehicle.Parent = workspace
        
        -- Positioning and unanchoring logic
        local finalPosition = rootPart.CFrame * CFrame.new(0, 10, -15)
        
        if spawnedVehicle:IsA("Model") then
            spawnedVehicle:PivotTo(finalPosition)
            for _, part in pairs(spawnedVehicle:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
            
            -- TRIGGER THE COMPILER: Force-runs all background code
            executeVehicleScripts(spawnedVehicle)
            
        elseif spawnedVehicle:IsA("BasePart") then
            spawnedVehicle.CFrame = finalPosition
            spawnedVehicle.Anchored = false
        end
        
        SpawnButton.Text = "Scripts Injected!"
    else
        SpawnButton.Text = "Load Error!"
    end

    task.wait(1.5)
    SpawnButton.Text = "Spawn Vehicle"
end)
