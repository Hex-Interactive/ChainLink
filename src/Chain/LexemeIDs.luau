return table.freeze({
	Eof = "Eof", -- End of file/source
	UnexpEof = "UnexpEof", -- Unexpected end of file
	UnexpChar = "UnexpChar", -- Unexpected character
	UknChar = "UknChar", -- Unknown character
	None = "None", -- Whitespace characters

	Id = "Id", -- Any keyword, action name, or routine name (identifier)
	Str = "Str", -- Any string
	Num = "Num", -- Any number

	Arr = "Arr", -- Arrow (->)
	NxCall = "NxCall", -- Next call (;)
	NxArg = "NxArg", -- Next argument (,)
	LParen = "LParen", -- Left parenthesis (()
	RParen = "RParen", -- Right parenthesis ())

	Eq = "Eq", -- Equal to (==)
	LessEq = "LessEq", -- Less than or equal to (<=)
	Less = "Less", -- Less than (<)
	GreatEq = "GreatEq", -- Greater than or equal to (>=)
	Great = "Great", -- Greater than (>)
	NotEq = "NotEq", -- Not equal to (~=)

	Add = "Add", -- Addition (+)
	Sub = "Sub", -- Subtraction (-)
	Mul = "Mul", -- Multiplication (*)
	Div = "Div", -- Division (/)
	Mod = "Mod", -- Modulus (%)
	Pow = "Pow", -- Power (^)
})
