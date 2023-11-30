local Parser = require(script:WaitForChild("Parser"))
local Lexer = require(script:WaitForChild("Lexer"))

local ERR_MESSAGE = "ChainError: %s"

local Chain = {}

local function err(text: string)
	error(string.format(ERR_MESSAGE, text))
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
