local LexemeIDs = require(script.Parent:WaitForChild("LexemeIDs"))

return table.freeze({
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
})
