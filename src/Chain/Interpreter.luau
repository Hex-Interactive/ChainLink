local RoutineDispatcher = require(script.Parent:WaitForChild("RoutineDispatcher"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))
local ASTNodeIds = require(script.Parent:WaitForChild("ASTNodeIds"))
local ChainTypes = require(script.Parent:WaitForChild("ChainTypes"))
local Links = require(script.Parent.Parent:WaitForChild("Links"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))
local BinExp = require(script.Parent:WaitForChild("BinExp"))

local COMPLEXITY_LIMIT = 800

local classPrototype = {}
local classMetatable = { __index = classPrototype }
export type Identity = typeof(setmetatable(
	{} :: {
		_complexity: number,
		_ast: ChainTypes.ASTNode,
		_routines: { [string]: ChainTypes.Routine },
		_links: { [string]: { Instance } },
	},
	classMetatable
))

local function constructor(ast: ChainTypes.ASTNode): Identity
	local self = setmetatable({}, classMetatable)

	self._complexity = 0
	self._ast = ast
	self._routines = RoutineDispatcher.Export()
	self._links = Links.Export()

	return self
end

function classPrototype.InterpretRootLike(self: Identity, node: ChainTypes.ASTNode): ChainTypes.ASTData?
	local children = node.children :: ChainTypes.ASTChildren_Root | ChainTypes.ASTChildren_Thunk

	-- Pairs used to make typechecker happy
	for _, child in pairs(children) do
		self:InterpretASTNode(child)
	end

	return nil
end

function classPrototype.InterpretCall(self: Identity, node: ChainTypes.ASTNode): ChainTypes.ASTData?
	local children = node.children :: ChainTypes.ASTChildren_Call
	local target = (if children.target then self:InterpretASTNode(children.target) else nil) :: string?
	local callName = node.data :: string

	local args = {}
	for _, child in children.args do
		table.insert(args, self:InterpretASTNode(child))
	end

	local func = nil
	local action = Actions.Get(callName)
	local routine = self._routines[callName]
	if action then
		func = action.Run
	elseif routine then
		func = routine
	end

	if not func then
		Util.LogWarn(`unable to resolve call name "{callName}"`)
		return nil
	end

	if action then
		if action.ValidateTarget and not target then
			Util.LogWarn(`action "{callName}" requires a target`)
			return nil
		end

		if action.ValidateArgs then
			for index, expectedType in action.ValidateArgs do
				local argValue = args[index]
				local argType = ChainTypes.Of(argValue)

				if (argType == expectedType or expectedType == "any") and argType ~= "error" then
					continue
				end

				Util.LogWarn(`action "{callName}" argument #{index} has invalid type, should be type "{expectedType}"`)
				return nil
			end
		end
	end

	if target then
		local targets = self._links[target]
		if not targets then
			return nil
		end

		for _, targetLink in targets do
			local validatedParam = nil

			if action and action.ValidateTarget then
				if not targetLink then
					continue
				end

				if typeof(action.ValidateTarget) == "function" then
					local validated, param = action.ValidateTarget(targetLink)
					if not validated then
						Util.LogWarn(`action "{callName}" target "{targetLink.Name}" is invalid`)
						continue
					end

					validatedParam = param
				end
			end

			func({
				target = targetLink,
				args = args,
				validatedParam = validatedParam,
			})
		end
	else
		func({
			target = nil,
			args = args,
			validatedParam = nil,
		})
	end

	return nil
end

function classPrototype.InterpretBinExp(self: Identity, node: ChainTypes.ASTNode): ChainTypes.ASTData?
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

function classPrototype.InterpretThunk(self: Identity, node: ChainTypes.ASTNode): ChainTypes.ASTData?
	return function()
		self:InterpretRootLike(node)
	end
end

function classPrototype.InterpretNot(self: Identity, node: ChainTypes.ASTNode): ChainTypes.ASTData?
	local children = node.children :: ChainTypes.ASTChildren_Not

	local result = self:InterpretASTNode(children)
	if ChainTypes.Of(result) ~= "boolean" then
		Util.LogWarn("failed logical not typecheck")
		return nil
	end

	return not result
end

function classPrototype.InterpretASTNode(self: Identity, node: ChainTypes.ASTNode): ChainTypes.ASTData?
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
