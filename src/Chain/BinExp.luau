local LexemeIDs = require(script.Parent:WaitForChild("LexemeIDs"))

export type Value = number | boolean

local typeChecking = {
	[LexemeIDs.Pow] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.Mod] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.Mul] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.Div] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.Add] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.Sub] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.Eq] = { x = { "number", "boolean" }, y = { "number", "boolean" } },
	[LexemeIDs.LessEq] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.Less] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.GreatEq] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.Great] = { x = { "number" }, y = { "number" } },
	[LexemeIDs.NotEq] = { x = { "number", "boolean" }, y = { "number", "boolean" } },
}

local evals = {
	[LexemeIDs.Pow] = function(x: any, y: any): any
		return math.pow(x, y)
	end,
	[LexemeIDs.Mod] = function(x: any, y: any): any
		return x % y
	end,
	[LexemeIDs.Mul] = function(x: any, y: any): any
		return x * y
	end,
	[LexemeIDs.Div] = function(x: any, y: any): any
		return x / y
	end,
	[LexemeIDs.Add] = function(x: any, y: any): any
		return x + y
	end,
	[LexemeIDs.Sub] = function(x: any, y: any): any
		return x - y
	end,
	[LexemeIDs.Eq] = function(x: any, y: any): any
		return x == y
	end,
	[LexemeIDs.LessEq] = function(x: any, y: any): any
		return x <= y
	end,
	[LexemeIDs.Less] = function(x: any, y: any): any
		return x < y
	end,
	[LexemeIDs.GreatEq] = function(x: any, y: any): any
		return x >= y
	end,
	[LexemeIDs.Great] = function(x: any, y: any): any
		return x > y
	end,
	[LexemeIDs.NotEq] = function(x: any, y: any): any
		return x ~= y
	end,
}

local BinExp = {}

function BinExp.IsOpDefined(op: string): boolean
	return evals[op] ~= nil
end

function BinExp.TypeCheck(op: string, x: any, y: any): boolean
	local expected = typeChecking[op]
	if not expected then
		return false
	end

	if table.find(expected.x, typeof(x)) or table.find(expected.y, typeof(y)) then
		return false
	end

	return true
end

function BinExp.Eval(op: string, x: Value, y: Value): Value
	return evals[op](x, y)
end

return BinExp
