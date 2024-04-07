local Logger = require(script.Parent:WaitForChild("Logger"))
local Types = require(script.Parent:WaitForChild("Types"))

local getDirectory

local CurrentMap = {}

function CurrentMap.SetDirectory(getter: Types.MapDirectory)
	getDirectory = getter
end

function CurrentMap.GetDirectory(): Instance
	Logger.Assert(getDirectory ~= nil, "map directory not defined")
	return getDirectory()
end

function CurrentMap.HasDescendant(instance: Instance): boolean
	local directory = CurrentMap.GetDirectory()
	return directory:IsAncestorOf(instance)
end

return CurrentMap
