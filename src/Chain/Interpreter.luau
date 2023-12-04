local CollectionService = game:GetService("CollectionService")

local RoutineDispatcher = require(script.Parent:WaitForChild("RoutineDispatcher"))
local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Actions = require(script.Parent.Parent:WaitForChild("Actions"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))

type Interpreter = {
	__index: Interpreter,
	new: (ast: Types.ASTNode) -> Interpreter,

	ast: Types.ASTNode,
	links: {
		[string]: { Instance },
	},

	InterpretASTNode: (self: Interpreter, node: Types.ASTNode) -> any?,
	Begin: (self: Interpreter) -> (),
}

local Interpreter = {} :: Interpreter
Interpreter.__index = Interpreter

function Interpreter.new(ast: Types.ASTNode): Interpreter
	local self = (setmetatable({}, Interpreter) :: any) :: Interpreter

	self.ast = ast

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

function Interpreter:InterpretASTNode(_node: Types.ASTNode): any?
	return nil
end

function Interpreter:Begin()
	self:InterpretASTNode(self.ast)
end

return Interpreter
