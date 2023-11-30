local CollectionService = game:GetService("CollectionService")

local ActionRegistry = require(script.Parent:WaitForChild("ActionRegistry"))
local CurrentMap = require(script.Parent:WaitForChild("CurrentMap"))
local Regex = require(script.Parent.Parent:WaitForChild("Regex"))
local Types = require(script.Parent:WaitForChild("Types"))

local MAX_ROUTINE_STEPS = 20

local validRoutineStepClasses = {
	Chain = true,
	If = true,
}

local exp = {
	behaviorName = Regex([[/^[^\(]*/]]),
	parameter = Regex([[/\(([^)]+)\)/]]),
}

local ifEvals = {
	["=="] = function(a: any, b: any): boolean
		return a == b
	end,
	["~="] = function(a: any, b: any): boolean
		return a ~= b
	end,
	[">"] = function(a: any, b: any): boolean
		return a > b
	end,
	[">="] = function(a: any, b: any): boolean
		return a >= b
	end,
	["<"] = function(a: any, b: any): boolean
		return a < b
	end,
	["<="] = function(a: any, b: any): boolean
		return a <= b
	end,
}

local ChainInterpreter = {}

local function isUncertainType(desiredType: string): boolean
	local len = string.len(desiredType)
	return string.sub(desiredType, len, len) == "?"
end

local function parseInputType(input: string?, desiredType: string): any?
	if input == nil then
		if isUncertainType(desiredType) then
			return nil
		else
			error("missing input!")
		end
	end

	local rawType = string.gsub(desiredType, "?", "")
	if rawType == "string" then
		return input
	elseif rawType == "boolean" then
		return input == "true"
	elseif rawType == "number" then
		local converted = tonumber(input)
		assert(converted, "invalid number input!")
		return converted
	end

	error(`casting of type {rawType} is not supported!`)
end

local function parseChainParameter(parameter: string, source: string, extraData: Types.ExtraData?): Types.ChainParameter
	local rawInputs = string.split(parameter, ",")

	local parameterObject = {
		GetInputs = function(desiredTypes: { string }): { any }
			local inputs = {}
			for inputIndex, desiredType in desiredTypes do
				table.insert(inputs, parseInputType(rawInputs[inputIndex], desiredType))
			end
			return inputs
		end,

		GetInput = function(inputIndex: number, desiredType: string): any
			return parseInputType(rawInputs[inputIndex], desiredType)
		end,

		source = source,
		extraData = extraData or {},
		rawInputs = rawInputs,
	}

	return parameterObject
end

local function parseInstruction(
	instruction: string,
	source: string,
	extraData: Types.ExtraData?
): {
	behaviorName: string,
	parameter: Types.ChainParameter,
	targetId: string?,
}
	local segments = string.split(instruction, "->")
	assert(#segments > 0 and #segments < 3, `invalid instruction "{instruction}" found!`)

	local behaviorSegment, targetId
	if #segments == 1 then
		behaviorSegment = segments[1]
	else
		behaviorSegment = segments[2]
		targetId = segments[1]
	end

	local behaviorName = exp.behaviorName:exec(behaviorSegment)[1]
	local parameter = exp.parameter:exec(behaviorSegment)[2]

	return {
		behaviorName = behaviorName,
		parameter = parseChainParameter(parameter, source, extraData),
		targetId = targetId,
	}
end

local function serializeRoutineLayer(parent: Instance): Types.RoutineLayer
	local layer = {}

	local i = 0
	while i < MAX_ROUTINE_STEPS do
		i += 1

		local step = parent:FindFirstChild(tostring(i))
		if not step then
			break
		end

		assert(step:IsA("Configuration"), `invalid routine step "{step:GetFullName()}" found!`)

		local class = step:GetAttribute("Class")
		local data = step:GetAttribute("Data")
		assert(validRoutineStepClasses[class], `routine step class "{class}" is unknown!`)

		local stepStruct = {
			class = class,
			data = data,
		}

		if class == "If" then
			stepStruct.childLayers = {}

			local truePath = step:FindFirstChild("True")
			local falsePath = step:FindFirstChild("False")
			assert(truePath and falsePath, `invalid routine if "{step.Name}" step`)
			assert(truePath:IsA("Configuration"), `invalid routine true path for "{step.Name}" step`)
			assert(falsePath:IsA("Configuration"), `invalid routine false path for "{step.Name}" step`)

			stepStruct.childLayers[1] = serializeRoutineLayer(truePath)
			stepStruct.childLayers[2] = serializeRoutineLayer(falsePath)
		end

		table.insert(layer, stepStruct)
	end

	return layer
end

local function executeRoutineLayer(exec: Types.RoutineLayer, context: Types.ActionContext)
	for _, step in exec do
		if step.class == "Chain" then
			assert(typeof(step.data) == "string", `invalid routine step data "{step.data}" found`)
			ChainInterpreter.Execute(step.data, context.parameter.source, context.parameter.extraData)
		elseif step.class == "If" then
			assert(typeof(step.data) == "string", `invalid routine step data "{step.data}" found`)

			if not step.childLayers then
				continue
			end

			local data = string.gsub(step.data, "_SOURCE_", context.parameter.source)
			local result

			for operator, eval in pairs(ifEvals) do
				if string.find(data, operator) then
					local segments = string.split(data, operator)
					result = eval(segments[1], segments[2])
					break
				end
			end

			assert(result ~= nil, `invalid routine if step data "{data}" found`)
			executeRoutineLayer(step.childLayers[if result then 1 else 2], context)
		end
	end
end

local function serializeRoutine(routine: Model): (context: Types.ActionContext) -> ()
	local exec = serializeRoutineLayer(routine)

	return function(context: Types.ActionContext)
		executeRoutineLayer(exec, context)
	end
end

function ChainInterpreter.Execute(instructions: string, source: string, extraData: Types.ExtraData?)
	local list = string.split(instructions, ";")
	if #list <= 0 then
		print("not enough instructions!!")
		return
	end

	local links = {}
	for _, link in CollectionService:GetTagged("Link") do
		local rawId = link:GetAttribute("LinkId")
		if not rawId or not CurrentMap.HasDescendant(link) then
			continue
		end

		local ids = string.split(rawId, ";")
		if #ids <= 0 then
			continue
		end

		for _, id in ids do
			if not links[id] then
				links[id] = {}
			end

			table.insert(links[id], link)
		end
	end

	local routines = {}
	for _, routine in CollectionService:GetTagged("Routine") do
		if not CurrentMap.HasDescendant(routine) then
			continue
		end

		assert(routines[routine.Name] == nil, `routine "{routine.Name}" already defined!`)
		routines[routine.Name] = serializeRoutine(routine)
	end

	local exec = {}
	for _, instruction in list do
		local info = parseInstruction(instruction, source, extraData)

		local action = ActionRegistry.Get(info.behaviorName)
		local actionRun = if action then action.Run else nil
		local routineRun = routines[info.behaviorName]
		local behavior = (routineRun or actionRun) :: Types.Action
		assert(behavior, `invalid behavior "{info.behaviorName}" found!`)

		table.insert(exec, {
			behavior = behavior,
			parameter = info.parameter,
			targetId = info.targetId,
		})
	end

	for _, unpackedInstruction in exec do
		local behavior = unpackedInstruction.behavior
		local parameter = unpackedInstruction.parameter
		local targetId = unpackedInstruction.targetId

		if targetId then
			local targets = links[targetId]
			if not targets then
				continue
			end

			for _, target in targets do
				behavior({
					target = target,
					parameter = parameter,
				})
			end
		else
			behavior({
				target = nil,
				parameter = parameter,
			})
		end
	end
end

return ChainInterpreter
