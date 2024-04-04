-- Primary
export type Result<T> = {
	ok: boolean,
	err: string?,
	data: T?,
}

export type Process = {
	memDef: (name: string, value: ASTData) -> (),
	memRead: (name: string) -> ASTData?,
}

export type CallContext = {
	target: Instance?,
	args: { ASTData? },
	validatedParam: ValidatedParam?,
	process: Process,
}

export type Lexemes = { Lexeme }
export type Lexeme = {
	id: string,
	data: string,
}

export type ASTNode = {
	id: string,
	data: ASTData, -- Empty string commonly used in cases of unread data
	children: ASTChildren?,
}

export type TypeString = "any" | "string" | "number" | "boolean" | "thunk"
export type InternalTypeString = TypeString | "error"

export type thunk = () -> ()
export type ASTData = string | number | boolean | thunk
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

-- Actions & Routines
export type Action = (context: CallContext) -> ()
export type Routine = Action

export type ActionModule = {
	ValidateArgs: { [number]: string },
	ValidateTarget: (ValidateTargetFunc | boolean)?,
	Run: Action,
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
