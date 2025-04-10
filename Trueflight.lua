if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then return end
if select(2, UnitClass("player")) ~= "HUNTER" then return end

local addonName, ns = ...
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local guid = UnitGUID("player")

ns.MainBar = ns.AutoShotBar:New("MainBar")

local PlayerState = ns.PlayerState
local MainBar = ns.MainBar
local Options = ns.Options

PlayerState:UpdateAttackSpeed()

local EventHandler = CreateFrame("Frame")
EventHandler:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

EventHandler:RegisterEvent("ADDON_LOADED")
EventHandler:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EventHandler:RegisterEvent("START_AUTOREPEAT_SPELL")
EventHandler:RegisterEvent("STOP_AUTOREPEAT_SPELL")
EventHandler:RegisterEvent("PLAYER_REGEN_ENABLED")
EventHandler:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
EventHandler:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
EventHandler:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
EventHandler:RegisterUnitEvent("UNIT_SPELLCAST_FAILED_QUIET", "player")

function EventHandler:ADDON_LOADED(name)
  if name ~= addonName then return end

  ns.db = Options:GetDB()
end

function EventHandler:COMBAT_LOG_EVENT_UNFILTERED()
  local _, subevent, _, sourceGUID, _, _, _, _, _, _, _, spellId  = CombatLogGetCurrentEventInfo()
  if spellId ~= 75 or sourceGUID ~= guid then return end

  if subevent == "SPELL_CAST_START" then
    PlayerState.weaponSwapCooldown = false
    PlayerState:UpdateAttackSpeed()
    MainBar:StartCast(PlayerState.autoShotCastTime)
  end
end

function EventHandler:START_AUTOREPEAT_SPELL()
  PlayerState.isAutoShotting = true
  MainBar:SetAlpha(1)
end

function EventHandler:STOP_AUTOREPEAT_SPELL()
  PlayerState.isAutoShotting = false
  MainBar:SetAlpha(0.5)
  MainBar:SetStatusBarColor(0.7, 0.7, 0.7)

  if InCombatLockdown() then return end

  MainBar:Hide()
end

function EventHandler:PLAYER_REGEN_ENABLED()
  MainBar:Hide()
end

function EventHandler:PLAYER_EQUIPMENT_CHANGED(equipmentSlot)
  if equipmentSlot ~= INVSLOT_RANGED then return end

  PlayerState:UpdateAttackSpeed()
  PlayerState.weaponSwapCooldown = true
  MainBar:StartCooldown(PlayerState.attackSpeed)
end

function EventHandler:UNIT_SPELLCAST_SUCCEEDED(unit, castGUID, spellId)
  if spellId ~= 75 then return end

  MainBar:StartCooldown(PlayerState.attackSpeed - PlayerState.autoShotCastTime)
end

function EventHandler:UNIT_SPELLCAST_INTERRUPTED(unit, castGUID, spellId)
  if spellId ~= 75 then return end

  MainBar:Interrupt()
end

function EventHandler:UNIT_SPELLCAST_FAILED_QUIET(unit, castGUID, spellId)
  if spellId ~= 75 or PlayerState.weaponSwapCooldown then return end

  MainBar:StartCooldown(PlayerState.attackSpeed - PlayerState.autoShotCastTime, 0.5)
end
