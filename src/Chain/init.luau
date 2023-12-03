local Types = require(script.Parent:WaitForChild("Types"))
local Util = require(script.Parent:WaitForChild("Util"))
local Parser = require(script:WaitForChild("Parser"))
local Lexer = require(script:WaitForChild("Lexer"))

local Chain = {}

local function handleResult<T>(result: Types.Result<T>): boolean
	if result.ok then
		return true
	end

	if result.err then
		Util.LogError(result.err)
	end

	return false
end

function Chain.Compile(source: string): Types.ASTNode?
	local lexer = Lexer.new(source)
	local lexerResult = lexer:Begin()
	local lexerSuccess = handleResult(lexerResult)
	if not lexerSuccess or not lexerResult.data then
		return nil
	end

	print("Lexemes:", lexerResult.data) -- TEMP

	local parser = Parser.new(lexerResult.data)
	local parserResult = parser:Begin()
	local parserSuccess = handleResult(parserResult)
	if not parserSuccess or not parserResult.data then
		return nil
	end

	return parserResult.data
end

function Chain.Interpret(ast: Types.ASTNode)
	print("AST:", ast) -- TEMP
end

function Chain.Execute(source: string)
	local ast = Chain.Compile(source)
	if not ast then
		return
	end

	Chain.Interpret(ast)
end

return Chain
