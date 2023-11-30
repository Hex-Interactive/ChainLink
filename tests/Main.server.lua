local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Chain = require(ReplicatedStorage.Packages.ChainLink.Chain)
Chain.Execute(`Name(true,"hello \\" there",1+2,-33);TestHere()`)
Chain.Execute(`NumberTesting(23.64,-0.4,76)`)
