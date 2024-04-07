local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Chain = require(ReplicatedStorage.Packages.Chain)

local SEP = string.rep("-", 25)

local function printBool(bool: boolean): string
	return string.upper(tostring(bool))
end

local function test(args: { run: string, expected: string })
	local compileErrSuccess, astOrErr, lexemes = pcall(Chain.Compile, args.run)
	local compileTestSuccess = astOrErr ~= nil and lexemes ~= nil
	local compileSuccess = compileErrSuccess and compileTestSuccess

	local results
	if compileSuccess then
		local ast = HttpService:JSONEncode(astOrErr)
		local astMatches = ast == args.expected

		local astResults = if astMatches
			then ""
			else `\n\n**COMPILED AST**: {ast}\n**EXPECTED AST**: {args.expected}\n**LEXEMES**: {HttpService:JSONEncode(
				lexemes
			)}`

		results = `AST MATCH SUCCESS: {printBool(astMatches)}` .. astResults
	else
		results = `ERROR MESSAGE: "{astOrErr}"`
	end

	print(`{SEP}\nCOMPILATION SUCCESS: {printBool(compileSuccess)}\n{results}\n{SEP}\n`)
end

test({
	run = [[NameGoesHere(true, "hello \\" there", -33);TestHere();]],
	expected = [[{"id":"Root","data":"","children":[{"id":"Call","data":"NameGoesHere","children":{"args":[{"id":"Bool","data":true},{"id":"Str","data":"hello \\\" there"},{"id":"Num","data":-33}]}},{"id":"Call","data":"TestHere","children":{"args":[]}}]}]],
})
test({
	run = [[Things->NumberTesting(23.64, -0.4, 76);]],
	expected = [[{"id":"Root","data":"","children":[{"id":"Call","data":"NumberTesting","children":{"target":{"id":"Str","data":"Things"},"args":[{"id":"Num","data":23.64},{"id":"Num","data":-0.4},{"id":"Num","data":76}]}}]}]],
})
test({
	run = [[Operations(1 + 2, 1.45 - 2.543, 2 * 4, 1 / 2, 2^3 * 7, 6 % 3);]],
	expected = [[{"id":"Root","data":"","children":[{"id":"Call","data":"Operations","children":{"args":[{"id":"BinExp","data":"Add","children":{"left":{"id":"Num","data":1},"right":{"id":"Num","data":2}}},{"id":"BinExp","data":"Sub","children":{"left":{"id":"Num","data":1.45},"right":{"id":"Num","data":2.543}}},{"id":"BinExp","data":"Mul","children":{"left":{"id":"Num","data":2},"right":{"id":"Num","data":4}}},{"id":"BinExp","data":"Div","children":{"left":{"id":"Num","data":1},"right":{"id":"Num","data":2}}},{"id":"BinExp","data":"Mul","children":{"left":{"id":"BinExp","data":"Pow","children":{"left":{"id":"Num","data":2},"right":{"id":"Num","data":3}}},"right":{"id":"Num","data":7}}},{"id":"BinExp","data":"Mod","children":{"left":{"id":"Num","data":6},"right":{"id":"Num","data":3}}}]}}]}]],
})
test({
	run = [[OperationOrder(2 + 2 * 4, 1.45 - 2.543 / 2.34, (1 + 2) * 4);]],
	expected = [[{"id":"Root","data":"","children":[{"id":"Call","data":"OperationOrder","children":{"args":[{"id":"BinExp","data":"Add","children":{"left":{"id":"Num","data":2},"right":{"id":"BinExp","data":"Mul","children":{"left":{"id":"Num","data":2},"right":{"id":"Num","data":4}}}}},{"id":"BinExp","data":"Sub","children":{"left":{"id":"Num","data":1.45},"right":{"id":"BinExp","data":"Div","children":{"left":{"id":"Num","data":2.543},"right":{"id":"Num","data":2.34}}}}},{"id":"BinExp","data":"Mul","children":{"left":{"id":"BinExp","data":"Add","children":{"left":{"id":"Num","data":1},"right":{"id":"Num","data":2}}},"right":{"id":"Num","data":4}}}]}}]}]],
})
test({
	run = [[BoolEvals(true == false, 4 * 5 >= 1, -1 < 17);]],
	expected = [[{"id":"Root","data":"","children":[{"id":"Call","data":"BoolEvals","children":{"args":[{"id":"BinExp","data":"Eq","children":{"left":{"id":"Bool","data":true},"right":{"id":"Bool","data":false}}},{"id":"BinExp","data":"GreatEq","children":{"left":{"id":"BinExp","data":"Mul","children":{"left":{"id":"Num","data":4},"right":{"id":"Num","data":5}}},"right":{"id":"Num","data":1}}},{"id":"BinExp","data":"Less","children":{"left":{"id":"Num","data":-1},"right":{"id":"Num","data":17}}}]}}]}]],
})
