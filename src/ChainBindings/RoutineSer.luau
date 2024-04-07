local CollectionService = game:GetService("CollectionService")

local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local ChainRunner = require(script.Parent.Parent:WaitForChild("ChainRunner"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))
local Routines = require(script.Parent:WaitForChild("Routines"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))
local Mutexes = require(script.Parent:WaitForChild("Mutexes"))

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

local RoutineSer = {}

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

			ChainRunner.Execute(step.data :: string)
		end
	end
end

local function serialize(routine: Model): ChainTypes.Call
	local layer = serializeLayer(routine)

	return function(context: ChainTypes.Context)
		executeLayer(layer, context)
		return nil
	end
end

local function added(routine: Instance)
	local name = routine.Name
	if not routine:IsA("Model") then
		Util.LogWarn(`added routine "{name}" is not a model`)
		return
	end

	if Mutexes.IsLocked(name) then
		Util.LogWarn(`action by name routine's name "{name}" already exists`)
		return
	end

	Routines.Add(routine, {
		name = name,
		call = serialize(routine),
	})
end

local function removed(routine: Instance)
	if not routine:IsA("Model") then
		Util.LogWarn(`removed routine "{routine.Name}" is not a model`)
		return
	end

	Routines.Remove(routine)
end

function RoutineSer.Init()
	CollectionService:GetInstanceAddedSignal(Names.Tags.Routine):Connect(added)
	CollectionService:GetInstanceRemovedSignal(Names.Tags.Routine):Connect(removed)

	for _, routine in CollectionService:GetTagged(Names.Tags.Routine) do
		added(routine)
	end
end

return RoutineSer
