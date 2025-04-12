local addonName, ns = ...

local spellInfo = C_Spell.GetSpellInfo(2643)

local PlayerState = ns.PlayerState
local MultiShot = ns.NewShot(spellInfo.name)
ns.MultiShot = MultiShot
