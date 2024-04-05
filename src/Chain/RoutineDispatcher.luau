local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Mutexes = require(script.Parent.Parent:WaitForChild("Mutexes"))
local ChainTypes = require(script.Parent:WaitForChild("ChainTypes"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local index: { [Model]: RoutineEntry } = {}

type RoutineEntry = {
	name: string,
	run: ChainTypes.Call<nil>,
}

local RoutineDispatcher = {}

function RoutineDispatcher.Export(): { [string]: ChainTypes.Call<nil> }
	local routines = {}

	for routine, entry in index do
		local name = entry.name
		if routines[name] then
			Util.LogWarn(`routine by name "{name}" already exists`)
			continue
		end

		if not CurrentMap.HasDescendant(routine) then
			continue
		end

		routines[name] = entry.run
	end

	return routines
end

function RoutineDispatcher.Add(routine: Model, entry: RoutineEntry)
	local name = entry.name
	if Mutexes.IsLocked(name) then
		Util.LogWarn(`action by name routine's "{name}" already exists`)
		return
	end

	index[routine] = entry
end

function RoutineDispatcher.Remove(routine: Model)
	if index[routine] then
		table.clear(index[routine])
	end
	index[routine] = nil
end

return RoutineDispatcher
