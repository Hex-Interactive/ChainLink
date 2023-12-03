local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Chain = require(ReplicatedStorage.Packages.ChainLink.Chain)

local function test(source: string)
	local ast, lexemes = Chain.Compile(source)
	local success = ast ~= nil and lexemes ~= nil
	local sep = string.rep(".", 25)

	print(`{sep}\nTest success: {string.upper(tostring(success))}\nLexemes: {lexemes}\nAST: {ast}\n{sep}\n`)
end

test(`Name(true,"hello \\" there",1+2,-33);TestHere()`)
test(`Things->NumberTesting(23.64,-0.4,76)`)
