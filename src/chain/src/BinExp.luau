local LexemeIds = require(script.Parent:WaitForChild("LexemeIds"))
local Types = require(script.Parent:WaitForChild("Types"))

export type Value = number | boolean

local typeChecking: {
	[string]: {
		x: { Types.TypeString },
		y: { Types.TypeString },
	},
} = {
	[LexemeIds.Pow] = { x = { "number" }, y = { "number" } },
	[LexemeIds.Mod] = { x = { "number" }, y = { "number" } },
	[LexemeIds.Mul] = { x = { "number" }, y = { "number" } },
	[LexemeIds.Div] = { x = { "number" }, y = { "number" } },
	[LexemeIds.Add] = { x = { "number" }, y = { "number" } },
	[LexemeIds.Sub] = { x = { "number" }, y = { "number" } },
	[LexemeIds.Eq] = { x = { "number", "boolean" }, y = { "number", "boolean" } },
	[LexemeIds.LessEq] = { x = { "number" }, y = { "number" } },
	[LexemeIds.Less] = { x = { "number" }, y = { "number" } },
	[LexemeIds.GreatEq] = { x = { "number" }, y = { "number" } },
	[LexemeIds.Great] = { x = { "number" }, y = { "number" } },
	[LexemeIds.NotEq] = { x = { "number", "boolean" }, y = { "number", "boolean" } },
	[LexemeIds.And] = { x = { "boolean" }, y = { "boolean" } },
	[LexemeIds.Or] = { x = { "boolean" }, y = { "boolean" } },
}

local evals = {
	[LexemeIds.Pow] = function(x: any, y: any): any
		return math.pow(x, y)
	end,
	[LexemeIds.Mod] = function(x: any, y: any): any
		return x % y
	end,
	[LexemeIds.Mul] = function(x: any, y: any): any
		return x * y
	end,
	[LexemeIds.Div] = function(x: any, y: any): any
		return x / y
	end,
	[LexemeIds.Add] = function(x: any, y: any): any
		return x + y
	end,
	[LexemeIds.Sub] = function(x: any, y: any): any
		return x - y
	end,
	[LexemeIds.Eq] = function(x: any, y: any): any
		return x == y
	end,
	[LexemeIds.LessEq] = function(x: any, y: any): any
		return x <= y
	end,
	[LexemeIds.Less] = function(x: any, y: any): any
		return x < y
	end,
	[LexemeIds.GreatEq] = function(x: any, y: any): any
		return x >= y
	end,
	[LexemeIds.Great] = function(x: any, y: any): any
		return x > y
	end,
	[LexemeIds.NotEq] = function(x: any, y: any): any
		return x ~= y
	end,
	[LexemeIds.And] = function(x: any, y: any): any
		return x and y
	end,
	[LexemeIds.Or] = function(x: any, y: any): any
		return x or y
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

	if table.find(expected.x, Types.Of(x)) or table.find(expected.y, Types.Of(y)) then
		return false
	end

	return true
end

function BinExp.Eval(op: string, x: Value, y: Value): Value
	return evals[op](x, y)
end

return BinExp
