local ERR_MESSAGE = "ChainError: %s"

local ChainUtil = {}

function ChainUtil.LogError(text: string)
	error(string.format(ERR_MESSAGE, text))
end

function ChainUtil.Assert(subject: any?, text: string)
	if not subject then
		ChainUtil.LogError(text)
	end
end

return ChainUtil
