local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.CallContext)
		local target = context.target :: Instance
		local forceDirAtt = target:FindFirstChild("_ForceDirection", true) :: Attachment

		local magnitude = forceDirAtt:GetAttribute("Magnitude")
		local basePart = forceDirAtt.Parent :: BasePart

		local direction = CFrame.lookAt(basePart.Position, forceDirAtt.WorldPosition).LookVector
		basePart.AssemblyLinearVelocity = direction * magnitude
	end,
}
