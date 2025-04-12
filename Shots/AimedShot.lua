local addonName, ns = ...

-- Grab base cast time dynamically as it changes between Vanilla & TBC
local spellInfo = C_Spell.GetSpellInfo(19434)
baseCastTime = spellInfo.castTime / 1000 + 0.5

local PlayerState = ns.PlayerState
local AimedShot = ns.NewShot(spellInfo.name)
ns.AimedShot = AimedShot

AimedShot.bar = ns.CastBar

function AimedShot:UpdateCastTime()
  self.castTime = baseCastTime / PlayerState.haste
end
