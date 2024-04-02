return table.freeze({
	Unexp = "Unexp", -- Unexpected instruction

	Str = "Str", -- Any string
	Num = "Num", -- Any string
	Bool = "Bool", -- Any boolean

	Not = "Not", -- Inverts an expression

	Root = "Root", -- The beginning/root of the AST
	Call = "Call", -- Action or routine call
	BinExp = "BinExp", -- Binary expression
	Thunk = "Thunk", -- Unevaluated call, thunk
})
