local CollectionService = game:GetService("CollectionService")

local RoutineDispatcher = require(script.Parent:WaitForChild("RoutineDispatcher"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))
local Chain = require(script.Parent)

local MAX_ROUTINE_STEPS = 20
local VALID_STEPS = table.freeze({
	Chain = true,
	-- If = true,
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

		Util.Assert(step:IsA("Configuration"), `invalid routine step "{step:GetFullName()}" found`)

		local class = step:GetAttribute(Names.Attr.Class)
		local data = step:GetAttribute(Names.Attr.Data)
		Util.Assert(VALID_STEPS[class], `routine step class "{class}" is unknown`)

		local routineStep = {
			class = class,
			data = data,
		}

		-- if class == "If" then
		-- 	local truePath = step:FindFirstChild("True")
		-- 	local falsePath = step:FindFirstChild("False")
		-- 	Util.Assert(truePath and falsePath, `invalid routine if "{step.Name}" step`)
		-- 	if not (truePath and falsePath) then
		-- 		break
		-- 	end

		-- 	Util.Assert(truePath:IsA("Configuration"), `invalid routine true path for "{step.Name}" step`)
		-- 	Util.Assert(falsePath:IsA("Configuration"), `invalid routine false path for "{step.Name}" step`)

		-- 	routineStep.childLayers = {}
		-- 	routineStep.childLayers[1] = serializeLayer(truePath)
		-- 	routineStep.childLayers[2] = serializeLayer(falsePath)
		-- end

		table.insert(layer, routineStep)
	end

	return layer
end

local function executeLayer(layer: RoutineLayer)
	for _, step in layer do
		if step.class == "Chain" then
			Util.Assert(typeof(step.data) == "string", `routine "Chain" step data "{step.data}" should be a string`)
			Chain.Execute(step.data :: string)
			-- elseif step.class == "If" then
			-- 	Util.Assert(typeof(step.data) == "string", `routine "If" step data "{step.data}" should be a string`)
			-- 	if not step.childLayers then
			-- 		continue
			-- 	end

			-- 	local data = string.gsub(step.data :: string, "_SOURCE_", context.parameter.source)
			-- 	local result

			-- 	for operator, eval in ifEvals do
			-- 		if string.find(data, operator) then
			-- 			local segments = string.split(data, operator)
			-- 			result = eval(segments[1], segments[2])
			-- 			break
			-- 		end
			-- 	end

			-- 	Util.Assert(result ~= nil, `invalid routine "If" step data "{data}" found`)
			-- 	executeLayer(step.childLayers[if result then 1 else 2])
		end
	end
end

local function serialize(routine: Model): Types.Routine
	local layer = serializeLayer(routine)

	return function()
		executeLayer(layer)
	end
end

local function added(routine: Model)
	local name = routine.Name
	if not routine:IsA("Model") then
		Util.LogWarn(`routine "{name}" is not a model`)
		return
	end

	RoutineDispatcher.Add(routine, {
		name = name,
		run = serialize(routine),
	})
end

local function removed(routine: Model)
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
