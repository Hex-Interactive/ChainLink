local Types = require(script.Parent:WaitForChild("Types"))
local Parser = require(script:WaitForChild("Parser"))
local Lexer = require(script:WaitForChild("Lexer"))

local ERR_MESSAGE = "ChainError: %s"

local Chain = {}

local function err(text: string)
	error(string.format(ERR_MESSAGE, text))
end

local function handleResult<T>(result: Types.Result<T>) end

function Chain.Compile(source: string): Types.Instructions?
	local lexer = Lexer.new(source)
	local lexerResult = lexer:GenerateTokens()

	if not lexerResult.ok then
		if lexerResult.err then
			err(lexerResult.err)
		end
		return nil
	end

	if not lexerResult.tokens then
		return nil
	end

	print("Tokens:", lexerResult.tokens) -- TEMP

	local parser = Parser.new(lexerResult.tokens)
	local parserResult = parser:GenerateInstructions()

	if not parserResult.ok then
		if parserResult.err then
			err(parserResult.err)
		end
		return nil
	end

	if not lexerResult.tokens then
		return nil
	end

	print("Parser result:", parserResult) -- TEMP
	return parserResult.instructions
end

function Chain.Execute(source: string)
	local lexer = Lexer.new(source)

	local lexerResult = lexer:GenerateTokens()
	if not lexerResult.ok then
		if lexerResult.err then
			err(lexerResult.err)
		end
		return
	end

	if not lexerResult.tokens then
		return
	end

	print(lexerResult.tokens) -- TEMP

	local _parser = Parser.new(lexerResult.tokens) -- TODO
end

return Chain
