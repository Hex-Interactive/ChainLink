-- Validators
export type Validator<T> = (subject: T) -> boolean

-- CurrentMap
export type MapDirectory = () -> Folder

-- Actions
export type Action = (context: CallContext) -> ()
export type ActionModule = {
	ValidateArgs: { [number]: string },
	ValidateTarget: (ValidateTargetFunc | boolean)?,
	Run: Action,
}
type ValidateTargetFunc = (target: Instance) -> (boolean, any?)

-- Chain
export type Result<T> = {
	ok: boolean,
	err: string?,
	data: T?,
}
export type CallContext = {
	target: Instance?,
	args: { ASTData? },
	validatedParam: any?,
}
export type Routine = (context: CallContext) -> ()
export type Lexemes = { Lexeme }
export type Lexeme = {
	id: string,
	data: string,
}
export type ASTNode = {
	id: string,
	data: ASTData,
	children: ASTChildren?,
}
export type ASTData = string | number | boolean
export type ASTChildren = ASTChildren_Root | ASTChildren_Call | ASTChildren_BinExp
export type ASTChildren_Root = { ASTNode }
export type ASTChildren_Call = {
	target: ASTNode?,
	args: { ASTNode },
}
export type ASTChildren_BinExp = {
	left: ASTNode,
	right: ASTNode,
}

return nil
