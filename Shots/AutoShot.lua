local _, ns = ...

local spellInfo = C_Spell.GetSpellInfo(75)

local PlayerState = ns.PlayerState
local AutoShot = ns.NewShot(spellInfo.name)
ns.AutoShot = AutoShot

AutoShot.bar = ns.AutoShotBar
AutoShot.baseCastTime = 0.5
AutoShot.shotName = nil

function AutoShot:FinishCast(type)
  if not self.bar then
    return
  end

  if type == "weaponSwap" then
    self.bar:BeginCooldown(PlayerState.attackSpeed)
  elseif type == "noHaste" then
    self.bar:BeginCooldown(PlayerState.baseAttackSpeed - self.baseCastTime)
  elseif type == "retry" then
    if self.isCasting or self.bar.value >= 0.5 then
      return
    end

    self.bar:BeginCooldown(PlayerState.attackSpeed - self.castTime, 0.5)
  else
    self.bar:BeginCooldown(PlayerState.attackSpeed - self.castTime)
  end

  self.isCasting = false
end

function AutoShot:SetEnabled(enable)
  local bar = self.bar
  if not bar then
    return
  end

  bar:SetAlpha(enable and 1 or 0.5)
  if enable then
    return
  end

  bar.Text:SetText()
  bar:SetStatusBarColor(0.7, 0.7, 0.7)
  if not bar:GetScript("OnUpdate") then
    bar:SetValue(0)
  end
end

function AutoShot:HideBar()
  if not self.bar then
    return
  end
  if PlayerState.isAutoShotting or PlayerState.inCombat or self.bar:GetScript("OnUpdate") then
    return
  end

  self.bar:Hide()
end

AutoShot.resetSpells = {
  [5384] = "noHaste", -- Feign Death
  [19506] = "noHaste", -- Trueshot Aura
  [8613] = "noHaste", -- Skinning (Apprentice)
  [8617] = "noHaste", -- Skinning (Journeyman)
  [8618] = "noHaste", -- Skinning (Expert)
  [10768] = "noHaste", -- Skinning (Artisan)
  [32678] = "noHaste", -- Skinning (Master)
  [2575] = "noHaste", -- Mining (Apprentice)
  [2576] = "noHaste", -- Mining (Journeyman)
  [3564] = "noHaste", -- Mining (Expert)
  [10248] = "noHaste", -- Mining (Artisan)
  [29354] = "noHaste", -- Mining (Master)
  [2366] = "noHaste", -- Herb Gathering (Apprentice)
  [2368] = "noHaste", -- Herb Gathering (Journeyman)
  [3570] = "noHaste", -- Herb Gathering (Expert)
  [11993] = "noHaste", -- Herb Gathering (Artisan)
  [28695] = "noHaste", -- Herb Gathering (Master)
  [6478] = "noHaste", -- Opening
  [3365] = "noHaste", -- Opening
}

-- Add Aimed Shot to reset spells for BCC
if WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
  local resetSpells = AutoShot.resetSpells
  resetSpells[19434] = true
  resetSpells[20900] = true
  resetSpells[20901] = true
  resetSpells[20902] = true
  resetSpells[20903] = true
  resetSpells[20904] = true
  resetSpells[27065] = true
end
