local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Chain = require(ReplicatedStorage.Packages.ChainLink.Chain)

local SEP = string.rep("-", 25)

local function test(source: string)
	local errSuccess, astOrErr, lexemes = pcall(Chain.Compile, source)
	local testSuccess = astOrErr ~= nil and lexemes ~= nil
	local success = errSuccess and testSuccess
	local results = if success then `Lexemes: {lexemes}\nAST: {astOrErr}` else `Error message: "{astOrErr}"`
	print(`{SEP}\nTest successful: {string.upper(tostring(success))}\n{results}\n{SEP}\n`)
end

test(`Name(true,"hello \\" there",1+2,-33);TestHere()`)
test(`Things->NumberTesting(23.64,-0.4,76)`)
