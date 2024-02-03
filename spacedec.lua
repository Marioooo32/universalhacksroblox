-- Put this script in a LocalScript inside StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Function to create a highlight effect on a given part
local function createHighlight(part, color)
    local highlight = Instance.new("SelectionBox")
    highlight.Parent = part
    highlight.Adornee = part
    highlight.LineThickness = 0.1
    highlight.SurfaceTransparency = 0
    highlight.Color3 = color

    return highlight
end

-- Function to remove the highlight effect from a given part
local function removeHighlight(part)
    for _, child in pairs(part:GetChildren()) do
        if child:IsA("SelectionBox") then
            child:Destroy()
        end
    end
end

-- Function to update the highlights for all players
local function updatePlayerHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character
        if character then
            local head = character:FindFirstChild("Head")

            if head then
                -- Create or update the red highlight
                createHighlight(head, Color3.new(1, 0, 0))

                -- Create or update the white outline
                createHighlight(head, Color3.new(1, 1, 1))
            end
        end
    end
end

-- Function to remove highlights for all players
local function clearPlayerHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character
        if character then
            local head = character:FindFirstChild("Head")

            if head then
                removeHighlight(head)
            end
        end
    end
end

-- Function to lock the cursor onto the player's head
local function lockCursorOnHead()
    local player = Players.LocalPlayer
    local character = player.Character

    if character then
        local head = character:FindFirstChild("Head")

        if head then
            local mouse = player:GetMouse()
            local headScreenPos = head.Position:PointToWorldSpace(Vector3.new(0, 0, 0))

            mouse.X = headScreenPos.x
            mouse.Y = headScreenPos.y
        end
    end
end

-- Create a GUI with a black background, rounded corners, and a title
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "HighlightToggleGui"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 150, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "SpaceDeg"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.new(0, 0, 0)
title.BorderSizePixel = 0
title.Parent = frame

local highlightButton = Instance.new("TextButton")
highlightButton.Name = "ToggleHighlightButton"
highlightButton.Size = UDim2.new(1, 0, 0, 30)
highlightButton.Position = UDim2.new(0, 0, 0, 30)
highlightButton.Text = "Toggle Highlight"
highlightButton.Parent = frame

local espButton = Instance.new("TextButton")
espButton.Name = "EspButton"
espButton.Size = UDim2.new(1, 0, 0, 30)
espButton.Position = UDim2.new(0, 0, 0, 70)
espButton.Text = "Esp"
espButton.Parent = frame

local aimButton = Instance.new("TextButton")
aimButton.Name = "AimButton"
aimButton.Size = UDim2.new(1, 0, 0, 30)
aimButton.Position = UDim2.new(0, 0, 0, 110)
aimButton.Text = "Aim"
aimButton.Parent = frame

local highlightEnabled = true
local espEnabled = false
local aimEnabled = false

-- Function to toggle player highlights on button click
highlightButton.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled

    if highlightEnabled then
        updatePlayerHighlights()
    else
        clearPlayerHighlights()
    end
end)

-- Function to toggle ESP on button click
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled

    if espEnabled then
        updatePlayerHighlights()
    else
        clearPlayerHighlights()
    end
end)

-- Function to toggle Aim on button click
aimButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled

    if aimEnabled then
        UserInputService.InputChanged:Connect(lockCursorOnHead)
    else
        UserInputService.InputChanged:Disconnect(lockCursorOnHead)
    end
end)

-- Function to refresh player highlights every second
local function refreshPlayerHighlights()
    while wait(1) do
        if espEnabled then
            updatePlayerHighlights()
        else
            clearPlayerHighlights()
        end
    end
end

-- Connect the refresh function to the RenderStepped event
RunService.Heartbeat:Connect(refreshPlayerHighlights)
