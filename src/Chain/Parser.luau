local InstructionIDs = require(script.Parent:WaitForChild("InstructionIDs"))
local LexemeIDs = require(script.Parent:WaitForChild("LexemeIDs"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))

type Parser = {
	__index: Parser,
	new: (lexemes: Types.Lexemes) -> Parser,

	lexemes: Types.Lexemes,
	len: number,
	pos: number,

	Peek: (self: Parser, amount: number) -> string,
	Look: (self: Parser, amount: number) -> Types.Lexeme?,
	Consume: (self: Parser) -> (),
	ParseExpression: (self: Parser) -> Types.Instruction,
	ParseCall: (self: Parser, callTarget: Types.Lexeme?) -> Types.Instruction,
	ParseTargetedCall: (self: Parser) -> Types.Instruction,
	ParseNext: (self: Parser) -> Types.Instruction,
	Begin: (self: Parser) -> Types.Result<Types.Instructions>,
}

local Parser = {} :: Parser
Parser.__index = Parser

local function new(id: string, data: { [string]: any }?): Types.Instruction
	return {
		id = id,
		data = data or {},
	}
end

local function newUnexp(lexeme: Types.Lexeme?): Types.Instruction
	if lexeme then
		return new(InstructionIDs.Unexpected, {
			id = lexeme.id,
			data = lexeme.data,
		})
	end

	return new(InstructionIDs.MissingEof)
end

function Parser.new(lexemes: Types.Lexemes): Parser
	local self = (setmetatable({}, Parser) :: any) :: Parser

	self.lexemes = lexemes
	self.len = #lexemes
	self.pos = 1

	return self
end

function Parser:Peek(amount: number): string
	local lexeme = self:Look(amount)
	if not lexeme then
		return LexemeIDs.UnexpectedEof
	end

	return lexeme.id
end

function Parser:Look(amount: number): Types.Lexeme?
	local nextPos = self.pos + amount
	if nextPos > self.len then
		return nil
	end

	return self.lexemes[nextPos]
end

function Parser:Consume()
	self.pos += 1
end

function Parser:ParseExpression(): Types.Instruction
	-- TODO
end

function Parser:ParseCall(callTarget: Types.Lexeme?): Types.Instruction
	local target = if callTarget then callTarget.data else nil

	local callName = self:Look(0) :: Types.Lexeme
	self:Consume()

	self:Consume() -- Starting parenthesis

	local earlyExitId = self:Peek(0)
	if earlyExitId == LexemeIDs.EndParen then
		self:Consume()

		local id = self:Peek(0)
		if id ~= LexemeIDs.NextCall then
			return newUnexp(self:Look(0))
		end
		self:Consume()

		return new(InstructionIDs.Call, {
			name = callName.data,
			target = target,
			args = {},
		})
	end

	local call = new(InstructionIDs.Call, {
		name = callName.data,
		target = target,
		args = { self:ParseExpression() },
	})

	while self:Peek(0) == LexemeIDs.NextCall do
		self:Consume()
		table.insert(call.data.args, self:ParseExpression())
	end

	local id = self:Peek(0)
	if id ~= LexemeIDs.NextCall then
		return newUnexp(self:Look(0))
	end
	self:Consume()

	return call
end

function Parser:ParseTargetedCall(): Types.Instruction
	local targetName = self:Look(0) :: Types.Lexeme
	self:Consume()

	self:Consume() -- Arrow

	local id = self:Peek(0)
	if id == LexemeIDs.Identifier then
		local nextId = self:Peek(1)

		if nextId == LexemeIDs.StartParen then
			return self:ParseCall(targetName)
		end

		return newUnexp(self:Look(1))
	end

	return newUnexp(self:Look(0))
end

function Parser:ParseNext(): Types.Instruction
	local id = self:Peek(0)

	if id == LexemeIDs.Eof then
		return new(InstructionIDs.Eof)
	elseif id == LexemeIDs.Identifier then
		local nextId = self:Peek(1)

		if nextId == LexemeIDs.Arrow then
			return self:ParseTargetedCall()
		elseif nextId == LexemeIDs.StartParen then
			return self:ParseCall(nil)
		end

		return newUnexp(self:Look(1))
	end

	return newUnexp(self:Look(0))
end

function Parser:Begin(): Types.Result<Types.Instructions>
	local instructions = {}

	while true do
		local instruction = self:ParseNext()

		if instruction.id == InstructionIDs.MissingEof then
			return {
				ok = false,
				err = `parsed lexemes missing EOF`,
			}
		elseif instruction.id == InstructionIDs.Unexpected then
			return {
				ok = false,
				err = `parsed unexpected lexeme "{instruction.data.id}"`,
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
