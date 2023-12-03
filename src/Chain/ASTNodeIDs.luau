return table.freeze({
	Unexpected = "Unexpected", -- Unexpected instruction

	String = "String", -- Any string
	Number = "Number", -- Any string
	Bool = "Bool", -- Any boolean

	Root = "Root", -- The beginning/root of the AST
	Call = "Call", -- Action or routine call
	BinExp = "BinExp", -- Binary expression
})
