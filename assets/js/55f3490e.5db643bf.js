"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[2e3],{7279:(e,r,t)=>{t.r(r),t.d(r,{assets:()=>o,contentTitle:()=>n,default:()=>l,frontMatter:()=>a,metadata:()=>c,toc:()=>h});var i=t(4848),s=t(8453);const a={sidebar_position:4},n="Triggers",c={id:"chainlink/concepts/triggers",title:"Triggers",description:"Triggers are much like the triggering aspect of Links, but for when player characters touch a BasePart. Triggers are represented as a tag called Trigger on a given BasePart.",source:"@site/docs/chainlink/concepts/triggers.md",sourceDirName:"chainlink/concepts",slug:"/chainlink/concepts/triggers",permalink:"/ChainLink/docs/chainlink/concepts/triggers",draft:!1,unlisted:!1,editUrl:"https://github.com/Hex-Interactive/ChainLink/edit/main/docs/docs/chainlink/concepts/triggers.md",tags:[],version:"current",sidebarPosition:4,frontMatter:{sidebar_position:4},sidebar:"chainlink",previous:{title:"Routines",permalink:"/ChainLink/docs/chainlink/concepts/routines"},next:{title:"Validators",permalink:"/ChainLink/docs/chainlink/concepts/validators"}},o={},h=[{value:"Setup",id:"setup",level:2},{value:"Validators",id:"validators",level:2}];function d(e){const r={a:"a",code:"code",h1:"h1",h2:"h2",p:"p",table:"table",tbody:"tbody",td:"td",th:"th",thead:"thead",tr:"tr",...(0,s.R)(),...e.components};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(r.h1,{id:"triggers",children:"Triggers"}),"\n",(0,i.jsxs)(r.p,{children:["Triggers are much like the triggering aspect of ",(0,i.jsx)(r.a,{href:"links",children:"Links"}),", but for when ",(0,i.jsx)(r.a,{href:"https://create.roblox.com/docs/reference/engine/classes/Player#Character",children:"player characters"})," touch a BasePart. Triggers are represented as a ",(0,i.jsx)(r.a,{href:"https://create.roblox.com/docs/reference/engine/classes/CollectionService",children:"tag"})," called ",(0,i.jsx)(r.code,{children:"Trigger"})," on a given BasePart."]}),"\n",(0,i.jsx)(r.h2,{id:"setup",children:"Setup"}),"\n",(0,i.jsxs)(r.p,{children:["Triggers require two attributes of type ",(0,i.jsx)(r.code,{children:"string"}),'. They are "TriggerMode" for how the Trigger should activate and "TriggerChain" for the ',(0,i.jsx)(r.a,{href:"chain",children:"Chain"})," script to execute when successfully activated."]}),"\n",(0,i.jsx)(r.p,{children:'The "TriggerMode" attribute has to match a valid mode:'}),"\n",(0,i.jsxs)(r.table,{children:[(0,i.jsx)(r.thead,{children:(0,i.jsxs)(r.tr,{children:[(0,i.jsx)(r.th,{children:"Mode"}),(0,i.jsx)(r.th,{children:"Functionality"})]})}),(0,i.jsx)(r.tbody,{children:(0,i.jsxs)(r.tr,{children:[(0,i.jsx)(r.td,{children:"Player"}),(0,i.jsxs)(r.td,{children:["Will trigger when a direct BasePart child of a player character ",(0,i.jsx)(r.a,{href:"https://create.roblox.com/docs/reference/engine/classes/BasePart#Touched",children:"touches"})," the Trigger"]})]})})]}),"\n",(0,i.jsx)(r.h2,{id:"validators",children:"Validators"}),"\n",(0,i.jsxs)(r.p,{children:["By default, Triggers don't have any game-specific validation on what and when they can activate on. Thus, on the game developer's end, you need to define the conditions where Triggers can activate. To do this, utilize ",(0,i.jsx)(r.a,{href:"validators",children:"Validators"}),"."]})]})}function l(e={}){const{wrapper:r}={...(0,s.R)(),...e.components};return r?(0,i.jsx)(r,{...e,children:(0,i.jsx)(d,{...e})}):d(e)}}}]);