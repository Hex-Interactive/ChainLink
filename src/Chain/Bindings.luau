local ChainTypes = require(script.Parent:WaitForChild("ChainTypes"))

local index: { [string]: ChainTypes.CallDefinition<unknown> } = {}

local Bindings = {} -- TODO: Finish new bindings management

function Bindings.Register<T>(name: string, callDef: ChainTypes.CallDefinition<T>)
	if index[name] then
		error(`binding "{name}" already registered`, 2)
	end

	index[name] = callDef :: ChainTypes.CallDefinition<any>
end

function Bindings.Get(name: string): ChainTypes.CallDefinition<unknown>?
	return index[name]
end

return Bindings
