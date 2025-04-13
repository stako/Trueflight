local addonName, ns = ...

local spellInfo = C_Spell.GetSpellInfo(19434)

local PlayerState = ns.PlayerState
local AimedShot = ns.NewShot(spellInfo.name)
ns.AimedShot = AimedShot

AimedShot.bar = ns.CastBar
AimedShot.baseCastTime = spellInfo.castTime / 1000 + 0.5
