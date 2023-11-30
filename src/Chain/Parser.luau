local Types = require(script.Parent.Parent:WaitForChild("Types"))

type Parser = {
	__index: Parser,
	new: (lexemes: { Types.Lexeme }) -> Parser,

	lexemes: { Types.Lexeme },
	len: number,
	pos: number,

	Peek: (self: Parser, amount: number) -> Types.Lexeme?,
	Consume: (self: Parser) -> (),
	Begin: (self: Parser) -> Types.Result<{ Types.Instruction }>,
}

local Parser = {} :: Parser
Parser.__index = Parser

function Parser.new(lexemes: { Types.Lexeme }): Parser
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

function Parser:Begin(): Types.Result<{ Types.Instruction }>
	-- TODO

	return {
		ok = false,
		err = "not implemented",
	}
end

return Parser
