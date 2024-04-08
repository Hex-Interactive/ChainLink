local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChainLink = require(ReplicatedStorage.Packages.ChainLink)

local map = Instance.new("Folder")
map.Name = "Map"

for _, asset in script.Parent:WaitForChild("Assets"):GetChildren() do
	if not string.match(asset.Name, "After_") then
		asset.Parent = map
	end
end

map.Parent = workspace

ChainLink.RegisterDefaultActions()
ChainLink.SetMapDirectory(function()
	return map
end)
ChainLink.Init()

-- TODO: Test here

for _, asset in script.Parent:WaitForChild("Assets"):GetChildren() do
	asset.Parent = map
end

-- TODO: Test here
