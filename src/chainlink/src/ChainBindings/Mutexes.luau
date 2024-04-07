local Logger = require(script.Parent.Parent:WaitForChild("Logger"))

local index = {}

local Mutexes = {}

function Mutexes.Create(id: string)
	Logger.Assert(index[id] == nil, `identifier mutex "{id}" already exists`)
	index[id] = true
end

function Mutexes.IsLocked(id: string): boolean
	return index[id] == true
end

function Mutexes.Clear(id: string)
	index[id] = nil
end

return Mutexes
