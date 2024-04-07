local Chain = require(script.Parent.Parent.Parent:WaitForChild("Chain"))
local Logger = require(script.Parent.Parent:WaitForChild("Logger"))
local State = require(script.Parent.Parent:WaitForChild("State"))
local Mutexes = require(script.Parent:WaitForChild("Mutexes"))

local cache = {}

local Actions = {}

function Actions.Register(module: ModuleScript)
	Logger.Assert(State.initialized == false, "register actions before initialization")

	local name = module.Name
	Logger.Assert(not Mutexes.IsLocked(name), `action by name "{name}" already exists`)

	cache[name] = require(module) :: Chain.CallDefinition
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

function Actions.Export(): { [string]: Chain.CallDefinition }
	return table.clone(cache)
end

return Actions
