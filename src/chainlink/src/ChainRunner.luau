local Routines = require(script.Parent:WaitForChild("ChainBindings"):WaitForChild("Routines"))
local Actions = require(script.Parent:WaitForChild("ChainBindings"):WaitForChild("Actions"))
local Links = require(script.Parent:WaitForChild("ChainBindings"):WaitForChild("Links"))
local Chain = require(script.Parent.Parent:WaitForChild("Chain"))

local ChainRunner = {}

function ChainRunner.Execute(source: string)
	local calls = Actions.Export()
	for index, value in Routines.Export() do
		calls[index] = value
	end

	Chain.Execute(source, Chain.CreateBindings(calls, Links.Export()))
end

return ChainRunner
