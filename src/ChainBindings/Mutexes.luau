local Util = require(script.Parent.Parent:WaitForChild("Util"))

local index = {}

local Mutexes = {}

function Mutexes.Create(id: string)
	Util.Assert(index[id] == nil, `identifier mutex "{id}" already exists`)
	index[id] = true
end

function Mutexes.IsLocked(id: string): boolean
	return index[id] == true
end

function Mutexes.Clear(id: string)
	index[id] = nil
end

return Mutexes
