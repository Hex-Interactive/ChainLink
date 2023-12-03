-- Validators
export type Validator<T> = (subject: T) -> boolean

-- CurrentMap
export type MapDirectory = () -> Folder

-- Actions
export type Action = (context: ActionContext) -> ()
export type ActionContext = {
	target: Instance?,
	parameter: ChainParameter,
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
export type Lexemes = { Lexeme }
export type Lexeme = {
	id: string,
	data: string,
}
export type Routine = () -> ()
export type RoutineLayer = { RoutineStep }
export type RoutineStep = {
	class: string,
	data: any?,
	childLayers: { RoutineLayer }?,
}
export type ASTNode = {
	id: string,
	data: ASTData,
	children: ASTChildren?,
}
export type ASTData = string | number | boolean
export type ASTChildren = ASTChildren_Root | ASTChildren_Call | ASTChildren_BinExp
type ASTChildren_Root = { ASTNode }
type ASTChildren_Call = {
	target: ASTNode?,
	args: { ASTNode },
}
type ASTChildren_BinExp = {
	left: ASTNode,
	right: ASTNode,
}

-- Pending removal
export type ExtraData = {
	[string]: any,
}
export type ChainParameter = {
	GetInputs: (desiredTypes: { string }) -> { any },
	GetInput: (inputIndex: number, desiredType: string) -> any,

	source: string,
	extraData: ExtraData,
	rawInputs: { string },
}

return nil
