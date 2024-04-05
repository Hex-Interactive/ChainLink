local CollectionService = game:GetService("CollectionService")

local RoutineDispatcher = require(script.Parent:WaitForChild("RoutineDispatcher"))
local ChainTypes = require(script.Parent:WaitForChild("ChainTypes"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))
local Chain = require(script.Parent)

local MAX_ROUTINE_STEPS = 20
local VALID_STEPS = table.freeze({
	Chain = true,
})

type RoutineLayer = { RoutineStep }
type RoutineStep = {
	class: string,
	data: any?,
	childLayers: { RoutineLayer }?,
}

local Routines = {}

local function serializeLayer(parent: Instance): RoutineLayer
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

local function executeLayer(layer: RoutineLayer, _context: ChainTypes.Context<nil>)
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

local function serialize(routine: Model): ChainTypes.Call<nil>
	local layer = serializeLayer(routine)

	return function(context: ChainTypes.Context<nil>)
		executeLayer(layer, context)
	end
end

local function added(routine: Instance)
	local name = routine.Name
	if not routine:IsA("Model") then
		Util.LogWarn(`added routine "{name}" is not a model`)
		return
	end

	RoutineDispatcher.Add(routine, {
		name = name,
		run = serialize(routine),
	})
end

local function removed(routine: Instance)
	if not routine:IsA("Model") then
		Util.LogWarn(`removed routine "{routine.Name}" is not a model`)
		return
	end

	RoutineDispatcher.Remove(routine)
end

function Routines.Init()
	CollectionService:GetInstanceAddedSignal(Names.Tags.Routine):Connect(added)
	CollectionService:GetInstanceRemovedSignal(Names.Tags.Routine):Connect(removed)

	for _, routine in CollectionService:GetTagged(Names.Tags.Routine) do
		added(routine)
	end
end

return Routines
