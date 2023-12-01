local Types = require(script.Parent:WaitForChild("Types"))
local State = require(script.Parent:WaitForChild("State"))

local index = {}

local Actions = {}

function Actions.Register(module: ModuleScript)
	assert(State.initialized == false, "register actions before initialization")
	local name = module.Name
	assert(index[name] == nil, `action "{name}" already defined`)
	index[name] = require(module) :: Types.ActionModule
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

function Actions.Get(name: string): Types.ActionModule?
	return index[name]
end

return Actions
