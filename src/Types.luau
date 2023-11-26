-- Actions/Routines/Behaviors
export type Behavior = (context: ActionContext) -> ()
export type Action = {
	Run: Behavior,
}
export type ActionContext = {
	target: Instance?,
	parameter: ChainParameter,
}

-- Validators
export type Validator<T> = (subject: T) -> boolean

-- CurrentMap
export type MapDirectory = () -> Folder

-- Chain
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
