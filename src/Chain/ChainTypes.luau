-- General
export type Result<T> = {
	ok: boolean,
	err: string?,
	data: T?,
}

-- Types
export type thunk = () -> ()
export type Type = string | number | boolean | thunk

export type TypeString = "any" | "string" | "number" | "boolean" | "thunk"
export type TypeStringNilable = TypeString | "any?" | "string?" | "number?" | "boolean?" | "thunk?"
export type TypeStringInternal = TypeString | "error"

-- Lexer
export type Lexemes = { Lexeme }
export type Lexeme = {
	id: string,
	data: string,
}

-- AST
export type ASTNode = {
	id: string,
	data: Type,
	children: ASTChildren?,
}

export type ASTChildren = ASTChildren_Root | ASTChildren_Call | ASTChildren_BinExp | ASTChildren_Thunk | ASTChildren_Not

export type ASTChildren_Not = ASTNode
export type ASTChildren_Root = { ASTNode }
export type ASTChildren_Thunk = { ASTNode }

export type ASTChildren_Call = {
	target: ASTNode?,
	args: { ASTNode },
}

export type ASTChildren_BinExp = {
	left: ASTNode,
	right: ASTNode,
}

-- Definitions
export type Process = {
	memDef: (name: string, value: Type) -> (),
	memRead: (name: string) -> Type?,
}

export type Call = (context: Context) -> ()

type ValidatedArg = unknown?
export type Context = {
	process: Process,
	args: { Type? },
	validatedArg: ValidatedArg,
	target: Instance?,
}

export type FunctionalTarget = (target: Instance) -> (boolean, ValidatedArg)
export type CallDefinition = {
	parameters: { [number]: TypeStringNilable },
	target: FunctionalTarget | boolean,
	call: Call,
}

export type Bindings = {
	builtinCalls: { [string]: CallDefinition },
	calls: { [string]: CallDefinition },
	targets: { [string]: { Instance } },
}

-- Utils
local ChainTypes = {}

function ChainTypes.Of(value: any): TypeStringInternal
	local result = typeof(value)

	if result == "function" then
		return "thunk"
	elseif result == "boolean" or result == "string" or result == "number" then
		return result
	end

	return "error"
end

return ChainTypes
