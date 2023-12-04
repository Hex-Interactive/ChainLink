local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Mutexes = require(script.Parent.Parent:WaitForChild("Mutexes"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local index = {}

type RoutineEntry = {
	root: Model,
	run: Types.Routine,
}

local RoutineDispatcher = {}

function RoutineDispatcher.Run(name: string): Types.Result<nil>
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

function RoutineDispatcher.Add(name: string, entry: RoutineEntry)
	Util.Assert(not Mutexes.IsLocked(name), `action or routine by name "{name}" already exists`)
	Mutexes.Create(name)
	index[name] = entry
end

function RoutineDispatcher.Remove(name: string)
	if index[name] then
		table.clear(index[name])
	end
	index[name] = nil
	Mutexes.Clear(name)
end

return RoutineDispatcher
