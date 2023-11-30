return table.freeze({
	Eof = "Eof", -- End of file/source
	OutOfOrder = "OutOfOrder", -- Character in the wrong place
	Unknown = "Unknown", -- Unknown character

	Identifier = "Identifier", -- Any Keyword or behavior name
	Paren = "Paren", -- Any parenthesis, ambiguous
	String = "String", -- Any string
	Number = "Number", -- Any number

	Arrow = "Arrow", -- Arrow (->)
	NextExp = "NextExp", -- Next expression (;)
	NextArg = "NextArg", -- Next argument (,)

	Equal = "Equal", -- Equal to (==)
	LessEqual = "LessEqual", -- Less than or equal to (<=)
	Less = "Less", -- Less than (<)
	GreaterEqual = "GreaterEqual", -- Greater than or equal to (>=)
	Greater = "Greater", -- Greater than (>)
	NotEqual = "NotEqual", -- Not equal to (~=)

	Add = "Add", -- Addition (+)
	Subtract = "Subtract", -- Subtraction (-)
	Multiply = "Multiply", -- Multiplication (*)
	Divide = "Divide", -- Division (/)
	Mod = "Mod", -- Modulus (%)
	Pow = "Pow", -- Power (^)
})
