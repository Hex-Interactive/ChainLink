local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Chain = require(script.Parent.Parent.Parent:WaitForChild("Chain"))
local Logger = require(script.Parent.Parent:WaitForChild("Logger"))

type Entry = {
	name: string,
	call: Chain.Call,
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

function Routines.Export(): { [string]: Chain.CallDefinition }
	local routines = {}

	for routine, entry in cache do
		local name = entry.name
		if routines[name] then
			Logger.Warn(`routine by name "{name}" already exists`)
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
