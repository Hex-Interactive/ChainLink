local Interpreter = require(script:WaitForChild("Interpreter"))
local ChainTypes = require(script:WaitForChild("ChainTypes"))
local Bindings = require(script:WaitForChild("Bindings"))
local Util = require(script.Parent:WaitForChild("Util"))
local Parser = require(script:WaitForChild("Parser"))
local Lexer = require(script:WaitForChild("Lexer"))

local Chain = {}

local function handleResult<T>(result: ChainTypes.Result<T>): boolean
	if result.ok then
		return true
	end

	if result.err then
		Util.LogWarn(result.err)
	end

	return false
end

function Chain.CreateBindings(calls: Bindings.CallsDict, targets: Bindings.TargetsDict): Bindings.Identity
	return Bindings.new(calls, targets)
end

function Chain.Compile(source: string): (ChainTypes.ASTNode?, ChainTypes.Lexemes?)
	local lexer = Lexer.new(source)
	local lexerResult = lexer:Begin()
	local lexerSuccess = handleResult(lexerResult)
	if not lexerSuccess or not lexerResult.data then
		return nil, nil
	end

	local parser = Parser.new(lexerResult.data)
	local parserResult = parser:Begin()
	local parserSuccess = handleResult(parserResult)
	if not parserSuccess or not parserResult.data then
		return nil, lexerResult.data
	end

	return parserResult.data, lexerResult.data
end

function Chain.Interpret(ast: ChainTypes.ASTNode, bindings: Bindings.Identity)
	local interpreter = Interpreter.new(ast, bindings)
	interpreter:Begin()
end

function Chain.Execute(source: string, bindings: Bindings.Identity)
	local ast = Chain.Compile(source)
	if not ast then
		return
	end

	Chain.Interpret(ast, bindings)
end

return Chain
