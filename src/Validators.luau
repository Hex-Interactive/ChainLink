local Types = require(script.Parent:WaitForChild("Types"))
local Util = require(script.Parent:WaitForChild("Util"))

local VALIDATOR_NAMES = table.freeze({
	CanTrigger = true,
	CanTriggerPlayer = true,
})

local index = {}

local Validators = {}

function Validators.Register(validators: {
	CanTrigger: Types.Validator<nil>?,
	CanTriggerPlayer: Types.Validator<Player>?,
})
	for name, validator in pairs(validators) do
		Util.Assert(VALIDATOR_NAMES[name], `unknown validator "{name}"`)
		index[name] = validator
	end
end

function Validators.Check(name: string, subject: any?): boolean
	local validator = index[name]
	if not validator then
		return true
	end

	return validator(subject)
end

return Validators
