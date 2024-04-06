local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local function failWarn()
	Util.LogWarn(`action "Force" target is invalid`)
end

return {
	target = true,

	call = function(context)
		local target = context.target :: Instance

		local forceDirAtt = target:FindFirstChild("_ForceDirection", true)
		if not forceDirAtt or not forceDirAtt:IsA("Attachment") then
			failWarn()
			return
		end

		local magnitude = forceDirAtt:GetAttribute("Magnitude")
		if typeof(magnitude) ~= "number" then
			failWarn()
			return
		end

		local basePart = forceDirAtt.Parent
		if not basePart or not basePart:IsA("BasePart") then
			failWarn()
			return
		end

		local direction = CFrame.lookAt(basePart.Position, forceDirAtt.WorldPosition).LookVector
		basePart.AssemblyLinearVelocity = direction * magnitude
	end,
} :: ChainTypes.CallDefinition
