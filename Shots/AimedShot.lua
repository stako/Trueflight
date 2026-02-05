local _, ns = ...

local spellInfo = C_Spell.GetSpellInfo(19434)

local AimedShot = ns.NewShot(spellInfo.name)
ns.AimedShot = AimedShot

AimedShot.bar = ns.CastBar
AimedShot.baseCastTime = spellInfo.castTime / 1000 + 0.5

local pushbackAmount = 1
function AimedShot:Pushback()
  if not self.isCasting then
    return
  end

  local bar = self.bar
  local newValue = math.max(0, bar.value - pushbackAmount)
  pushbackAmount = math.max(0.2, pushbackAmount - 0.2)
  bar.value = newValue
  bar:SetValue(newValue)
end

function AimedShot:BeginCast()
  ns.ShotMixin.BeginCast(self)
  pushbackAmount = 1
end
