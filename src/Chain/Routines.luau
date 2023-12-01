local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))

local index = {}

local Routines = {}

function Routines.Added(routine: Model)
	if not CurrentMap.HasDescendant(routine) or not routine:IsA("Model") then
		return
	end

	index[routine] = true -- TODO: Parse routine in DataModel then precompile
end

function Routines.Removed(routine: Model)
	index[routine] = nil
end

return Routines
