local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChainLink = require(ReplicatedStorage.Packages.ChainLink)

-- Various syntax tests (TODO: Use a testing library)
ChainLink.ExecuteChain(`Name(true,"hello \\" there",1+2,-33);TestHere()`)
ChainLink.ExecuteChain(`Things->NumberTesting(23.64,-0.4,76)`)
