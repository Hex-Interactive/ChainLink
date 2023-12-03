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

test(`NameGoesHere(true, "hello \\" there", -33);TestHere()`)
test(`Things->NumberTesting(23.64, -0.4, 76)`)
test(`Operations(1 + 2, 1.45 - 2.543, 2 * 4, 1 / 2)`)
test(`OperationOrder(2 + 2 * 4, 1.45 - 2.543 / 2.34, (1 + 2) * 4)`)
