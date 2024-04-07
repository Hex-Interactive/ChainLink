local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local Chain = require(script.Parent.Parent:WaitForChild("Chain"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

type Layer = { Step }
type Step = {
	class: string,
	data: any?,
	childLayers: { Layer }?,
}

local MAX_ROUTINE_STEPS = 20
local VALID_STEPS = table.freeze({
	Chain = true,
})

local function serializeLayer(parent: Instance): Layer
	local layer = {}

	for i = 0, MAX_ROUTINE_STEPS do
		local step = parent:FindFirstChild(tostring(i))
		if not step then
			break
		end

		if not step:IsA("Configuration") then
			Util.LogWarn(`invalid routine step "{step:GetFullName()}" found`)
			continue
		end

		local class = step:GetAttribute(Names.Attr.Class)
		if not VALID_STEPS[class] then
			Util.LogWarn(`routine step class "{class}" is unknown`)
			continue
		end

		local routineStep = {
			class = class,
			data = step:GetAttribute(Names.Attr.Data),
		}

		table.insert(layer, routineStep)
	end

	return layer
end

local function executeLayer(layer: Layer, _context: ChainTypes.Context)
	for _, step in layer do
		if step.class == "Chain" then
			if typeof(step.data) ~= "string" then
				Util.LogWarn(`routine "Chain" step data "{step.data}" should be a string`)
				continue
			end

			Chain.Execute(step.data :: string)
		end
	end
end

return function(routine: Model): ChainTypes.Call
	local layer = serializeLayer(routine)

	return function(context: ChainTypes.Context)
		executeLayer(layer, context)
		return nil
	end
end
