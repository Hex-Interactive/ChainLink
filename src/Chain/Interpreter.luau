local RoutineDispatcher = require(script.Parent:WaitForChild("RoutineDispatcher"))
local BinExpEvals = require(script.Parent:WaitForChild("BinExpEvals"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))
local ASTNodeIDs = require(script.Parent:WaitForChild("ASTNodeIDs"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Links = require(script.Parent.Parent:WaitForChild("Links"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local RECURSION_LIMIT = 800

type Interpreter = {
	__index: Interpreter,
	new: (ast: Types.ASTNode) -> Interpreter,

	recursionCounter: number,
	ast: Types.ASTNode,
	routines: { [string]: Types.Routine },
	links: { [string]: { Instance } },

	InterpretRoot: (self: Interpreter, node: Types.ASTNode) -> Types.ASTData?,
	InterpretCall: (self: Interpreter, node: Types.ASTNode) -> Types.ASTData?,
	InterpretBinExp: (self: Interpreter, node: Types.ASTNode) -> Types.ASTData?,
	InterpretASTNode: (self: Interpreter, node: Types.ASTNode) -> Types.ASTData?,
	Begin: (self: Interpreter) -> (),
}

local Interpreter = {} :: Interpreter
Interpreter.__index = Interpreter

function Interpreter.new(ast: Types.ASTNode): Interpreter
	local self = (setmetatable({}, Interpreter) :: any) :: Interpreter

	self.recursionCounter = 0
	self.ast = ast
	self.routines = RoutineDispatcher.Export()
	self.links = Links.Export()

	return self
end

function Interpreter:InterpretRoot(node: Types.ASTNode): Types.ASTData?
	local children = node.children :: Types.ASTChildren_Root

	for _, child in children do
		self:InterpretASTNode(child)
	end

	return nil
end

function Interpreter:InterpretCall(node: Types.ASTNode): Types.ASTData?
	local children = node.children :: Types.ASTChildren_Call
	local target = (if children.target then self:InterpretASTNode(children.target) else nil) :: string?
	local callName = node.data :: string

	local args = {}
	for _, child in children.args do
		table.insert(args, self:InterpretASTNode(child))
	end

	local func = nil
	local action = Actions.Get(callName)
	local routine = self.routines[callName]
	if action then
		func = action.Run
	elseif routine then
		func = routine
	end

	if not func then
		Util.LogWarn(`unable to resolve call name "{callName}"`)
		return nil
	end

	if action and action.ValidateArgs then
		for index, expectedType in action.ValidateArgs do
			local value = args[index]
			if typeof(value) == expectedType or (expectedType == "any" and value ~= nil) then
				continue
			end

			Util.LogWarn(`action "{callName}" argument #{index} is invalid`)
			return nil
		end
	end

	if target then
		local targets = self.links[target]
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

function Interpreter:InterpretBinExp(node: Types.ASTNode): Types.ASTData?
	local children = node.children :: Types.ASTChildren_BinExp
	local op = node.data :: string
	local eval = BinExpEvals[op]

	if not eval then
		Util.LogWarn(`unable to resolve BinExp op "{op}"`)
		return nil
	end

	local left = self:InterpretASTNode(children.left)
	local right = self:InterpretASTNode(children.right)

	-- TODO: Type checking to ensure the prospective eval is possible

	return eval(left, right)
end

function Interpreter:InterpretASTNode(node: Types.ASTNode): Types.ASTData?
	local newCount = self.recursionCounter + 1
	if newCount > RECURSION_LIMIT then
		return nil
	end

	if node.id == ASTNodeIDs.Root then
		return self:InterpretRoot(node)
	elseif node.id == ASTNodeIDs.Call then
		return self:InterpretCall(node)
	elseif node.id == ASTNodeIDs.BinExp then
		return self:InterpretBinExp(node)
	end

	return node.data
end

function Interpreter:Begin()
	self:InterpretASTNode(self.ast)

	if self.recursionCounter > RECURSION_LIMIT then
		Util.LogWarn("interpreter recursion limit was reached, didn't execute fully")
	end
end

return Interpreter
