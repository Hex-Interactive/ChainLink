local Types = require(script.Parent:WaitForChild("Types"))

local VALIDATOR_NAMES = {
	CanTrigger = true,
	CanTriggerPlayer = true,
}

local index = {}

local Validators = {}

function Validators.Register(validators: {
	CanTrigger: Types.Validator<nil>?,
	CanTriggerPlayer: Types.Validator<Player>?,
})
	for name, validator in pairs(validators) do
		assert(VALIDATOR_NAMES[name], `validator "{name}" unknown`)
		index[name] = validator
	end
end

function Validators.Validate(name: string, subject: any?): boolean
	local validator = index[name]
	if not validator then
		return true
	end

	return validator(subject)
end

return Validators
