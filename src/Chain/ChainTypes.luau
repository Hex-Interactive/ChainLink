-- Primary
export type Result<T> = {
	ok: boolean,
	err: string?,
	data: T?,
}

export type CallContext = {
	target: Instance?,
	args: { ASTData? },
	validatedParam: ValidatedParam?,
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

export type ASTData = string | number | boolean
export type ASTChildren = ASTChildren_Root | ASTChildren_Call | ASTChildren_BinExp | ASTChildren_Thunk

export type ASTChildren_Root = { ASTNode }

export type ASTChildren_Call = {
	target: ASTNode?,
	args: { ASTNode },
}

export type ASTChildren_BinExp = {
	left: ASTNode,
	right: ASTNode,
}

export type ASTChildren_Thunk = {
	subject: ASTChildren_Call,
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

return nil
