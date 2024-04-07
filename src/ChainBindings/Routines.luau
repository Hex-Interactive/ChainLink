local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

type Entry = {
	name: string,
	call: ChainTypes.Call,
}

local cache: { [Model]: Entry } = {}

local Routines = {}

function Routines.Add(routine: Model, entry: Entry)
	cache[routine] = entry
end

function Routines.Remove(routine: Model)
	if cache[routine] then
		table.clear(cache[routine])
	end

	cache[routine] = nil
end

function Routines.Export(): { [string]: ChainTypes.CallDefinition }
	local routines = {}

	for routine, entry in cache do
		local name = entry.name
		if routines[name] then
			Util.LogWarn(`routine by name "{name}" already exists`)
			continue
		end

		if not CurrentMap.HasDescendant(routine) then
			continue
		end

		routines[name] = {
			parameters = {},
			target = false,
			call = entry.call,
		}
	end

	return routines
end

return Routines
