return table.freeze({
	Unexp = "Unexp", -- Unexpected instruction

	Str = "Str", -- Any string
	Num = "Num", -- Any string
	Bool = "Bool", -- Any boolean
	Thunk = "Thunk", -- Any enevaluated branch of Chain

	Root = "Root", -- The beginning/root of the AST
	Call = "Call", -- Action or routine call
	BinExp = "BinExp", -- Binary expression
	Not = "Not", -- Logical expression inversion
})
