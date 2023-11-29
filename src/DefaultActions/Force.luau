local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.BehaviorContext)
		assert(context.target, "no target")

		local forceDirAtt = context.target:FindFirstChild("_ForceDirection", true)
		assert(
			forceDirAtt and forceDirAtt:IsA("Attachment"),
			`unable to find _ForceDirection ({context.target:GetFullName()})`
		)

		local magnitude = forceDirAtt:GetAttribute("Magnitude")
		local basePart = forceDirAtt.Parent
		assert(
			magnitude and basePart and basePart:IsA("BasePart"),
			`invalid _ForceDirection ({forceDirAtt:GetFullName()})`
		)

		local direction = CFrame.lookAt(basePart.Position, forceDirAtt.WorldPosition).LookVector
		basePart.AssemblyLinearVelocity = direction * magnitude
	end,
}
