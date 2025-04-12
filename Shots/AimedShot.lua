local addonName, ns = ...

local PlayerState = ns.PlayerState
local AimedShot = ns.NewShot()
ns.AimedShot = AimedShot

-- Grab base cast time dynamically as it changes between Vanilla & TBC
local baseCastTime = (select(4, GetSpellInfo(19434)) / 1000) + 0.5

function AimedShot:UpdateCastTime()
  self.castTime = baseCastTime / PlayerState.haste
end
