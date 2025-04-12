local addonName, ns = ...

local spellInfo = C_Spell.GetSpellInfo(75)

local PlayerState = ns.PlayerState
local AutoShot = ns.NewShot(spellInfo.name)
ns.AutoShot = AutoShot

function AutoShot:FinishCast(type)
  if not self.bar then return end

  if type == "weaponSwap" then
    self.bar:BeginCooldown(PlayerState.attackSpeed)
    PlayerState.weaponSwapCooldown = true
    if PlayerState.WeaponSwapTimer then PlayerState.WeaponSwapTimer:Cancel() end
    PlayerState.WeaponSwapTimer = C_Timer.NewTimer(PlayerState.attackSpeed, function()
      PlayerState.weaponSwapCooldown = false
      self:HideBar()
    end)
  elseif type == "retry" then
    if PlayerState.weaponSwapCooldown then return end

    self.bar:BeginCooldown(PlayerState.attackSpeed - self.castTime, 0.5)
  else
    self.bar:BeginCooldown(PlayerState.attackSpeed - self.castTime)
  end
end

function AutoShot:StartRetry()
  if not self.bar then return end

  self.bar:StartCooldown(PlayerState.attackSpeed - PlayerState.autoShotCastTime, 0.5)
end

function AutoShot:SetEnabled(enable)
  if not self.bar then return end

  self.bar:SetAlpha(enable and 1 or 0.5)
end

function AutoShot:HideBar()
  if not self.bar then return end
  if PlayerState.isAutoShotting or PlayerState.inCombat or self.bar:GetScript("OnUpdate") then return end

  self.bar:Hide()
end
