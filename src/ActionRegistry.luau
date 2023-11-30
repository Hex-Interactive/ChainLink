local Types = require(script.Parent:WaitForChild("Types"))

local index = {}

local ActionRegistry = {}

function ActionRegistry.Register(module: ModuleScript)
	local name = module.Name
	assert(index[name] == nil, `action "{name}" already defined`)
	index[name] = require(module) :: Types.ActionModule
end

function ActionRegistry.RegisterIn(directory: Instance, ignore: { string }?)
	for _, instance in directory:GetDescendants() do
		if not instance:IsA("ModuleScript") or (ignore and table.find(ignore, instance.Name)) then
			continue
		end

		ActionRegistry.Register(instance)
	end
end

function ActionRegistry.RegisterDefaults(ignore: { string }?)
	ActionRegistry.RegisterIn(script.Parent:WaitForChild("DefaultActions"), ignore)
end

function ActionRegistry.Get(name: string): Types.ActionModule
	local action = index[name]
	assert(action ~= nil, `action "{name}" not found`)
	return action
end

return ActionRegistry
