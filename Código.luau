local version_kingshub = "v.0.3"

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = "King Hub | Game: Muscle Legends | Version [" .. version_kingshub .. "]",
    SubTitle = "by Danthy",
    TabWidth = 160,
    Size = UDim2.fromOffset(1087, 690.5),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
  Home = Window:CreateTab{
    	Title = "Lar",
    	Icon = "house"
    },
  Main = Window:CreateTab{
        Title = "Principal",
        Icon = "align-justify"
    },
  Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}
local Options = Library.Options

Library:Notify{
    Title = "King Hub",
    Content = "King Hub",
    SubContent = "King Hub",
    Duration = 13
}

Tabs.Home:AddSection("Link do servidor Discord")

Tabs.Home:CreateButton({
    Title = "Clique para copiar o link do Discord",
    Description = "Isso permite que você entre no nosso servidor Discord e receba pings de atualização e muito mais.",
    Callback = function()
      Library:Notify{
    Title = "King Hub Link do Discord copiado",
    Content = "Nosso Discord permite ver sneakpeaks. E tudo mais",
    Duration = 2
}
      wait(0.1)
      setclipboard("https://discord.gg/xbRqESfpD8")
    end
})

Tabs.Home:AddSection("Configurações do Player Local")

local speed = 350

local speedInput = Tabs.Home:AddInput("SpeedInput", {
    Title = "Entrada de velocidade",
    Default = tostring(speed),
    Placeholder = "Digite a velocidade",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            speed = num
            print("Speed set to:", speed)
            if speedToggle.Value then
                applySpeed()
            end
        end
    end
})

local speedToggle = Tabs.Home:AddToggle("SpeedToggle", {
    Title = "Habilitar Velocidade",
    Default = false
})

local function applySpeed()
    local player = game.Players.LocalPlayer
    if not player then return end

    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and speedToggle.Value then
        humanoid.WalkSpeed = speed
    elseif humanoid then
        humanoid.WalkSpeed = 350
    end
end

speedToggle:OnChanged(function()
    print("Toggle changed:", speedToggle.Value)
    applySpeed()
end)

local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    if speedToggle.Value then
        task.wait(0.1)
        applySpeed()
    end
end)

local ToggleInfiniteJump = Tabs.Home:AddToggle("Toggle_InfiniteJump", {Title = "Salto Infinito", Default = false})
ToggleInfiniteJump:OnChanged(function()
    if Options.Toggle_InfiniteJump.Value then
        local UserInputService = game:GetService("UserInputService")
        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        _G.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if Options.Toggle_InfiniteJump.Value then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        print("Infinite Jump enabled")
    else
        if _G.InfiniteJumpConnection then
            _G.InfiniteJumpConnection:Disconnect()
            _G.InfiniteJumpConnection = nil
        end
        print("Infinite Jump disabled")
    end
end)

local ToggleNoClip = Tabs.Home:AddToggle("Toggle_NoClip", {Title = "Sem clipe", Default = false})
ToggleNoClip:OnChanged(function()
    local RunService = game:GetService("RunService")
    local Player = game.Players.LocalPlayer

    if Options.Toggle_NoClip.Value then
        _G.NoclipConnection = RunService.Stepped:Connect(function()
            local Character = Player.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("No Clip enabled")
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
        end
        print("No Clip disabled")
    end
end)

Tabs.Main:AddSection("Funções Automáticas")

local Toggle = Tabs.Main:CreateToggle("AutoRep", {
  Title = "Elevador automático",
  Description = "Funciona com qualquer coisa",
  Default = false
})
Toggle:OnChanged(function(State)
    if State then
        task.spawn(function()
            while Toggle.Value do
                game:GetService("Players").LocalPlayer:WaitForChild("muscleEvent"):FireServer("rep")
                task.wait(0.1)
            end
        end)
    end
end)

local attackSpeed = "Normal"

local chooseAttackSpeedDropdown = Tabs.Main:CreateDropdown("Dropdown", {
    Title = "Escolha a velocidade",
    Values = {"Normal", "Médio", "Rapido"},
    Multi = false,
    Default = "Normal",
})

chooseAttackSpeedDropdown:SetValue("Normal")

chooseAttackSpeedDropdown:OnChanged(function(Value)
    attackSpeed = Value
end)

local function getAttackTime()
    if attackSpeed == "Rapido" then
        return 0
    elseif attackSpeed == "Médio" then
        return 0.15
    else
        return 0.35
    end
end

local Toggle = Tabs.Main:CreateToggle("AutoPunchWithAnim", {
    Title = "Soco automático",
    Description = "Use o menu suspenso acima para alterar a velocidade da perfuração",
    Default = false
})

Toggle:OnChanged(function(state)
    while state and Toggle.Value do
        local player = game.Players.LocalPlayer
        local char = game.Workspace:FindFirstChild(player.Name)
        local punchTool = player.Backpack:FindFirstChild("Punch") or (char and char:FindFirstChild("Punch"))

        if punchTool then
            if punchTool.Parent ~= char then
                punchTool.Parent = char
                task.wait(0.1)
            end

            local attackTime = punchTool:FindFirstChild("attackTime")
            if attackTime then
                attackTime.Value = getAttackTime()
            end

            punchTool:Activate()
        else
            Toggle:SetValue(false)
        end

        task.wait()
    end
end)

Tabs.Main:AddSection("Adicional")

local hideFramesToggle = Tabs.Main:CreateToggle("HideAllFrames", {Title = "Ocultar todos os quadros", Default = false})
hideFramesToggle:OnChanged(function(State)
	local rSto = game:GetService("ReplicatedStorage")
	for _, obj in pairs(rSto:GetChildren()) do
		if obj:IsA("Instance") and obj.Name:match("Frame$") then
			obj.Visible = not State
		end
	end
end)

Tabs.Main:AddSection("Fazendas Pack")

local fastRebirthsToggle = Tabs.Main:CreateToggle("FastRebirths", {
  Title = "Renascimentos rápidos",
  Description = "São necessários 7 Pacotes do Overlord do Caos!",
  Default = false
})
fastRebirthsToggle:OnChanged(function(State)
	if State then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ttvkaiser/Nebula-Hub/refs/heads/main/Muscle-Legends/Ddd.txt"))()
		hideFramesToggle:SetValue(true)
		else
		  hideFramesToggle:SetValue(false)
	end
end)

local speedGrindToggle = Tabs.Main:CreateToggle("SpeedGrind", {Title = "Força Rápida", Description = "São necessários 7 Pacotes do Overlord do Caos!", Default = false})
speedGrindToggle:OnChanged(function(State)
	if State then
		for i = 1, 14 do
			task.spawn(function()
				while speedGrindToggle.Value do
					game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
					task.wait(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001)
				end
			end)
		end
	end
end)

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
