local Types = require(script.Parent:WaitForChild("Types"))
local Parser = require(script:WaitForChild("Parser"))
local Lexer = require(script:WaitForChild("Lexer"))

local ERR_MESSAGE = "ChainError: %s"

local Chain = {}

local function err(text: string)
	error(string.format(ERR_MESSAGE, text))
end

local function handleResult<T>(result: Types.Result<T>): boolean
	if result.ok then
		return true
	end

	if result.err then
		err(result.err)
	end

	return false
end

function Chain.Compile(source: string): Types.Instructions?
	local lexer = Lexer.new(source)
	local lexerResult = lexer:Begin()
	local lexerSuccess = handleResult(lexerResult)
	if not lexerSuccess or not lexerResult.data then
		return nil
	end

	print("Tokens:", lexerResult.data) -- TEMP

	local parser = Parser.new(lexerResult.data)
	local parserResult = parser:GenerateInstructions()
	local parserSuccess = handleResult(parserResult)
	if not parserSuccess or not parserResult.data then
		return nil
	end

	print("Instructions:", parserResult.data) -- TEMP

	return parserResult.data
end

function Chain.Execute(source: string)
	Chain.Compile(source) -- TODO: Execute instructions
end

return Chain
