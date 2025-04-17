local addonName, ns = ...

local spellInfo = C_Spell.GetSpellInfo(2643)

local MultiShot = ns.NewShot(spellInfo.name)
ns.MultiShot = MultiShot

MultiShot.bar = ns.CastBar
MultiShot.baseCastTime = 0.5
