local Types = require(script.Parent.Parent:WaitForChild("Types"))

type ValidatedParam = {
	part: BasePart,
	vel: Vector3,
}

return {
	ValidateTarget = function(target: Instance): (boolean, ValidatedParam?)
		local forceDirAtt = target:FindFirstChild("_ForceDirection", true)
		if not forceDirAtt or not forceDirAtt:IsA("Attachment") then
			return false, nil
		end

		local magnitude = forceDirAtt:GetAttribute("Magnitude")
		if typeof(magnitude) ~= "number" then
			return false, nil
		end

		local basePart = forceDirAtt.Parent
		if not basePart or not basePart:IsA("BasePart") then
			return false, nil
		end

		local direction = CFrame.lookAt(basePart.Position, forceDirAtt.WorldPosition).LookVector
		return true, {
			part = basePart,
			vel = direction * magnitude,
		}
	end,

	Run = function(context: Types.CallContext)
		local param = context.validatedParam :: ValidatedParam
		param.part.AssemblyLinearVelocity = param.vel
	end,
} :: Types.ActionModule
