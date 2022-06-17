--// made by gq#0001 \\ --

-- Gui to Lua
-- Version: 3.2

-- [Instances]:

local main = Instance.new("Frame")
local input = Instance.new("TextBox")
local title = Instance.new("TextLabel")
local output = Instance.new("TextLabel")

-- [Services]:

local run_service = game:GetService("RunService")
local player_service = game:GetService("Players")

-- [Properties]:

local function randomletters(len)
	local returnedstr = ""
	for i = 1, len do
		returnedstr = returnedstr .. string.char(math.random(65,90)).. "-" .. string.char(math.random(5, 8))
	end
	return returnedstr
end


if (syn and syn.protect_gui) then
    central = Instance.new("ScreenGui")
    syn.protect_gui(central)
    central.Parent = game:GetService("CoreGui")
    central.Name = randomletters(math.random(5,8))
else
    central = Instance.new("ScreenGui")
    central.Parent = game:GetService("CoreGui")
    central.Name = randomletters(math.random(5,8))
end

main.Name = "main"
main.Parent = central
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BackgroundTransparency = 0.300
main.BorderSizePixel = 0
main.Position = UDim2.new(0.324444443, 0, 0.476190478, 0)
main.Size = UDim2.new(0, 318, 0, 176)
main.Active = true
main.Draggable = true

input.Name = "input"
input.Parent = main
input.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
input.BackgroundTransparency = 0.400
input.BorderSizePixel = 0
input.Position = UDim2.new(0.0314465426, 0, 0.187499985, 0)
input.Size = UDim2.new(0, 298, 0, 19)
input.Font = Enum.Font.Gotham
input.Text = ""
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.TextSize = 14.000
input.TextWrapped = true

title.Name = "title"
title.Parent = main
title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1.000
title.Size = UDim2.new(0, 318, 0, 22)
title.Font = Enum.Font.Gotham
title.Text = "central | admin commands"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14.000

output.Name = "output"
output.Parent = main
output.Active = true
output.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
output.BackgroundTransparency = 0.400
output.BorderSizePixel = 0
output.Position = UDim2.new(0.0314465426, 0, 0.392045468, 0)
output.Selectable = true
output.Size = UDim2.new(0, 298, 0, 97)
output.Font = Enum.Font.Gotham
output.Text = ""
output.TextColor3 = Color3.fromRGB(255, 255, 255)
output.TextSize = 14.000
output.TextWrapped = true
output.TextYAlignment = Enum.TextYAlignment.Top

-- [Main]:

local function out(text)
    output.Text = text
end

local commands = {}
local info = {}

local function makecommand(name, description, func)
    commands[name] = func
    info[name] = description
end

local function pastriez_crash()
    -- You thought
end

local player = player_service.LocalPlayer

input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local split = string.split(input.Text, " ")
        local command = split[1]
        local args = {}
        for i = 2, #split do
            table.insert(args, split[i])
        end

        local function findPlayer(name)
            for i,v in next, game.Players:GetChildren() do
                if v.Name:lower() == name:lower() then
                    return v
                end
            end
        end

        makecommand("help", "displays all the commands available", function()
            for i,v in next, commands do
                print(i .. ": " .. info[i])
            end
        end)

        makecommand("walkspeed", "walkspeed <int>; changes player walkspeed", function(arguments)
            if arguments[1] then
                player.Character.Humanoid.WalkSpeed = tonumber(arguments[1])
            end
        end)

        makecommand("jumppower", "jumppower <int>; changes player jumppower", function(arguments)
            if arguments[1] then
                player.Character.Humanoid.JumpPower = tonumber(arguments[1])
            end
        end)

        makecommand("pastriezcrash", "crashes pastriez bakery", function()
            assert(game.PlaceId == 3243063589, "not pastriez bakery")
            pastriez_crash()
        end)
        
        local noclip = false

        makecommand("noclip", "noclip <on/off>", function(arguments)
        	if arguments[1] == "on" then
        		noclip = true
        		noclip_l = run_service.Stepped:Connect(function()
                    if noclip == true and player.Character ~= nil then
                        for i,v in next, player.Character:GetDescendants() do
                            if v:IsA("BasePart") and v.CanCollide == true then
                                v.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if noclip_l then noclip_l:Disconnect() end;
			end
        end)

        makecommand("sit", "makes you sit", function()
            player.Character.Humanoid.Sit = true
        end)
        
        infjump = false
        
        makecommand("infjump", "infjump <on/off>", function(arguments)
        	if arguments[1] == "on" then
        		infjump = true
        		while infjump == true do
        			player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        			task.wait(0.1)
				end
            else
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("None")
			end
		end)
		
		makecommand("spasm", "spasm <on/off>; credits to infinite yield", function(arguments)
            local player_character = player.Character
            local animation_id = "33796059"
            spasm_anim = Instance.new("Animation")
            spasm_anim.AnimationId = "rbxassetid://"..animation_id
            spasm = player_character:FindFirstChildOfClass("Humanoid").Animator:LoadAnimation(spasm_anim)
			if arguments[1] == "on" then
				spasm:Play()
                spasm:AdjustSpeed(99)
            else
                spasm:Stop()
			end
		end)

        makecommand("tp", "tp <cframe>; TPs you to the given position", function(arguments)
            if player.Character ~= nil then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(arguments[1])
            end
        end)

        makecommand("goto", "goto <player name>; TPs you to the given player", function(arguments)
            if player.Character ~= nil then
                local target = tostring(arguments[1])
                local v = findPlayer(target)
                if v ~= nil then
                    player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                end
            end
        end)

        makecommand("fov", "fov <int>; Changes your FOV", function(arguments)
            local camera = workspace.CurrentCamera
            if camera ~= nil then
                camera.FieldOfView = tonumber(arguments[1])
            end
        end)

        makecommand("view", "view <player name>; Spectates the given player", function(arguments)
            if arguments[1] == "on" then
                local target = findPlayer(tostring(arguments[2]))
                local cc = workspace.CurrentCamera
                cc.CameraSubject = target.Character
                
                target.CharacterAdded:Connect(function()
                    if target.Character ~= nil then
                        cc.CameraSubject = target.Character
                    end
                end)
            else
                workspace.CurrentCamera.CameraSubject = player.Character
            end
        end)

        makecommand("destroy", "destroys the gui", function()
            central:Destroy()
        end)

        if commands[command] then
        	commands[command](args)
        else
            out("command not found")
            task.wait(2)
            out("")
		end
    end
end)
