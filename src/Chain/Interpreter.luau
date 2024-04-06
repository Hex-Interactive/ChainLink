local ASTNodeIds = require(script.Parent:WaitForChild("ASTNodeIds"))
local ChainTypes = require(script.Parent:WaitForChild("ChainTypes"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))
local BinExp = require(script.Parent:WaitForChild("BinExp"))

local COMPLEXITY_LIMIT = 800

local classPrototype = {}
local classMetatable = { __index = classPrototype }
export type Identity = typeof(setmetatable(
	{} :: {
		_ast: ChainTypes.ASTNode,
		_bindings: ChainTypes.Bindings,

		_complexity: number,
		_mem: { [string]: ChainTypes.Type },

		_process: ChainTypes.Process,
	},
	classMetatable
))

local function constructor(ast: ChainTypes.ASTNode, bindings: ChainTypes.Bindings): Identity
	local self = setmetatable({}, classMetatable)

	self._ast = ast
	self._bindings = bindings

	self._complexity = 0
	self._mem = {}

	self._process = {
		memDef = function(name, value)
			self:MemDef(name, value)
		end,
		memRead = function(name)
			return self:MemRead(name)
		end,
	}

	return self
end

function classPrototype.MemDef(self: Identity, name: string, value: ChainTypes.Type)
	if self._mem[name] then
		Util.LogWarn(`mem contains a "{name}" def already`)
		return
	end

	if ChainTypes.Of(value) == "error" then
		Util.LogWarn(`attempted mem def for "{name}" has invalid type`)
		return
	end

	self._mem[name] = value
end

function classPrototype.MemRead(self: Identity, name: string): ChainTypes.Type?
	return self._mem[name]
end

function classPrototype.InterpretRootLike(self: Identity, node: ChainTypes.ASTNode): ChainTypes.Type?
	local children = node.children :: ChainTypes.ASTChildren_Root | ChainTypes.ASTChildren_Thunk

	-- Pairs used to make typechecker happy
	for _, child in pairs(children) do
		self:InterpretASTNode(child)
	end

	return nil
end

function classPrototype.InterpretCall(self: Identity, node: ChainTypes.ASTNode): ChainTypes.Type?
	local callName = node.data :: string
	local callDef = self._bindings.calls[callName]
	if not callDef then
		Util.LogWarn(`unable to resolve call name "{callName}"`)
		return nil
	end

	local args = {}
	local children = node.children :: ChainTypes.ASTChildren_Call
	for _, child in children.args do
		table.insert(args, self:InterpretASTNode(child))
	end

	local targetDef = callDef.target
	local target = (if children.target then self:InterpretASTNode(children.target) else nil) :: string?
	if targetDef and not target then
		Util.LogWarn(`call "{callName}" requires a target`)
		return nil
	elseif target and targetDef == false then
		Util.LogWarn(`call "{callName}" shouldn't have a target`)
		return nil
	end

	if callDef.parameters then
		for index, expectedType in callDef.parameters do
			if expectedType == "any?" then
				continue
			end

			local argValue = args[index]
			local argType = ChainTypes.Of(argValue)

			-- Chain internal error type guards against nil
			if (argType == expectedType or expectedType == "any") and argType ~= "error" then
				continue
			end

			Util.LogWarn(`call "{callName}" argument #{index} has invalid type, should be type "{expectedType}"`)
			return nil
		end
	end

	if target then
		local targets = self._bindings.targets[target]
		if not targets then
			return nil
		end

		local isFunctionalTarget = typeof(targetDef) == "function"

		for _, foundTarget in targets do
			local validatedArg = nil

			if targetDef then
				if not foundTarget then
					continue
				end

				if isFunctionalTarget then
					local validated, arg = (targetDef :: ChainTypes.FunctionalTarget)(foundTarget)
					if not validated then
						continue
					end

					validatedArg = arg
				end
			end

			callDef.call({
				process = self._process,
				args = args,
				validatedArg = validatedArg,
				target = foundTarget,
			})
		end
	else
		callDef.call({
			process = self._process,
			args = args,
			validatedArg = nil,
			target = nil,
		})
	end

	return nil
end

function classPrototype.InterpretBinExp(self: Identity, node: ChainTypes.ASTNode): ChainTypes.Type?
	local children = node.children :: ChainTypes.ASTChildren_BinExp
	local op = node.data :: string

	if not BinExp.IsOpDefined(op) then
		Util.LogWarn(`unable to resolve BinExp op "{op}"`)
		return nil
	end

	local left = self:InterpretASTNode(children.left)
	local right = self:InterpretASTNode(children.right)
	if not BinExp.TypeCheck(op, left, right) then
		Util.LogWarn("failed BinExp typecheck")
		return nil
	end

	return BinExp.Eval(op, left :: BinExp.Value, right :: BinExp.Value)
end

function classPrototype.InterpretThunk(self: Identity, node: ChainTypes.ASTNode): ChainTypes.Type?
	return function()
		self:InterpretRootLike(node)
	end
end

function classPrototype.InterpretNot(self: Identity, node: ChainTypes.ASTNode): ChainTypes.Type?
	local children = node.children :: ChainTypes.ASTChildren_Not

	local result = self:InterpretASTNode(children)
	if ChainTypes.Of(result) ~= "boolean" then
		Util.LogWarn("failed logical not typecheck")
		return nil
	end

	return not result
end

function classPrototype.InterpretASTNode(self: Identity, node: ChainTypes.ASTNode): ChainTypes.Type?
	local newCount = self._complexity + 1
	self._complexity = newCount
	if newCount > COMPLEXITY_LIMIT then
		return nil -- Not a perfect limit, but it will stop any deeper function calls
	end

	if node.id == ASTNodeIds.Call then
		return self:InterpretCall(node)
	elseif node.id == ASTNodeIds.BinExp then
		return self:InterpretBinExp(node)
	elseif node.id == ASTNodeIds.Thunk then
		return self:InterpretThunk(node)
	elseif node.id == ASTNodeIds.Not then
		return self:InterpretNot(node)
	elseif node.id == ASTNodeIds.Root then
		return self:InterpretRootLike(node)
	end

	return node.data
end

function classPrototype.Begin(self: Identity)
	self:InterpretASTNode(self._ast)

	if self._complexity > COMPLEXITY_LIMIT then
		Util.LogWarn("interpreter complexity limit was reached, didn't execute fully")
	end
end

return {
	new = constructor,
}
