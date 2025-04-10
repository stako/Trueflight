local addonName, ns = ...

local PlayerState = ns.PlayerState
local oUpdateCooldown = ns.Bar.UpdateCooldown

ns.AutoShotBar = {
  New = function(self, name)
    local bar = ns.Bar:New(name)
    Mixin(bar, self)
    return bar
  end,

  UpdateCooldown = function(self, elapsed)
    oUpdateCooldown(self, elapsed)
    if self.value == 0 then
      PlayerState.weaponSwapCooldown = false
      if not PlayerState.isAutoShotting and not InCombatLockdown() then
        self:Hide()
      end
    end
  end,

  Dim = function(self)
    self:SetAlpha(0.5)
    self:SetStatusBarColor(0.7, 0.7, 0.7)
    self.Text:SetText()
  end
}
