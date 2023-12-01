return table.freeze({
	Eof = "Eof", -- End of file/source
	UnexpectedEof = "UnexpectedEof", -- Unexpected end of file
	UnexpectedChar = "UnexpectedChar", -- Unexpected character
	UnknownChar = "UnknownChar", -- Unknown character

	Identifier = "Identifier", -- Any keyword, action name, or routine name
	String = "String", -- Any string
	Number = "Number", -- Any number

	Arrow = "Arrow", -- Arrow (->)
	NextExp = "NextExp", -- Next expression (;)
	NextArg = "NextArg", -- Next argument (,)
	StartParen = "StartParen", -- Left parenthesis (()
	EndParen = "EndParen", -- Right parenthesis ())

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
