local ChainTypes = require(script.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local Mutexes = require(script.Parent:WaitForChild("Mutexes"))
local State = require(script.Parent:WaitForChild("State"))
local Util = require(script.Parent:WaitForChild("Util"))

local index = {}

local Actions = {}

function Actions.Register(module: ModuleScript)
	Util.Assert(State.initialized == false, "register actions before initialization")

	local name = module.Name
	Util.Assert(not Mutexes.IsLocked(name), `action by name "{name}" already exists`)

	index[name] = require(module) :: ChainTypes.CallDefinition<unknown>
	Mutexes.Create(name)
end

function Actions.RegisterIn(directory: Instance, ignore: { string }?)
	for _, instance in directory:GetDescendants() do
		if not instance:IsA("ModuleScript") or (ignore and table.find(ignore, instance.Name)) then
			continue
		end

		Actions.Register(instance)
	end
end

function Actions.RegisterDefaults(ignore: { string }?)
	Actions.RegisterIn(script.Parent:WaitForChild("DefaultActions"), ignore)
end

function Actions.Get(name: string): ChainTypes.CallDefinition<unknown>?
	return index[name]
end

return Actions
