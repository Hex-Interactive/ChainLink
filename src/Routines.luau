local CurrentMap = require(script.Parent:WaitForChild("CurrentMap"))

local index = {}

local Routines = {}

function Routines.Added(routine: Model)
	if not CurrentMap.HasDescendant(routine) or not routine:IsA("Model") then
		return
	end

	index[routine] = true -- TODO: Handle routine added
end

function Routines.Removed(routine: Model)
	index[routine] = nil
end

return Routines
