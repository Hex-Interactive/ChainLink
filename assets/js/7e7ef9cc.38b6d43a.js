"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[850],{4313:(e,i,n)=>{n.r(i),n.d(i,{assets:()=>c,contentTitle:()=>s,default:()=>d,frontMatter:()=>o,metadata:()=>r,toc:()=>l});var t=n(4848),a=n(8453);const o={sidebar_position:1},s="Practices",r={id:"chainlink/implementation/practices",title:"Practices",description:"As the Golden Rule states, ChainLink is only able to do as much as the game developer gives it capabilities to do. Because of this, creating a robust implementation of ChainLink for map developers relies on considerate practices from the game developer.",source:"@site/docs/chainlink/implementation/practices.md",sourceDirName:"chainlink/implementation",slug:"/chainlink/implementation/practices",permalink:"/ChainLink/docs/chainlink/implementation/practices",draft:!1,unlisted:!1,editUrl:"https://github.com/Hex-Interactive/ChainLink/edit/main/docs/docs/chainlink/implementation/practices.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{sidebar_position:1},sidebar:"chainlink",previous:{title:"Chain",permalink:"/ChainLink/docs/chainlink/concepts/chain"},next:{title:"Security",permalink:"/ChainLink/docs/chainlink/implementation/security"}},c={},l=[{value:"Keep Security In Mind",id:"keep-security-in-mind",level:2},{value:"Triggering Links",id:"triggering-links",level:2},{value:"Example",id:"example",level:3},{value:"Utilizing Chain In Code",id:"utilizing-chain-in-code",level:2},{value:"Implementing Custom Actions",id:"implementing-custom-actions",level:2},{value:"Documenting Your Implementation",id:"documenting-your-implementation",level:2}];function h(e){const i={a:"a",admonition:"admonition",code:"code",h1:"h1",h2:"h2",h3:"h3",li:"li",p:"p",ul:"ul",...(0,a.R)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(i.h1,{id:"practices",children:"Practices"}),"\n",(0,t.jsxs)(i.p,{children:["As the ",(0,t.jsx)(i.a,{href:"..#the-golden-rule",children:"Golden Rule"})," states, ChainLink is only able to do as much as the game developer gives it capabilities to do. Because of this, creating a robust implementation of ChainLink for map developers relies on considerate practices from the game developer."]}),"\n",(0,t.jsx)(i.p,{children:"The purpose of this page is to guide developers to implementing ChainLink so that map developers can take full advantage of ChainLink's and your game's systems."}),"\n",(0,t.jsx)(i.h2,{id:"keep-security-in-mind",children:"Keep Security In Mind"}),"\n",(0,t.jsxs)(i.p,{children:["As a general practice, it's important to keep your game's security in mind. This is especially the case if you are integrating community-created content, manual or automatic. You can read more about ChainLink security practices on ",(0,t.jsx)(i.a,{href:"security",children:"this page"}),"."]}),"\n",(0,t.jsx)(i.h2,{id:"triggering-links",children:"Triggering Links"}),"\n",(0,t.jsxs)(i.p,{children:["This is one of the most important aspects about implementing ChainLink well, but unfortunately one of the most abstract. ",(0,t.jsx)(i.a,{href:"../concepts/links",children:"Links"})," are a key element of ChainLink on the developer side because of their capability to be triggered and execute ",(0,t.jsx)(i.a,{href:"../concepts/chain",children:"Chain"})," scripts. Triggering a Link, however, is done manually on the game's developer side of things. This means that to have a featureful implementation for map developers to use when making maps for your game, you need to have many places in your game where you trigger Links."]}),"\n",(0,t.jsx)(i.p,{children:'It\'s helpful to think about the action of triggering a Link as a sort of "game-specific event" that map developers can hook onto and use through ChainLink. Making as many game-specific events trigger Links will give more options to map developers to make their maps unique and functionally interesting. To understand how exactly to go about doing this, an example can be helpful.'}),"\n",(0,t.jsx)(i.h3,{id:"example",children:"Example"}),"\n",(0,t.jsx)(i.p,{children:'Say you have a round-based game where players walk around maps scavenging for items they need to collect for some goal. To determine your game-specific events, you need to break down your game concept into a list of what players can "interact" with. You already have various interactions programmed into your game, so you\'ve listed out what they are.'}),"\n",(0,t.jsxs)(i.ul,{children:["\n",(0,t.jsx)(i.li,{children:"Opening and closing doors"}),"\n",(0,t.jsx)(i.li,{children:"Picking up an item"}),"\n",(0,t.jsx)(i.li,{children:"Breaking a glass case"}),"\n"]}),"\n",(0,t.jsxs)(i.p,{children:["This is essentially your list of which you want to trigger Links on. In code, you'd go to where you implemented these interactions and call ",(0,t.jsx)(i.code,{children:"ChainLink.TriggerLink()"})," by passing in the instance as an argument - door, item, or glass case. On the map developer's side, if they place a door in their map, they know they could add a Link to it which, when trigger, will execute a Chain script to do something specific in their map. For example, picking up a specialty item on a pedestal will trigger an alarm with sounds and lights."]}),"\n",(0,t.jsx)(i.h2,{id:"utilizing-chain-in-code",children:"Utilizing Chain In Code"}),"\n",(0,t.jsxs)(i.p,{children:["Another powerful way of implementing ChainLink can be directly executing Chain scripts through the ChainLink API. You can do this with the function ",(0,t.jsx)(i.code,{children:"ChainLink.ExecuteChain()"})," by passing in a Chain script as a string. You should use the same logic of deciding when to use this as ",(0,t.jsx)(i.a,{href:"#triggering-links",children:"triggering links"}),", but deattached from Links and their respective instance."]}),"\n",(0,t.jsxs)(i.p,{children:['Maybe you have multiple "phases" during a round of your game where players do different activities. To provide map developers with a way to make something unique happen when these phases change, you could utilize directly executing Chain to "call" a ',(0,t.jsx)(i.a,{href:"../concepts/routines",children:"Routine"})," created by the map developer which holds their custom logic."]}),"\n",(0,t.jsx)(i.h2,{id:"implementing-custom-actions",children:"Implementing Custom Actions"}),"\n",(0,t.jsxs)(i.p,{children:["Adding more ",(0,t.jsx)(i.a,{href:"../concepts/actions",children:"Actions"}),", especially ones that relate closely to your game's systems, is critical to give more power to your map developers. Simply using ChainLink's default Actions doesn't provide many features for map developers to take advantage of. At this point you should get creative and add more Actions of things you want to see in your maps. Alternatively, you can implement Actions that mirror the API of some of your game systems. Some examples of custom Actions specific to a game can be seen below."]}),"\n",(0,t.jsxs)(i.ul,{children:["\n",(0,t.jsx)(i.li,{children:"Giving a player an amount of coins"}),"\n",(0,t.jsx)(i.li,{children:"Adding more time to the current round"}),"\n",(0,t.jsx)(i.li,{children:"Spawning in a tornado entity"}),"\n"]}),"\n",(0,t.jsx)(i.admonition,{type:"warning",children:(0,t.jsxs)(i.p,{children:["It's important to keep security in mind when implementing Actions (such as ones that extend the round time or give coins), as there's no restrictions on calling Actions besides what you implement in their definition. See the ",(0,t.jsx)(i.a,{href:"security#custom",children:"security"})," page for more information."]})}),"\n",(0,t.jsxs)(i.p,{children:["You can read more about how to register custom actions on the ",(0,t.jsx)(i.a,{href:"../getting-started/configuration#registering-actions",children:"configuration"})," page."]}),"\n",(0,t.jsx)(i.h2,{id:"documenting-your-implementation",children:"Documenting Your Implementation"}),"\n",(0,t.jsx)(i.p,{children:"Due to how much of ChainLink's power comes from its implementation, this means that map developers will need to know as many details as possible about your implementation in order to utilize ChainLink. Below are some key subjects to clearly document as a resource for map developers regarding your game."}),"\n",(0,t.jsxs)(i.ul,{children:["\n",(0,t.jsx)(i.li,{children:"Where and when Links are triggered"}),"\n",(0,t.jsx)(i.li,{children:"Where and when you directly execute Chain"}),"\n",(0,t.jsx)(i.li,{children:"All the details about your custom Actions"}),"\n",(0,t.jsxs)(i.li,{children:["The conditions of your ",(0,t.jsx)(i.a,{href:"../concepts/validators",children:"Validators"})]}),"\n",(0,t.jsx)(i.li,{children:"A link to ChainLink's documentation (one that corresponds to the version of ChainLink you use)"}),"\n",(0,t.jsx)(i.li,{children:"Any other specifics about map development in regards to your game (and maybe some advice too!)"}),"\n"]})]})}function d(e={}){const{wrapper:i}={...(0,a.R)(),...e.components};return i?(0,t.jsx)(i,{...e,children:(0,t.jsx)(h,{...e})}):h(e)}}}]);