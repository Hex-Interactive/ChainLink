local CollectionService = game:GetService("CollectionService")

local CurrentMap = require(script.Parent.Parent:WaitForChild("CurrentMap"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))

local Links = {}

function Links.Export(): { [string]: { Instance } }
	local links = {}

	for _, link in CollectionService:GetTagged(Names.Tags.Link) do
		local fullId = link:GetAttribute(Names.Attr.LinkId)
		if not fullId or not CurrentMap.HasDescendant(link) then
			continue
		end

		local ids = string.split(fullId, ";")
		if #ids <= 0 then
			continue
		end

		for _, id in ids do
			if not links[id] then
				links[id] = {}
			end

			table.insert(links[id], link)
		end
	end

	return links
end

return Links
