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
export type Lexeme = { string }
export type Instruction = {} -- TODO

export type RoutineStep = {
	class: string,
	data: any?,
	childLayers: { RoutineLayer }?,
}
export type RoutineLayer = { RoutineStep }
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
