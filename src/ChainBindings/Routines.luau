local CollectionService = game:GetService("CollectionService")

local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local serializeRoutine = require(script.Parent:WaitForChild("serializeRoutine"))
local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))
local Mutexes = require(script.Parent:WaitForChild("Mutexes"))

type Entry = {
	name: string,
	call: ChainTypes.Call,
}

local cache: { [Model]: Entry } = {}

local Routines = {}

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

	cache[routine] = {
		name = name,
		call = serializeRoutine(routine),
	}
end

local function removed(routine: Instance)
	if not routine:IsA("Model") then
		Util.LogWarn(`removed routine "{routine.Name}" is not a model`)
		return
	end

	if cache[routine] then
		table.clear(cache[routine])
	end

	cache[routine] = nil
end

function Routines.Export(): { [string]: ChainTypes.Call }
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

		routines[name] = entry.call
	end

	return routines
end

function Routines.Init()
	CollectionService:GetInstanceAddedSignal(Names.Tags.Routine):Connect(added)
	CollectionService:GetInstanceRemovedSignal(Names.Tags.Routine):Connect(removed)

	for _, routine in CollectionService:GetTagged(Names.Tags.Routine) do
		added(routine)
	end
end

return Routines
