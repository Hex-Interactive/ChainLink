local Logger = require(script.Parent:WaitForChild("Logger"))
local Types = require(script.Parent:WaitForChild("Types"))

export type CallsDict = { [string]: Types.CallDefinition }
export type TargetsDict = { [string]: { Instance } }

local builtinCalls: CallsDict

local classPrototype = {}
local classMetatable = { __index = classPrototype }
export type Identity = typeof(setmetatable(
	{} :: {
		_valid: boolean,
		_calls: CallsDict,
		_targets: TargetsDict,
	},
	classMetatable
))

local function reconcileBuiltinCalls()
	if builtinCalls then
		return
	end

	local dir = script.Parent:FindFirstChild("BuiltinCalls")
	Logger.Assert(dir, "unable to find builtin calls")

	local new = {}
	for _, module in dir:GetChildren() do
		new[module.Name] = require(module) :: Types.CallDefinition
	end

	builtinCalls = new
end

local function constructor(calls: CallsDict, targets: TargetsDict): Identity
	reconcileBuiltinCalls()
	for name in builtinCalls do
		if calls[name] then
			error(`call binding name "{name}" is taken by builtin, pick another`, 2)
		end
	end

	local self = setmetatable({}, classMetatable)

	self._valid = true
	self._calls = calls
	self._targets = targets

	return self
end

function classPrototype.GetCall(self: Identity, name: string): Types.CallDefinition?
	return builtinCalls[name] or self._calls[name]
end

function classPrototype.GetTargets(self: Identity, name: string): { Instance }?
	return self._targets[name]
end

function classPrototype.IsInvalid(self: Identity): boolean
	return not self._valid
end

function classPrototype.Destroy(self: Identity)
	self._valid = false

	table.clear(self._calls)

	for _, subtable in self._targets do
		table.clear(subtable)
	end
	table.clear(self._targets)
end

return {
	new = constructor,
}
