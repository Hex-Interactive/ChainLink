-- Validators
export type Validator<T> = (subject: T) -> boolean

-- CurrentMap
export type MapDirectory = () -> Folder

-- Behaviors
export type Behavior = (context: BehaviorContext) -> ()
export type BehaviorContext = {
	target: Instance?,
	parameter: ChainParameter,
}
export type Action = {
	Run: Behavior,
}

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
