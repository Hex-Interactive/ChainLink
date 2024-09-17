"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[8581],{5610:i=>{i.exports=JSON.parse('{"pluginId":"default","version":"current","label":"Next","banner":null,"badge":false,"noIndex":false,"className":"docs-version-current","isLast":true,"docsSidebars":{"chainlink":[{"type":"link","label":"Introduction","href":"/ChainLink/docs/chainlink","docId":"chainlink/introduction","unlisted":false},{"type":"category","label":"Getting Started","collapsible":true,"collapsed":false,"items":[{"type":"link","label":"Installation","href":"/ChainLink/docs/chainlink/getting-started/installation","docId":"chainlink/getting-started/installation","unlisted":false},{"type":"link","label":"Configuration","href":"/ChainLink/docs/chainlink/getting-started/configuration","docId":"chainlink/getting-started/configuration","unlisted":false}]},{"type":"category","label":"Concepts","collapsible":true,"collapsed":false,"items":[{"type":"link","label":"Links","href":"/ChainLink/docs/chainlink/concepts/links","docId":"chainlink/concepts/links","unlisted":false},{"type":"link","label":"Actions","href":"/ChainLink/docs/chainlink/concepts/actions","docId":"chainlink/concepts/actions","unlisted":false},{"type":"link","label":"Routines","href":"/ChainLink/docs/chainlink/concepts/routines","docId":"chainlink/concepts/routines","unlisted":false},{"type":"link","label":"Triggers","href":"/ChainLink/docs/chainlink/concepts/triggers","docId":"chainlink/concepts/triggers","unlisted":false},{"type":"link","label":"Validators","href":"/ChainLink/docs/chainlink/concepts/validators","docId":"chainlink/concepts/validators","unlisted":false},{"type":"link","label":"Chain","href":"/ChainLink/docs/chainlink/concepts/chain","docId":"chainlink/concepts/chain","unlisted":false}]},{"type":"category","label":"Implementation","collapsible":true,"collapsed":false,"items":[{"type":"link","label":"Practices","href":"/ChainLink/docs/chainlink/implementation/practices","docId":"chainlink/implementation/practices","unlisted":false},{"type":"link","label":"Security","href":"/ChainLink/docs/chainlink/implementation/security","docId":"chainlink/implementation/security","unlisted":false}]}],"chain":[{"type":"link","label":"Introduction","href":"/ChainLink/docs/chain","docId":"chain/introduction","unlisted":false},{"type":"link","label":"Syntax","href":"/ChainLink/docs/chain/syntax","docId":"chain/syntax","unlisted":false},{"type":"link","label":"Types","href":"/ChainLink/docs/chain/types","docId":"chain/types","unlisted":false}]},"docs":{"chain/introduction":{"id":"chain/introduction","title":"Introduction","description":"Chain is a simplistic scripting language designed around flexibility of its implementation. The primary way to use Chain is with ChainLink, but it can be used without it for any other purposes a game may need with a runtime scripting language.","sidebar":"chain"},"chain/syntax":{"id":"chain/syntax","title":"Syntax","description":"The syntax of Chain is quite simple. Generally, it is a list of calls separated by semicolons. Calls can have a target, denoted by an arrow (->) to target a certain identifier. Some Actions require a target to be provided and would be documented as such. Arguments should be passed into calls, if required.","sidebar":"chain"},"chain/types":{"id":"chain/types","title":"Types","description":"Chain has its own runtime type system. In certain cases, notably with call definitions and defining parameters, you can supply optional types by appending a ?, but the Luau nil type is otherwise not allowed.","sidebar":"chain"},"chainlink/concepts/actions":{"id":"chainlink/concepts/actions","title":"Actions","description":"Actions are the lowest level of an instructional unit. Actions are programmed in Luau and defined by the developer of the game, for use through ChainLink in maps. Specifically, Actions are called when Chain is being executed.","sidebar":"chainlink"},"chainlink/concepts/chain":{"id":"chainlink/concepts/chain","title":"Chain","description":"Chain is a simplistic scripting language. It\'s how you add custom logic and behaviors to maps, by utilizing the features of the language itself alongside Actions and Routines. Chain can be used as a standalone feature in game development, but ChainLink is a runtime for Chain that provides helpful abstractions which map developers can make use of.","sidebar":"chainlink"},"chainlink/concepts/links":{"id":"chainlink/concepts/links","title":"Links","description":"Links are what tie your maps\'s presence in the Roblox DOM to the world of ChainLink. Whether a given Link is used for referencing or triggering, all Links are represented as a tag called Link on a given instance.","sidebar":"chainlink"},"chainlink/concepts/routines":{"id":"chainlink/concepts/routines","title":"Routines","description":"Routines are groupings of Chain in an ordered structure. They allow you to achieve more complexity through being able to reuse a Chain script in other Chain scripts, but not being rooted in Chain themselves. Instead, they are rooted in the Roblox DOM with instances.","sidebar":"chainlink"},"chainlink/concepts/triggers":{"id":"chainlink/concepts/triggers","title":"Triggers","description":"Triggers are much like the triggering aspect of Links, but for when player characters touch a BasePart. Triggers are represented as a tag called Trigger on a given BasePart.","sidebar":"chainlink"},"chainlink/concepts/validators":{"id":"chainlink/concepts/validators","title":"Validators","description":"Validators are used by the game developer to customize the internal logic of ChainLink by providing a place for game-specific logic. For example, Validators are used to customize the activation logic of Triggers. To register/define a Validator, see the configuration page.","sidebar":"chainlink"},"chainlink/getting-started/configuration":{"id":"chainlink/getting-started/configuration","title":"Configuration","description":"Configuring ChainLink is required in order to use the system. During the configuration process is also where you extend the native functionality in order to integrate it with your game\'s systems.","sidebar":"chainlink"},"chainlink/getting-started/installation":{"id":"chainlink/getting-started/installation","title":"Installation","description":"ChainLink is available for Rojo-based and Studio workflows.","sidebar":"chainlink"},"chainlink/implementation/practices":{"id":"chainlink/implementation/practices","title":"Practices","description":"As the Golden Rule states, ChainLink is only able to do as much as the game developer gives it capabilities to do. Because of this, creating a robust implementation of ChainLink for map developers relies on considerate practices from the game developer.","sidebar":"chainlink"},"chainlink/implementation/security":{"id":"chainlink/implementation/security","title":"Security","description":"Due to how ChainLink is targeted to be used in scenarios where community-created content can be integrated easily into games, it\'s important to maintain the sandbox that ChainLink creates when implementing it into your game.","sidebar":"chainlink"},"chainlink/introduction":{"id":"chainlink/introduction","title":"Introduction","description":"ChainLink is a DataModel-driven logic and control system that empowers map designers and builders in Roblox. The goal is to keep map-specific logic in the map itself, while avoiding nested and unorganized scripts. This concept has many benefits, notably for games which rely upon maps as a major form of content. Maps with unique features and logic to them are easier to create and are able to be worked on by those not familiar with Luau scripting.","sidebar":"chainlink"}}}')}}]);