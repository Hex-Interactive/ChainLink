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
export type Instructions = { Instruction }
export type Instruction = {
	id: string,
	args: { string },
}
export type Routine = () -> ()
export type RoutineLayer = { RoutineStep }
export type RoutineStep = {
	class: string,
	data: any?,
	childLayers: { RoutineLayer }?,
}

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
