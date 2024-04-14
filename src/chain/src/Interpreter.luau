local ASTNodeIds = require(script.Parent:WaitForChild("ASTNodeIds"))
local Bindings = require(script.Parent:WaitForChild("Bindings"))
local Logger = require(script.Parent:WaitForChild("Logger"))
local BinExp = require(script.Parent:WaitForChild("BinExp"))
local Types = require(script.Parent:WaitForChild("Types"))

local COMPLEXITY_LIMIT = 800

local Interpreter = {}
local metatable = { __index = Interpreter }
export type Identity = typeof(setmetatable(
	{} :: {
		_ast: Types.ASTNode,
		_bindings: Bindings.Identity,

		_complexity: number,
		_mem: { [string]: Types.Type },

		_process: Types.Process,
	},
	metatable
))

local function constructor(ast: Types.ASTNode, bindings: Bindings.Identity): Identity
	local self = setmetatable({}, metatable)

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

function Interpreter.MemDef(self: Identity, name: string, value: Types.Type)
	if self._mem[name] then
		Logger.Warn(`mem contains a "{name}" def already`)
		return
	end

	if Types.Of(value) == "error" then
		Logger.Warn(`attempted mem def for "{name}" has invalid type`)
		return
	end

	self._mem[name] = value
end

function Interpreter.MemRead(self: Identity, name: string): Types.Type?
	return self._mem[name]
end

function Interpreter.InterpretRootLike(self: Identity, node: Types.ASTNode): Types.Type?
	local children = node.children :: Types.ASTChildren_Root | Types.ASTChildren_Thunk

	-- Pairs used to make typechecker happy
	for _, child in pairs(children) do
		self:InterpretASTNode(child)
	end

	return nil
end

function Interpreter.InterpretCall(self: Identity, node: Types.ASTNode): Types.Type?
	local callName = node.data :: string
	local callDef = self._bindings:GetCall(callName)
	if not callDef then
		Logger.Warn(`unable to resolve call name "{callName}"`)
		return nil
	end

	local children = node.children :: Types.ASTChildren_Call
	local target = (if children.target then self:InterpretASTNode(children.target) else nil) :: string?
	local targetDef = callDef.target

	if targetDef and not target then
		Logger.Warn(`call "{callName}" requires a target`)
		return nil
	elseif targetDef == false and target then
		Logger.Warn(`call "{callName}" shouldn't have a target`)
		return nil
	end

	local args = {}
	for _, child in children.args do
		table.insert(args, self:InterpretASTNode(child))
	end

	for index, expectedType: Types.TypeStringNilable in callDef.parameters do
		if Types.CheckValid(args[index], expectedType) then
			continue
		end

		Logger.Warn(`call "{callName}" argument #{index} has invalid type, should be type "{expectedType}"`)
		return nil
	end

	if target then
		local targets = self._bindings:GetTargets(target)
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
					local validated, arg = (targetDef :: Types.FunctionalTarget)(foundTarget)
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

		return nil -- Targeted calls cannot return
	end

	return callDef.call({
		process = self._process,
		args = args,
		validatedArg = nil,
		target = nil,
	})
end

function Interpreter.InterpretBinExp(self: Identity, node: Types.ASTNode): Types.Type?
	local children = node.children :: Types.ASTChildren_BinExp
	local op = node.data :: string

	if not BinExp.IsOpDefined(op) then
		Logger.Warn(`unable to resolve BinExp op "{op}"`)
		return nil
	end

	local left = self:InterpretASTNode(children.left)
	local right = self:InterpretASTNode(children.right)
	if not BinExp.TypeCheck(op, left, right) then
		Logger.Warn("failed BinExp typecheck")
		return nil
	end

	return BinExp.Eval(op, left :: BinExp.Value, right :: BinExp.Value)
end

function Interpreter.InterpretThunk(self: Identity, node: Types.ASTNode): Types.Type?
	return function()
		self:InterpretRootLike(node)
	end
end

function Interpreter.InterpretNot(self: Identity, node: Types.ASTNode): Types.Type?
	local children = node.children :: Types.ASTChildren_Not

	local result = self:InterpretASTNode(children)
	if Types.Of(result) ~= "boolean" then
		Logger.Warn("failed logical not typecheck")
		return nil
	end

	return not result
end

function Interpreter.InterpretASTNode(self: Identity, node: Types.ASTNode): Types.Type?
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

function Interpreter.Begin(self: Identity)
	if self._bindings:IsInvalid() then
		error("interpreter's bindings are invalid on begin", 2)
	end

	self:InterpretASTNode(self._ast)

	if self._complexity > COMPLEXITY_LIMIT then
		Logger.Warn("interpreter complexity limit was reached, didn't execute fully")
	end
end

return {
	new = constructor,
}
