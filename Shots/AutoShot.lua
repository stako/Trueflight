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
  elseif type == "noHaste" then
    self.bar:BeginCooldown(PlayerState.baseAttackSpeed - self.baseCastTime)
  elseif type == "retry" then
    if self.bar.value >= 0.5 then return end

    self.bar:BeginCooldown(PlayerState.attackSpeed - self.castTime, 0.5)
  else
    self.bar:BeginCooldown(PlayerState.attackSpeed - self.castTime)
  end
end

function AutoShot:SetEnabled(enable)
  local bar = self.bar
  if not bar then return end

  bar:SetAlpha(enable and 1 or 0.5)
  if enable then return end

  bar.Text:SetText()
  bar:SetStatusBarColor(0.7, 0.7, 0.7)
  if not bar:GetScript("OnUpdate") then bar:SetValue(0) end
end

function AutoShot:HideBar()
  if not self.bar then return end
  if PlayerState.isAutoShotting or PlayerState.inCombat or self.bar:GetScript("OnUpdate") then return end

  self.bar:Hide()
end

AutoShot.resetSpells = {
  [5384] = true,  -- Feign Death
  [19506] = true, -- Trueshot Aura
  [8613] = true,  -- Skinning (Apprentice)
  [8617] = true,  -- Skinning (Journeyman)
  [8618] = true,  -- Skinning (Expert)
  [10768] = true, -- Skinning (Artisan)
  [32678] = true, -- Skinning (Master)
  [2575] = true,  -- Mining (Apprentice)
  [2576] = true,  -- Mining (Journeyman)
  [3564] = true,  -- Mining (Expert)
  [10248] = true, -- Mining (Artisan)
  [29354] = true, -- Mining (Master)
  [2366] = true,  -- Herb Gathering (Apprentice)
  [2368] = true,  -- Herb Gathering (Journeyman)
  [3570] = true,  -- Herb Gathering (Expert)
  [11993] = true, -- Herb Gathering (Artisan)
  [28695] = true, -- Herb Gathering (Master)
  [6478] = true   -- Opening
}
