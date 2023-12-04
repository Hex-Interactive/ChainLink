local WARN_MESSAGE = "ChainLinkWarn: %s"
local ERR_MESSAGE = "ChainLinkError: %s"

local Util = {}

function Util.LogError(text: string)
	error(string.format(ERR_MESSAGE, text), 0)
end

function Util.LogWarn(text: string)
	warn(string.format(WARN_MESSAGE, text))
end

function Util.Assert(subject: any?, text: string)
	if not subject then
		Util.LogError(text)
	end
end

return Util
