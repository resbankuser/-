local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager") -- ใช้สำหรับส่งสัญญาณกดปุ่ม Keyboard ฝั่ง Client
local pGui = player:WaitForChild("PlayerGui")

-- [[ SETTINGS ]] 
local secretLink = "68747470733a2f2f706173746562696e2e636f6d2f7261772f5678514845665364"
local linkvertiseURL = "ผมขอโทษครับพี่"

local function decode(data)
    local str = ""
    for i = 1, #data, 2 do
        str = str .. string.char(tonumber(data:sub(i, i+1), 16))
    end
    return str
end

local keyURL = decode(secretLink)
local keyVerified = false

-- [[ UTILS ]]
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 8)
    corner.Parent = parent
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.8
    stroke.Parent = parent
end

-- [[ 1. INTRO & KEY UI ]]
local introGui = Instance.new("ScreenGui")
introGui.Name = "IntroSystem"
introGui.DisplayOrder = 10
introGui.Parent = pGui

local blackOut = Instance.new("Frame")
blackOut.Size = UDim2.new(1, 0, 1, 0)
blackOut.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
blackOut.Parent = introGui

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 320, 0, 240)
keyFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
keyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
keyFrame.BackgroundTransparency = 1
keyFrame.Parent = introGui
createCorner(keyFrame)
createStroke(keyFrame, Color3.fromRGB(100, 100, 100))

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 280, 0, 45)
keyInput.Position = UDim2.new(0.5, -140, 0.35, -20)
keyInput.PlaceholderText = "ENTER ACCESS KEY..."
keyInput.Text = ""
keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.Font = Enum.Font.GothamMedium
keyInput.Parent = keyFrame
createCorner(keyInput)

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0, 280, 0, 45)
submitBtn.Position = UDim2.new(0.5, -140, 0.6, 0)
submitBtn.Text = "VERIFY SYSTEM"
submitBtn.BackgroundColor3 = Color3.fromRGB(0, 102, 255)
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.Font = Enum.Font.GothamBold
submitBtn.Parent = keyFrame
createCorner(submitBtn)

local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0, 280, 0, 35)
getBtn.Position = UDim2.new(0.5, -140, 0.82, 0)
getBtn.Text = "GET KEY"
getBtn.BackgroundTransparency = 1
getBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
getBtn.Font = Enum.Font.Gotham
getBtn.TextSize = 12
getBtn.Parent = keyFrame

-- [[ 2. JUMPSCARE SYSTEM ]]
local jumpGui = Instance.new("ScreenGui")
jumpGui.Name = "JumpscareGui"
jumpGui.IgnoreGuiInset = true
jumpGui.Parent = pGui

local ghost = Instance.new("ImageLabel")
ghost.Name = "GhostImage"
ghost.Parent = jumpGui
ghost.Size = UDim2.new(1, 0, 1, 0)
ghost.BackgroundTransparency = 1
ghost.Image = "rbxassetid://15233587445"
ghost.Visible = false
ghost.ZIndex = 100

local sound = Instance.new("Sound")
sound.Name = "Scream"
sound.Parent = ghost
sound.SoundId = "rbxassetid://77339843352177"
sound.Volume = 10

local function runScare()
    ghost.Visible = true
    sound:Play()
    for i = 1, 25 do
        ghost.Position = UDim2.new(0, math.random(-40, 40), 0, math.random(-40, 40))
        task.wait(0.02)
    end
    task.wait(1.5)
    ghost.Visible = false
    ghost.Position = UDim2.new(0, 0, 0, 0)
end

-- [[ 3. MAIN MENU UI ]]
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoPilot_V25"
screenGui.Enabled = false 
screenGui.Parent = pGui

-- ปรับขนาด UI ให้ใหญ่ขึ้นรองรับฟังก์ชั่นใหม่ (จาก 420 เป็น 480)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 480)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
createCorner(mainFrame, UDim.new(0, 12))
createStroke(mainFrame, Color3.fromRGB(255, 255, 255), 1)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Text = "AUTOPILOT V2.5"
titleLabel.TextColor3 = Color3.fromRGB(0, 162, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = mainFrame

local function createInput(label, default, yPos)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, 210, 0, 20)
    l.Position = UDim2.new(0, 15, 0, yPos)
    l.Text = label
    l.TextColor3 = Color3.fromRGB(150, 150, 150)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    l.Parent = mainFrame
    
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(0, 210, 0, 35)
    b.Position = UDim2.new(0, 15, 0, yPos + 22)
    b.Text = default
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamMedium
    b.Parent = mainFrame
    createCorner(b)
    return b
end

local nitroInput = createInput("NITRO INTENSITY", "2", 50)
local speedInput = createInput("TARGET MAX SPEED", "280", 115)
local spamDelayInput = createInput("SPAM F DELAY (SEC)", "0.05", 180) -- ช่องตั้งความเร็วการสแปม F

-- [[ ปุ่มเปิด/ปิด AUTO SPAM F ]]
local toggleSpamBtn = Instance.new("TextButton")
toggleSpamBtn.Size = UDim2.new(0, 210, 0, 40)
toggleSpamBtn.Position = UDim2.new(0, 15, 0, 250)
toggleSpamBtn.Text = "AUTO SPAM F: OFF"
toggleSpamBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
toggleSpamBtn.TextColor3 = Color3.new(1, 1, 1)
toggleSpamBtn.Font = Enum.Font.GothamBold
toggleSpamBtn.TextSize = 12
toggleSpamBtn.Parent = mainFrame
createCorner(toggleSpamBtn)

-- ปุ่มเดิม Jumpscare Control
local stopSoundBtn = Instance.new("TextButton")
stopSoundBtn.Size = UDim2.new(0, 100, 0, 40)
stopSoundBtn.Position = UDim2.new(0, 15, 0, 410)
stopSoundBtn.Text = "STOP SOUND"
stopSoundBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopSoundBtn.TextColor3 = Color3.new(1, 1, 1)
stopSoundBtn.Font = Enum.Font.GothamBold
stopSoundBtn.TextSize = 11
stopSoundBtn.Parent = mainFrame
createCorner(stopSoundBtn)

local replayBtn = Instance.new("TextButton")
replayBtn.Size = UDim2.new(0, 100, 0, 40)
replayBtn.Position = UDim2.new(0, 125, 0, 410)
replayBtn.Text = "RE-PLAY SCARE"
replayBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 80)
replayBtn.TextColor3 = Color3.new(1, 1, 1)
replayBtn.Font = Enum.Font.GothamBold
replayBtn.TextSize = 11
replayBtn.Parent = mainFrame
createCorner(replayBtn)

-- [[ LOGIC ]]
local scriptActive = true
local isBoosting = false
local isSpammingF = false -- สถานะการสแปม F

-- ฟังก์ชันสแปม F รัวๆ
task.spawn(function()
    while true do
        if scriptActive and keyVerified and isSpammingF then
            -- จำลองการกดปุ่ม F ลงและปล่อยปุ่ม
            VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.01)
            VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            
            local delayTime = tonumber(spamDelayInput.Text) or 0.05
            task.wait(math.max(0.01, delayTime))
        else
            task.wait(0.1)
        end
    end
end)

-- ปุ่มคลิกเปิด/ปิด สแปม F
toggleSpamBtn.MouseButton1Click:Connect(function()
    isSpammingF = not isSpammingF
    if isSpammingF then
        toggleSpamBtn.Text = "AUTO SPAM F: ON"
        toggleSpamBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
    else
        toggleSpamBtn.Text = "AUTO SPAM F: OFF"
        toggleSpamBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

submitBtn.MouseButton1Click:Connect(function()
    submitBtn.Text = "VERIFYING..."
    local success, currentKey = pcall(function() return game:HttpGet(keyURL) end)
    
    if success and keyInput.Text:gsub("%s+", "") == currentKey:gsub("%s+", "") then
        keyVerified = true
        submitBtn.Text = "AUTHORIZED"
        submitBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
        task.wait(0.5)
        
        tweenService:Create(blackOut, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        tweenService:Create(keyFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -160, 0.6, 0), BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        
        screenGui.Enabled = true
        introGui:Destroy()
        task.wait(1)
        runScare()
    else
        submitBtn.Text = "ACCESS DENIED"
        submitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        submitBtn.Text = "VERIFY SYSTEM"
        submitBtn.BackgroundColor3 = Color3.fromRGB(0, 102, 255)
    end
end)

getBtn.MouseButton1Click:Connect(function()
    setclipboard(linkvertiseURL)
    getBtn.Text = "LINK COPIED!"
    task.wait(2)
    getBtn.Text = "GET KEY"
end)

stopSoundBtn.MouseButton1Click:Connect(function()
    sound:Stop()
end)

replayBtn.MouseButton1Click:Connect(function()
    task.spawn(runScare)
end)

runService.Heartbeat:Connect(function()
    if not scriptActive or not isBoosting or not keyVerified then return end
    
    local nitroPower = tonumber(nitroInput.Text) or 2
    local targetMaxSpeed = tonumber(speedInput.Text) or 280
    
    local char = player.Character
    local seat = char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart
    
    if seat and seat:IsA("VehicleSeat") then
        seat.MaxSpeed = targetMaxSpeed + 15
        if seat.AssemblyLinearVelocity.Magnitude < targetMaxSpeed then
            seat:ApplyImpulse(seat.CFrame.LookVector * (seat.AssemblyMass * nitroPower * 0.22))
            seat:ApplyImpulse(Vector3.new(0, -seat.AssemblyMass * 0.4, 0))
        end
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if not scriptActive or not keyVerified or processed then return end
    if input.KeyCode == Enum.KeyCode.X then
        isBoosting = true
    elseif input.KeyCode == Enum.KeyCode.M then
        mainFrame.Visible = not mainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.K then
        scriptActive = false
        isSpammingF = false
        screenGui:Destroy()
        jumpGui:Destroy()
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        isBoosting = false
    end
end)
