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
export type InternalTypeString = TypeString | "error"

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

export type CallDef = (context: Context) -> ()
export type Context = {
	process: Process,
	args: { Type? },
	target: Instance?,
	validatedParam: ValidatedParam?,
}

export type ActionModule = {
	ValidateArgs: { [number]: string },
	ValidateTarget: (ValidateTargetFunc | boolean)?,
	Run: CallDef,
}

type ValidateTargetFunc = (target: Instance) -> (boolean, ValidatedParam?)
type ValidatedParam = any

-- Utils
local ChainTypes = {}

function ChainTypes.Of(value: any): InternalTypeString
	local result = typeof(value)

	if result == "function" then
		return "thunk"
	elseif result == "boolean" or result == "string" or result == "number" then
		return result
	end

	return "error"
end

return ChainTypes
