local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Mutexes = require(script.Parent.Parent:WaitForChild("Mutexes"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local MAX_ROUTINE_STEPS = 20
local VALID_STEPS = table.freeze({
	Chain = true,
	-- If = true,
})

local index: RoutineIndex = {}

type Routine = () -> ()
type RoutineLayer = { RoutineStep }
type RoutineStep = {
	class: string,
	data: any?,
	childLayers: { RoutineLayer }?,
}
type RoutineIndex = {
	[string]: {
		root: Model,
		run: Routine,
	},
}

local Routines = {}

local function serializeLayer(parent: Instance): RoutineLayer
	local layer = {}

	for i = 0, MAX_ROUTINE_STEPS do
		local step = parent:FindFirstChild(tostring(i))
		if not step then
			break
		end

		Util.Assert(step:IsA("Configuration"), `invalid routine step "{step:GetFullName()}" found!`)

		local class = step:GetAttribute(Names.Attr.Class)
		local data = step:GetAttribute(Names.Attr.Data)
		Util.Assert(VALID_STEPS[class], `routine step class "{class}" is unknown!`)

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

local function executeLayer(_layer: RoutineLayer)
	-- TODO
end

local function serialize(routine: Model): Routine
	local layer = serializeLayer(routine)

	return function()
		executeLayer(layer)
	end
end

function Routines.Run(name: string): Types.Result<nil>
	local data = index[name]
	if not data or not CurrentMap.HasDescendant(data.root) then
		return {
			ok = false,
			err = `routine "{name}" not found`,
		}
	end

	data.run()

	return {
		ok = true,
	}
end

function Routines.Added(routine: Model)
	Util.Assert(routine:IsA("Model"), `invalid routine "{routine.Name}"`)

	local name = routine.Name
	Util.Assert(not Mutexes.IsLocked(name), `action or routine by name "{name}" already exists`)

	index[name] = {
		root = routine,
		run = serialize(routine),
	}

	Mutexes.Create(name)
end

function Routines.Removed(routine: Model)
	index[routine.Name] = nil
end

return Routines
