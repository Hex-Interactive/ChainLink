"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[53],{1109:e=>{e.exports=JSON.parse('{"pluginId":"default","version":"current","label":"Next","banner":null,"badge":false,"noIndex":false,"className":"docs-version-current","isLast":true,"docsSidebars":{"guideSidebar":[{"type":"link","label":"Introduction","href":"/ChainLink/docs/","docId":"introduction","unlisted":false},{"type":"category","label":"Getting Started","collapsible":true,"collapsed":false,"items":[{"type":"link","label":"Installation","href":"/ChainLink/docs/getting-started/installation","docId":"getting-started/installation","unlisted":false},{"type":"link","label":"Configuration","href":"/ChainLink/docs/getting-started/configuration","docId":"getting-started/configuration","unlisted":false}]},{"type":"category","label":"Concepts","collapsible":true,"collapsed":false,"items":[{"type":"link","label":"Links","href":"/ChainLink/docs/concepts/links","docId":"concepts/links","unlisted":false},{"type":"link","label":"Actions","href":"/ChainLink/docs/concepts/actions","docId":"concepts/actions","unlisted":false},{"type":"link","label":"Routines","href":"/ChainLink/docs/concepts/routines","docId":"concepts/routines","unlisted":false},{"type":"link","label":"Triggers","href":"/ChainLink/docs/concepts/triggers","docId":"concepts/triggers","unlisted":false},{"type":"link","label":"Validators","href":"/ChainLink/docs/concepts/validators","docId":"concepts/validators","unlisted":false},{"type":"category","label":"Chain","collapsible":true,"collapsed":true,"items":[{"type":"link","label":"Syntax","href":"/ChainLink/docs/concepts/chain/syntax","docId":"concepts/chain/syntax","unlisted":false},{"type":"link","label":"Usage","href":"/ChainLink/docs/concepts/chain/usage","docId":"concepts/chain/usage","unlisted":false}],"href":"/ChainLink/docs/concepts/chain/"}]},{"type":"category","label":"Implementation","collapsible":true,"collapsed":false,"items":[{"type":"link","label":"Practices","href":"/ChainLink/docs/implementation/practices","docId":"implementation/practices","unlisted":false},{"type":"link","label":"Security","href":"/ChainLink/docs/implementation/security","docId":"implementation/security","unlisted":false}]}]},"docs":{"concepts/actions":{"id":"concepts/actions","title":"Actions","description":"Actions are the lowest level of an instructional unit. Actions are programmed in Luau and defined by the developer of the game, for use through ChainLink in maps. Specifically, Actions are called when Chain is being executed.","sidebar":"guideSidebar"},"concepts/chain/index":{"id":"concepts/chain/index","title":"Chain","description":"Chain is a custom list-based scripting language. It\'s intentionally simple, lacking common programming features such as if-statements or functions. The singluar goal of Chain is to be a list of definitive instructions to execute. Achieving more complex logic with Chain comes from the usage of features like Links, Actions, and Routines.","sidebar":"guideSidebar"},"concepts/chain/syntax":{"id":"concepts/chain/syntax","title":"Syntax","description":"The syntax of Chain is quite simple. Generally, it is a list of calls separated by semicolons. Calls can be Actions or Routines. Calls can have a target, denoted by an arrow (->) to target a certain identifier, part of Link Ids. Some Actions require a target to be provided and would be documented as such. Arguments can be passed into calls, if needed.","sidebar":"guideSidebar"},"concepts/chain/usage":{"id":"concepts/chain/usage","title":"Usage","description":"Chain is primarily used to execute Actions and Routines in a certain order. Many places throughout the system of ChainLink, there is an available space to put a \\"Chain script\\" for execution, typically whenever something is activated.","sidebar":"guideSidebar"},"concepts/links":{"id":"concepts/links","title":"Links","description":"Links are what tie your maps\'s presence in the Roblox DOM to the world of ChainLink. Whether a given Link is used for referencing or triggering, all Links are represented as a tag called Link on a given instance.","sidebar":"guideSidebar"},"concepts/routines":{"id":"concepts/routines","title":"Routines","description":"Routines are groupings of Chain in an ordered structure. They allow you to achieve more complexity through being able to reuse a Chain script in other Chain scripts, but not being rooted in Chain themselves. Instead, they are rooted in the Roblox DOM with instances.","sidebar":"guideSidebar"},"concepts/triggers":{"id":"concepts/triggers","title":"Triggers","description":"Triggers are much like the triggering aspect of Links, but for when player characters touch a BasePart. Triggers are represented as a tag called Trigger on a given BasePart.","sidebar":"guideSidebar"},"concepts/validators":{"id":"concepts/validators","title":"Validators","description":"Validators are used by the game developer to customize the internal logic of ChainLink by providing a place for game-specific logic. For example, Validators are used to customize the activation logic of Triggers. To register/define a Validator, see the configuration page.","sidebar":"guideSidebar"},"getting-started/configuration":{"id":"getting-started/configuration","title":"Configuration","description":"Configuring ChainLink is required in order to use the system. During the configuration process is also where you extend the native functionality in order to integrate it with your game\'s systems.","sidebar":"guideSidebar"},"getting-started/installation":{"id":"getting-started/installation","title":"Installation","description":"ChainLink is available for Rojo-based and Studio workflows.","sidebar":"guideSidebar"},"implementation/practices":{"id":"implementation/practices","title":"Practices","description":"As the Golden Rule states, ChainLink is only able to do as much as the game developer gives it capabilities to do. Because of this, creating a robust implementation of ChainLink for map developers relies on considerate practices from the game developer.","sidebar":"guideSidebar"},"implementation/security":{"id":"implementation/security","title":"Security","description":"Due to how ChainLink is targeted to be used in scenarios where community-created content can be integrated easily into games, it\'s important to maintain the sandbox that ChainLink creates when implementing it into your game.","sidebar":"guideSidebar"},"introduction":{"id":"introduction","title":"Introduction","description":"ChainLink is a DataModel-driven logic and control system that empowers map designers and builders in Roblox. The goal is to keep map-specific logic in the map itself, while avoiding nested and unorganized scripts. This concept has many benefits, notably for games which rely upon maps as a major form of content. Maps with unique features and logic to them are easier to create and are able to be worked on by those not familiar with Luau scripting.","sidebar":"guideSidebar"}}}')}}]);