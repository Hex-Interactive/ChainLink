local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))
local ChainUtil = require(script.Parent:WaitForChild("ChainUtil"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))

local MAX_ROUTINE_STEPS = 20
local VALID_STEPS = table.freeze({
	Chain = true,
	If = true,
})

local index = {}

local Routines = {}

local function serializeLayer(parent: Instance): Types.RoutineLayer
	local layer = {}

	for i = 0, MAX_ROUTINE_STEPS do
		local step = parent:FindFirstChild(tostring(i))
		if not step then
			break
		end

		ChainUtil.Assert(step:IsA("Configuration"), `invalid routine step "{step:GetFullName()}" found!`)

		local class = step:GetAttribute("Class")
		local data = step:GetAttribute("Data")
		ChainUtil.Assert(VALID_STEPS[class], `routine step class "{class}" is unknown!`)

		local routineStep = {
			class = class,
			data = data,
		}

		if class == "If" then
			local truePath = step:FindFirstChild("True")
			local falsePath = step:FindFirstChild("False")
			ChainUtil.Assert(truePath and falsePath, `invalid routine if "{step.Name}" step`)
			if not (truePath and falsePath) then
				break
			end

			ChainUtil.Assert(truePath:IsA("Configuration"), `invalid routine true path for "{step.Name}" step`)
			ChainUtil.Assert(falsePath:IsA("Configuration"), `invalid routine false path for "{step.Name}" step`)

			routineStep.childLayers = {}
			routineStep.childLayers[1] = serializeLayer(truePath)
			routineStep.childLayers[2] = serializeLayer(falsePath)
		end

		table.insert(layer, routineStep)
	end

	return layer
end

local function executeLayer(_layer: Types.RoutineLayer)
	-- TODO
end

local function serialize(routine: Model): Types.Routine
	local layer = serializeLayer(routine)

	return function()
		executeLayer(layer)
	end
end

function Routines.Get(name: string): Types.Routine?
	return index[name]
end

function Routines.Added(routine: Model)
	if not CurrentMap.HasDescendant(routine) or not routine:IsA("Model") then
		return
	end

	local name = routine.Name
	if index[name] then
		ChainUtil.LogError(`routine "{name}" already exists`)
		return
	end
	if Actions.Get(name) then
		ChainUtil.LogError(`routine name "{name}" already exists as an action`)
		return
	end

	index[name] = serialize(routine)
end

function Routines.Removed(routine: Model)
	index[routine.Name] = nil
end

return Routines
