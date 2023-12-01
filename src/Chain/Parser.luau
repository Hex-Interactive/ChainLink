local InstructionIDs = require(script.Parent:WaitForChild("InstructionIDs"))
local LexemeIDs = require(script.Parent:WaitForChild("LexemeIDs"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))

type Parser = {
	__index: Parser,
	new: (lexemes: Types.Lexemes) -> Parser,

	lexemes: Types.Lexemes,
	len: number,
	pos: number,

	Peek: (self: Parser, amount: number) -> Types.Lexeme?,
	Consume: (self: Parser) -> (),
	ReadNext: (self: Parser) -> Types.Instruction,
	Begin: (self: Parser) -> Types.Result<Types.Instructions>,
}

local Parser = {} :: Parser
Parser.__index = Parser

local function new(id: string, args: { string }?): Types.Instruction
	return {
		id = id,
		args = args or {},
	}
end

function Parser.new(lexemes: Types.Lexemes): Parser
	local self = (setmetatable({}, Parser) :: any) :: Parser

	self.lexemes = lexemes
	self.len = #lexemes
	self.pos = 1

	return self
end

function Parser:Peek(amount: number): Types.Lexeme?
	local nextPos = self.pos + amount
	if nextPos > self.len then
		return nil
	end

	return self.lexemes[nextPos]
end

function Parser:Consume()
	self.pos += 1
end

function Parser:ReadNext(): Types.Instruction
	local lexeme = self:Peek(0)

	if lexeme == nil then
		return new(InstructionIDs.MissingEof)
	elseif lexeme.id == LexemeIDs.Eof then
		return new(InstructionIDs.Eof)
	end

	return new(InstructionIDs.Unknown, {
		lexeme.id,
		lexeme.data,
	})
end

function Parser:Begin(): Types.Result<Types.Instructions>
	local instructions = {}

	while true do
		local instruction = self:ReadNext()

		if instruction.id == InstructionIDs.MissingEof then
			return {
				ok = false,
				err = `parsed lexemes missing EOF`,
			}
		elseif instruction.id == InstructionIDs.Unknown then
			return {
				ok = false,
				err = `parsed unknown lexeme "{instruction.args[1]}"`,
			}
		end

		if instruction.id == InstructionIDs.Eof then
			break
		end

		table.insert(instructions, instruction)
	end

	return {
		ok = true,
		data = instructions,
	}
end

return Parser
