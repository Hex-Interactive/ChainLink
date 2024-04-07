--[[
	Chain
	v0.1.0
]]

local Interpreter = require(script:WaitForChild("Interpreter"))
local Bindings = require(script:WaitForChild("Bindings"))
local Logger = require(script:WaitForChild("Logger"))
local Parser = require(script:WaitForChild("Parser"))
local Types = require(script:WaitForChild("Types"))
local Lexer = require(script:WaitForChild("Lexer"))

export type Call = Types.Call
export type Context = Types.Context
export type CallDefinition = Types.CallDefinition

local Chain = {}

local function handleResult<T>(result: Types.Result<T>): boolean
	if result.ok then
		return true
	end

	if result.err then
		Logger.Warn(result.err)
	end

	return false
end

function Chain.CreateBindings(calls: Bindings.CallsDict, targets: Bindings.TargetsDict): Bindings.Identity
	return Bindings.new(calls, targets)
end

function Chain.Compile(source: string): (Types.ASTNode?, Types.Lexemes?)
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

function Chain.Interpret(ast: Types.ASTNode, bindings: Bindings.Identity)
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
