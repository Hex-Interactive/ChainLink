-- Validators
export type Validator<T> = (subject: T) -> boolean

-- CurrentMap
export type MapDirectory = () -> Folder

-- Actions
export type Action = (context: ActionContext) -> ()
export type ActionContext = {
	target: Instance?,
	args: { ASTData? },
}
export type ActionModule = {
	Run: Action,
}

-- Chain
export type Result<T> = {
	ok: boolean,
	err: string?,
	data: T?,
}
export type Routine = () -> ()
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
