local addonName, ns = ...

local tooltipName = addonName.."Tooltip"
local tooltip = CreateFrame("GameTooltip", tooltipName, nil, "GameTooltipTemplate")
tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

ns.PlayerState = {
  attackSpeed = 1.0,
  autoShotCastTime = 0.5,
  weaponSwapCooldown = false,
  isAutoShotting = false,
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
          self.weaponsCache[weaponId] = match
          return match
        end
      end
    end
  end,

  UpdateAttackSpeed = function(self)
    self.attackSpeed = UnitRangedDamage("player")
    local haste = self:GetBaseSpeed() / self.attackSpeed
    self.autoShotCastTime = 0.5 / haste
  end
}
