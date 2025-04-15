local addonName, ns = ...

local spellInfo = C_Spell.GetSpellInfo(75)

local PlayerState = ns.PlayerState
local AutoShot = ns.NewShot(spellInfo.name)
ns.AutoShot = AutoShot

AutoShot.bar = ns.AutoShotBar
AutoShot.baseCastTime = 0.5
AutoShot.shotName = nil

function AutoShot:FinishCast(type)
  if not self.bar then return end

  if type == "weaponSwap" then
    self.bar:BeginCooldown(PlayerState.attackSpeed)
  elseif type == "retry" then
    if self.bar.value >= 0.5 then return end

    self.bar:BeginCooldown(PlayerState.attackSpeed - self.castTime, 0.5)
  else
    self.bar:BeginCooldown(PlayerState.attackSpeed - self.castTime)
  end
end

function AutoShot:SetEnabled(enable)
  if not self.bar then return end

  self.bar:SetAlpha(enable and 1 or 0.5)
  if enable then return end

  self.bar.Text:SetText()
  self.bar:SetStatusBarColor(0.7, 0.7, 0.7)
end

function AutoShot:HideBar()
  if not self.bar then return end
  if PlayerState.isAutoShotting or PlayerState.inCombat or self.bar:GetScript("OnUpdate") then return end

  self.bar:Hide()
end
