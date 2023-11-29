return table.freeze({
	Eof = "Eof", -- End of file/source
	OutOfOrder = "OutOfOrder", -- Character in the wrong place
	Unknown = "Unknown", -- Unknown character

	Arrow = "Arrow", -- Arrow (->)

	Equal = "Equal", -- Equal to (==)
	LessEqual = "LessEqual", -- Less than or equal to (<=)
	Less = "Less", -- Less than (<)
	GreaterEqual = "GreaterEqual", -- Greater than or equal to (>=)
	Greater = "Greater", -- Greater than (<)
	NotEqual = "NotEqual", -- Not equal to (~=)
})
