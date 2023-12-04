local CollectionService = game:GetService("CollectionService")

local RoutineDispatcher = require(script.Parent:WaitForChild("RoutineDispatcher"))
local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))
local ASTNodeIDs = require(script.Parent:WaitForChild("ASTNodeIDs"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))
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

	local links = {}
	for _, link in CollectionService:GetTagged(Names.Tags.Link) do
		local fullId = link:GetAttribute(Names.Attr.LinkId)
		if not fullId or not CurrentMap.HasDescendant(link) then
			continue
		end

		local ids = string.split(fullId, ";")
		if #ids <= 0 then
			continue
		end

		for _, id in ids do
			if not links[id] then
				links[id] = {}
			end

			table.insert(links[id], link)
		end
	end
	self.links = links

	return self
end

function Interpreter:InterpretRoot(node: Types.ASTNode): Types.ASTData?
	local children = node.children :: Types.ASTChildren_Root

	for _, childNode in children do
		self:InterpretASTNode(childNode)
	end

	return nil
end

function Interpreter:InterpretCall(_node: Types.ASTNode): Types.ASTData?
	return nil -- TODO
end

function Interpreter:InterpretBinExp(_node: Types.ASTNode): Types.ASTData?
	return nil -- TODO
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
