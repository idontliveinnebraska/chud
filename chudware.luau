local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()
local httpService = game:GetService("HttpService")
local fileName = "chudware_configs.json"

local camera = workspace.CurrentCamera
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local teams = replicatedStorage:WaitForChild("Teams")


--configs
local silentAimSettings = {
    enabled = true,
    hitChance = 100,
    fovRadius = 50,
    fovColor = Color3.fromRGB(255, 255, 255),
    tracerColor = Color3.fromRGB(255, 255, 255),
    wallcheck = true,
    teamcheck = false,
    showtracer = false,
    showfov = true,
    wallbang = false,
}

local espSettings = {
    color = Color3.fromRGB(255, 255, 255),
    thickness = 1.5,
    cornerSize = 0.2,
    enabled = true,
    teamcheck = false,
    
}

local chamsSettings = {
    fillColor = Color3.fromRGB(255, 0, 255),
    fillTransparency = 0,
    outlineTransparency = 1,
    enabled = false
}

local miscSettings = {
    customFov = false,
    desiredFov = 100,
}

--
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Radius = silentAimSettings.fovRadius
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Color = silentAimSettings.fovColor
fovCircle.Visible = true

local tracerLine = Drawing.new("Line")
tracerLine.Thickness = 1
tracerLine.Color = silentAimSettings.tracerColor
tracerLine.Transparency = 1
tracerLine.Visible = false

local function colorToTable(color)
    return {r = color.R, g = color.G, b = color.B}
end

local function tableToColor(tbl)
    return Color3.new(tbl.r, tbl.g, tbl.b)
end

local function saveConfig()
    local config = {
        silentAim = {
            enabled = silentAimSettings.enabled,
            hitChance = silentAimSettings.hitChance,
            fovRadius = silentAimSettings.fovRadius,
            fovColor = colorToTable(silentAimSettings.fovColor), 
            tracerColor = colorToTable(silentAimSettings.tracerColor), 
            wallcheck = silentAimSettings.wallcheck,
            teamcheck = silentAimSettings.teamcheck,
            showtracer = silentAimSettings.showtracer,
            showfov = silentAimSettings.showfov,
        },
        esp = {
            color = colorToTable(espSettings.color),
            thickness = espSettings.thickness,
            cornerSize = espSettings.cornerSize,
            enabled = espSettings.enabled,
            teamcheck = espSettings.teamcheck,
        },
        chams = {
            fillColor = colorToTable(chamsSettings.fillColor),
            fillTransparency = chamsSettings.fillTransparency,
            outlineTransparency = chamsSettings.outlineTransparency,
            enabled = chamsSettings.enabled
        },
        misc = miscSettings
    }
    writefile(fileName, httpService:JSONEncode(config))
end

local function loadConfig()
    if isfile(fileName) then
        local success, data = pcall(function() 
            return httpService:JSONDecode(readfile(fileName)) 
        end)
        
        if success then
            for k, v in pairs(data.silentAim) do 
                if k == "fovColor" or k == "tracerColor" then
                    silentAimSettings[k] = tableToColor(v)
                else
                    silentAimSettings[k] = v 
                end
            end
            for k, v in pairs(data.esp) do 
                if k == "color" then espSettings[k] = tableToColor(v) else espSettings[k] = v end
            end
                for k, v in pairs(data.chams) do 
                    if k == "fillColor" then chamsSettings[k] = tableToColor(v) else chamsSettings[k] = v end
                end
                for k, v in pairs(data.misc) do miscSettings[k] = v end
            end

            fovCircle.Radius = silentAimSettings.fovRadius
            fovCircle.Color = silentAimSettings.fovColor
            fovCircle.Visible = silentAimSettings.showfov
            
            tracerLine.Color = silentAimSettings.tracerColor
            tracerLine.Visible = silentAimSettings.showtracer

            if miscSettings.customFov then
                camera.FieldOfView = miscSettings.desiredFov
            end
        end
end

if isfile(fileName) then
    loadConfig()
end

--gui start
local window1 = engine.new({
    text = "chudware",
    size = UDim2.new(300, 400),
})

window1.open();

--aimtab
local tab1 = window1.new({
    text = "aimbot",
})

local aimLabel = tab1.new("label", {
    text = "aim",
    color = Color3.fromRGB(255, 255, 255),
})

local silentAimEnabled = tab1.new("switch", {
    text = "silent aim",
    on = silentAimSettings.enabled,
})
silentAimEnabled.event:Connect(function(bool)
    silentAimSettings.enabled = bool
end)
local wallbangEnabled = tab1.new("switch", {
    text = "wallbang",
    on = silentAimSettings.wallbang,
})
wallbangEnabled.event:Connect(function(bool)
    silentAimSettings.wallbang = bool
end)
local fovSize = tab1.new("slider", {
    text = "fov size",
    color = Color3.new(0.105882, 0.105882, 0.105882),
    min = 50,
    max = 250,
    value = silentAimSettings.fovRadius,
    rounding = 1,
})
fovSize.event:Connect(function(x)
    silentAimSettings.fovRadius = x
    fovCircle.Radius = x
end)
local showfov = tab1.new("switch", {
    text = "show fov",
    on = silentAimSettings.showfov,
})
showfov.event:Connect(function(bool)
    silentAimSettings.showfov = bool
    fovCircle.Visible = bool
end)

local fovColor = tab1.new("color", {
    color = silentAimSettings.fovColor,
    text = "fov color",
})
fovColor.event:Connect(function(color)
    silentAimSettings.fovColor = color
    fovCircle.Color = color
end)
local tracerColor = tab1.new("color", {
    color = silentAimSettings.tracerColor,
    text = "tracer color",
})
tracerColor.event:Connect(function(color)
    silentAimSettings.tracerColor = color
    tracerLine.Color = color
end)
local showtracer = tab1.new("switch", {
    text = "show tracer",
    on = silentAimSettings.showtracer,
})
showtracer.event:Connect(function(bool)
    silentAimSettings.showtracer = bool
    tracerLine.Visible = bool
end)

local wallcheck = tab1.new("switch", {
    text = "wallcheck",
    on = silentAimSettings.wallcheck,
})
wallcheck.event:Connect(function(bool)
    silentAimSettings.wallcheck = bool
end)
local teamcheck = tab1.new("switch", {
    text = "teamcheck",
    on = silentAimSettings.teamcheck,
})
teamcheck.event:Connect(function(bool)
    silentAimSettings.teamcheck = bool
end)

--esp tab
local tab2 = window1.new({
    text = "visuals",
})
local espLabel = tab2.new("label", {
    text = "esp",
    color = Color3.fromRGB(255, 255, 255),
})
local espEnabled = tab2.new("switch", {
    text = "esp",
    on = espSettings.enabled,
})
espEnabled.event:Connect(function(bool)
    espSettings.enabled = bool
end)
local espColor = tab2.new("color", {
    color = espSettings.color,
    text = "box color",
})
espColor.event:Connect(function(color)
    espSettings.color = color
end)
local chamsEnabled = tab2.new("switch", {
    text = "chams",
    on = chamsSettings.enabled,
})
chamsEnabled.event:Connect(function(bool)
    chamsSettings.enabled = bool
end)
local chamsColor = tab2.new("color", {
    color = chamsSettings.fillColor,
    text = "chams color",
})

local chamsTransparency = tab2.new("slider", {
    text = "chams transparency",
    color = Color3.new(0.105882, 0.105882, 0.105882),
    min = 0,
    max = 10,
    value = 0,
    rounding = 1,
})
local teamcheck2 = tab2.new("switch", {
    text = "teamcheck",
    on = espSettings.teamcheck,
})


--misc tab
local tab3 = window1.new({
    text = "misc",
})
local miscLabel = tab3.new("label", {
    text = "misc",
    color = Color3.fromRGB(255, 255, 255),
})
local customFov = tab3.new("switch", {
    text = "custom fov",
    on = miscSettings.customFov,
})
customFov.event:Connect(function(bool)
    miscSettings.customFov = bool
end)
local desiredFov = tab3.new("slider", {
    text = "desired fov",
    color = Color3.new(0.105882, 0.105882, 0.105882),
    min = 20,
    max = 120,
    value = miscSettings.desiredFov,
    rounding = 1,
})
desiredFov.event:Connect(function(value)
    miscSettings.desiredFov = value
    if miscSettings.customFov then
        camera.FieldOfView = value
    end
end)
local saveCfg = tab3.new("button", {
    text = "save config",
})
saveCfg.event:Connect(function()
    saveConfig()
end)


local closestHitPart = nil

local function getDirection(origin, position)
    return (position - origin).Unit
end

local function isVisible(targetPart)
    local character = localPlayer.Character
    if not character then return false end

    local origin = camera.CFrame.Position
    local direction = targetPart.Position - origin

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = { character, camera }

    local result = workspace:Raycast(origin, direction, rayParams)
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end

    return true
end

local function isSameTeam(player)
    if not silentAimSettings.teamcheck then return false end
    
    local ctFolder = teams:FindFirstChild("CT")
    local tFolder = teams:FindFirstChild("T")
    
    local localPlayerTeam = nil
    local targetPlayerTeam = nil

    if ctFolder:FindFirstChild(localPlayer.Name) then
        localPlayerTeam = "CT"
    elseif tFolder:FindFirstChild(localPlayer.Name) then
        localPlayerTeam = "T"
    end

    if ctFolder:FindFirstChild(player.Name) then
        targetPlayerTeam = "CT"
    elseif tFolder:FindFirstChild(player.Name) then
        targetPlayerTeam = "T"
    end

    if not localPlayerTeam or not targetPlayerTeam then return false end

    return localPlayerTeam == targetPlayerTeam
end
--chams
local chamsHighlights = {}

local function applychams(player)
    if player == localPlayer then return end

    local function onCharacterAdded(character)
        if chamsHighlights[player] then
            chamsHighlights[player]:Destroy()
        end

        local highlight = Instance.new("Highlight")
        highlight.Name = "⢦⇏ⲼⱱⰈ⥫⻉ⱨ⽅ℇ◞⦤┹⮏⟺⸡℩⩱⊽⦜⤹⁜⋎⻝◂⥝⎏✷⻲ⓓ⧓♰ⴈ⥼ⴽ∆⭆⛰"
        highlight.Adornee = character
        highlight.FillColor = chamsSettings.fillColor
        highlight.FillTransparency = chamsSettings.fillTransparency
        highlight.OutlineTransparency = chamsSettings.outlineTransparency

        local isTeammate = isSameTeam(player)
        highlight.Enabled = chamsSettings.enabled and (not espSettings.teamcheck or not isTeammate)
        
        highlight.Parent = character 
        chamsHighlights[player] = highlight
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

local function updateChams()
    for player, highlight in pairs(chamsHighlights) do
        if highlight and highlight.Parent then
            local isTeammate = isSameTeam(player)

            highlight.Enabled = chamsSettings.enabled and (not espSettings.teamcheck or not isTeammate)
            
            highlight.FillColor = chamsSettings.fillColor
            highlight.FillTransparency = chamsSettings.fillTransparency
            highlight.OutlineTransparency = chamsSettings.outlineTransparency
        else
            chamsHighlights[player] = nil
        end
    end
end
--
chamsColor.event:Connect(function(color)
    chamsSettings.fillColor = color
    updateChams()
end)
chamsTransparency.event:Connect(function(value)
    chamsSettings.fillTransparency = value / 10
    updateChams()
end)
teamcheck2.event:Connect(function(bool)
    espSettings.teamcheck = bool
    updateChams()
end)
-- esp
local function createEsp(player)
    local drawings = {
        topLeft     = { Drawing.new("Line"), Drawing.new("Line") },
        topRight    = { Drawing.new("Line"), Drawing.new("Line") },
        bottomLeft  = { Drawing.new("Line"), Drawing.new("Line") },
        bottomRight = { Drawing.new("Line"), Drawing.new("Line") }
    }
    local highlight = nil
    local connection

    connection = runService.RenderStepped:Connect(function()
        if not player.Character
            or not player.Character:FindFirstChild("HumanoidRootPart")
            or not player.Parent
            or not espSettings.enabled
        then
            for _, lines in pairs(drawings) do
                lines[1].Visible = false
                lines[2].Visible = false
            end
            if not player.Parent then
                connection:Disconnect()
            end
            return
        end

        local isTeammate = isSameTeam(player)
        
        if not player.Character
            or not player.Character:FindFirstChild("HumanoidRootPart")
            or not player.Parent
            or not espSettings.enabled
            or (espSettings.teamcheck and isTeammate)
        then
            for _, lines in pairs(drawings) do
                lines[1].Visible = false
                lines[2].Visible = false
            end
            if not player.Parent then
                connection:Disconnect()
            end
            return
        end
        
        local parts = player.Character:GetDescendants()
        local minX, minY = math.huge, math.huge
        local maxX, maxY = -math.huge, -math.huge
        local anyOnScreen = false

        for _, part in ipairs(parts) do
            if part:IsA("BasePart") then
                local pos = part.Position
                local size = part.Size
                local rot = part.CFrame.Rotation

                local corners = {
                    pos + rot * Vector3.new( size.X/2,  size.Y/2,  size.Z/2),
                    pos + rot * Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
                    pos + rot * Vector3.new( size.X/2, -size.Y/2,  size.Z/2),
                    pos + rot * Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
                    pos + rot * Vector3.new(-size.X/2,  size.Y/2,  size.Z/2),
                    pos + rot * Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
                    pos + rot * Vector3.new(-size.X/2, -size.Y/2,  size.Z/2),
                    pos + rot * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
                }

                for _, corner in ipairs(corners) do
                    local screenPos, onScreen = camera:WorldToViewportPoint(corner)
                    if onScreen then
                        anyOnScreen = true
                        if screenPos.X < minX then minX = screenPos.X end
                        if screenPos.X > maxX then maxX = screenPos.X end
                        if screenPos.Y < minY then minY = screenPos.Y end
                        if screenPos.Y > maxY then maxY = screenPos.Y end
                    end
                end
            end
        end

        if anyOnScreen then
            local x, y = minX, minY
            local sizeX = maxX - minX
            local sizeY = maxY - minY
            local cornerSize = math.max(sizeX, sizeY) * espSettings.cornerSize

            local function setLine(line, from, to)
                line.From = from
                line.To = to
                line.Color = espSettings.color
                line.Thickness = espSettings.thickness
                line.Visible = true
            end

            setLine(drawings.topLeft[1],     Vector2.new(x, y),                 Vector2.new(x + cornerSize, y))
            setLine(drawings.topLeft[2],     Vector2.new(x, y),                 Vector2.new(x, y + cornerSize))
            setLine(drawings.topRight[1],    Vector2.new(x + sizeX, y),         Vector2.new(x + sizeX - cornerSize, y))
            setLine(drawings.topRight[2],    Vector2.new(x + sizeX, y),         Vector2.new(x + sizeX, y + cornerSize))
            setLine(drawings.bottomLeft[1],  Vector2.new(x, y + sizeY),         Vector2.new(x + cornerSize, y + sizeY))
            setLine(drawings.bottomLeft[2],  Vector2.new(x, y + sizeY),         Vector2.new(x, y + sizeY - cornerSize))
            setLine(drawings.bottomRight[1], Vector2.new(x + sizeX, y + sizeY), Vector2.new(x + sizeX - cornerSize, y + sizeY))
            setLine(drawings.bottomRight[2], Vector2.new(x + sizeX, y + sizeY), Vector2.new(x + sizeX, y + sizeY - cornerSize))
        else
            for _, lines in pairs(drawings) do
                lines[1].Visible = false
                lines[2].Visible = false
            end
        end
    end)
end

if miscSettings.customFov then
    camera.FieldOfView = miscSettings.desiredFov
end

camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if camera.FieldOfView ~= miscSettings.desiredFov and miscSettings.customFov then
        camera.FieldOfView = miscSettings.desiredFov
    end
end)
-- main loop
runService.RenderStepped:Connect(function()
    local mousePos = userInputService:GetMouseLocation()
    if silentAimSettings.showfov then
        fovCircle.Position = mousePos
    else
        fovCircle.Visible = false
    end
    local closestPart = nil
    local closestDistance = silentAimSettings.fovRadius

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and (not silentAimSettings.teamcheck or not isSameTeam(player)) then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChild("Humanoid")

            if head and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen and silentAimSettings.wallcheck then
                    if isVisible(head) then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPart = head
                        end
                    end
                else
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPart = head
                    end
                end
            end
        end
    end

    closestHitPart = closestPart

    if closestHitPart and silentAimSettings.showtracer then
        if silentAimSettings.teamcheck and isSameTeam(players:GetPlayerFromCharacter(closestHitPart.Parent)) then
            tracerLine.Visible = false
            return
        end
        local screenPos = camera:WorldToViewportPoint(closestHitPart.Position)
        tracerLine.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
        tracerLine.To = Vector2.new(screenPos.X, screenPos.Y)
        tracerLine.Visible = true
    else
        tracerLine.Visible = false
    end
end)

-- hook
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }

    if self == workspace and method == "Raycast" and not checkcaller() and silentAimSettings.enabled then
        if closestHitPart then

            if silentAimSettings.wallbang and args[3] then
                local params = args[3]
                params.FilterType = Enum.RaycastFilterType.Include
                params.FilterDescendantsInstances = { closestHitPart.Parent }
            end
            local origin = args[1]
            args[2] = getDirection(origin, closestHitPart.Position) * 1000
            return oldNamecall(self, unpack(args))
        end
    end

    return oldNamecall(self, ...)
end))

for _, player in pairs(players:GetPlayers()) do
    if player ~= localPlayer then
        createEsp(player)
        applychams(player)
    end
end

players.PlayerAdded:Connect(function(player)
    createEsp(player)
    applychams(player)
end)
