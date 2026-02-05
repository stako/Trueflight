local addonName, ns = ...
if not ns.validEnvironment then
  return
end
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local guid = UnitGUID("player")
local firstCast = true

local PlayerState = ns.PlayerState
local Options = ns.Options
local AutoShot = ns.AutoShot
local MultiShot = ns.MultiShot
local AimedShot = ns.AimedShot

local shotLookup = {
  [75] = AutoShot,

  [2643] = MultiShot,
  [14288] = MultiShot,
  [14289] = MultiShot,
  [14290] = MultiShot,
  [25294] = MultiShot,
  [27021] = MultiShot,

  [19434] = AimedShot,
  [20900] = AimedShot,
  [20901] = AimedShot,
  [20902] = AimedShot,
  [20903] = AimedShot,
  [20904] = AimedShot,
  [27065] = AimedShot,
}

-- Remove Aimed Shot from Trueflight Castbar in BCC
if WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
  shotLookup[19434] = nil
  shotLookup[20900] = nil
  shotLookup[20901] = nil
  shotLookup[20902] = nil
  shotLookup[20903] = nil
  shotLookup[20904] = nil
  shotLookup[27065] = nil
end

local pushbackEvents = {
  SWING_DAMAGE = true,
  ENVIRONMENTAL_DAMAGE = true,
  RANGE_DAMAGE = true,
  SPELL_DAMAGE = true,
}

Options:Init()

local EventHandler = CreateFrame("Frame")
EventHandler:SetScript("OnEvent", function(self, event, ...)
  self[event](self, ...)
end)

EventHandler:RegisterEvent("ADDON_LOADED")
EventHandler:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
EventHandler:RegisterEvent("MIRROR_TIMER_STOP")
EventHandler:RegisterEvent("START_AUTOREPEAT_SPELL")
EventHandler:RegisterEvent("STOP_AUTOREPEAT_SPELL")
EventHandler:RegisterEvent("PLAYER_REGEN_ENABLED")
EventHandler:RegisterEvent("PLAYER_REGEN_DISABLED")
EventHandler:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
EventHandler:RegisterUnitEvent("UNIT_RANGEDDAMAGE", "player")
EventHandler:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
EventHandler:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
EventHandler:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
EventHandler:RegisterUnitEvent("UNIT_SPELLCAST_FAILED_QUIET", "player")

function EventHandler:ADDON_LOADED(name)
  if name ~= addonName then
    return
  end

  ns.db = Options:InitDB()
end

function EventHandler:COMBAT_LOG_EVENT_UNFILTERED()
  local _, subevent, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = CombatLogGetCurrentEventInfo()
  if subevent == "SPELL_CAST_START" and sourceGUID == guid then
    local shot = shotLookup[spellId]
    if not shot then
      return
    end

    if firstCast then
      firstCast = false
      self:UNIT_RANGEDDAMAGE()
    end
    shot:BeginCast()
  elseif pushbackEvents[subevent] and targetGUID == guid then
    AimedShot:Pushback()
  end
end

function EventHandler:MIRROR_TIMER_STOP(timerName)
  if timerName ~= "FEIGNDEATH" then
    return
  end

  if firstCast then
    firstCast = false
    self:UNIT_RANGEDDAMAGE()
  end
  AutoShot:FinishCast("noHaste")
end

function EventHandler:START_AUTOREPEAT_SPELL()
  PlayerState.isAutoShotting = true
  AutoShot:SetEnabled(true)
end

function EventHandler:STOP_AUTOREPEAT_SPELL()
  PlayerState.isAutoShotting = false
  AutoShot:SetEnabled(false)
  AutoShot:HideBar()
end

function EventHandler:PLAYER_REGEN_ENABLED()
  PlayerState.inCombat = false
  AutoShot:HideBar()
end

function EventHandler:PLAYER_REGEN_DISABLED()
  PlayerState.inCombat = true
end

function EventHandler:PLAYER_EQUIPMENT_CHANGED(equipmentSlot)
  if equipmentSlot ~= INVSLOT_RANGED then
    return
  end

  AutoShot:FinishCast("weaponSwap")
end

function EventHandler:UNIT_RANGEDDAMAGE()
  PlayerState:UpdateAttackSpeed()
  AutoShot:UpdateCastTime()
  MultiShot:UpdateCastTime()
  AimedShot:UpdateCastTime()
end

function EventHandler:UNIT_SPELLCAST_SUCCEEDED(_, _, spellId)
  local shot = shotLookup[spellId]
  local resetType
  if not shot then
    resetType = AutoShot.resetSpells[spellId]
    if resetType then
      shot = AutoShot
    else
      return
    end
  end

  if firstCast then
    firstCast = false
    self:UNIT_RANGEDDAMAGE()
  end

  shot:FinishCast(resetType)
end

function EventHandler:UNIT_SPELLCAST_FAILED(_, _, spellId)
  local shot = shotLookup[spellId]
  if not shot then
    return
  end

  if shot == AutoShot then
    self:STOP_AUTOREPEAT_SPELL()
  end
  shot:Interrupt()
end

function EventHandler:UNIT_SPELLCAST_INTERRUPTED(_, _, spellId)
  local shot = shotLookup[spellId]
  if not shot then
    return
  end

  shot:Interrupt()
end

function EventHandler:UNIT_SPELLCAST_FAILED_QUIET(_, _, spellId)
  if spellId ~= 75 then
    return
  end

  if firstCast then
    firstCast = false
    self:UNIT_RANGEDDAMAGE()
  end
  AutoShot:FinishCast("retry")
end
