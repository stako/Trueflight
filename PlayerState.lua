local addonName, ns = ...
ns.validEnvironment = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and select(2, UnitClass("player")) == "HUNTER"
if not ns.validEnvironment then return end

local tooltipName = addonName.."Tooltip"
local tooltip = CreateFrame("GameTooltip", tooltipName, nil, "GameTooltipTemplate")
tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

ns.PlayerState = {
  attackSpeed = 3.0,
  baseAttackSpeed = 3.0,
  haste = 1.0,
  isAutoShotting = false,
  inCombat = false,
  weaponsCache = {},

  GetBaseSpeed = function(self)
    local weaponId = GetInventoryItemID("player", INVSLOT_RANGED)
    if not weaponId then return 1 end

    if self.weaponsCache[weaponId] then return self.weaponsCache[weaponId] end

    local fontStringBase = tooltipName.."TextRight"
    local pattern = SPEED .. " (%d[%.,]%d%d)"

    tooltip:ClearLines()
    tooltip:SetItemByID(weaponId)
    for i = 1, tooltip:NumLines() do
      local text = _G[fontStringBase..i]:GetText()
      if text then
        local match = text:match(pattern)
        if match then
          match = match:gsub(",", ".")
          self.weaponsCache[weaponId] = match
          return match
        end
      end
    end
  end,

  UpdateAttackSpeed = function(self)
    self.attackSpeed = UnitRangedDamage("player")
    self.baseAttackSpeed = self:GetBaseSpeed()
    self.haste = self.baseAttackSpeed / self.attackSpeed
  end
}
