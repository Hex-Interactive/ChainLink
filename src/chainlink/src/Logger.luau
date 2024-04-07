-- Simple logger pattern, possibly should be a package

local WARN_MESSAGE = "ChainLinkWarn: %s"
local ERR_MESSAGE = "ChainLinkError: %s"

local Logger = {}

function Logger.Error(text: string)
	error(string.format(ERR_MESSAGE, text), 0)
end

function Logger.Warn(text: string)
	warn(string.format(WARN_MESSAGE, text))
end

function Logger.Assert(subject: any?, text: string)
	if not subject then
		Logger.Error(text)
	end
end

return Logger
