local Types = require(script.Parent:WaitForChild("Types"))

local validatorNames = {
	CanTrigger = true,
	CanTriggerPlayer = true,
}

local index = {}

local ValidatorRegistry = {}

function ValidatorRegistry.Register(validators: {
	CanTrigger: Types.Validator<nil>?,
	CanTriggerPlayer: Types.Validator<Player>?,
})
	for name, validator in pairs(validators) do
		assert(validatorNames[name], `validator "{name}" unknown`)
		index[name] = validator
	end
end

function ValidatorRegistry.Validate(name: string, subject: any?): boolean
	local validator = index[name]
	if not validator then
		return true
	end

	return validator(subject)
end

return ValidatorRegistry
