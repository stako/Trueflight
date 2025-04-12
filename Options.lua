local addonName, ns = ...
local addonNameColorized = "|cffabd473"..addonName.."|r"

SLASH_TRUEFLIGHT1, SLASH_TRUEFLIGHT2 = "/trueflight", "/tf"
function SlashCmdList.TRUEFLIGHT()
  LibStub("AceConfigDialog-3.0"):Open(addonName)
end

local function buildNameFromSpell(spellId)
  local spellInfo = C_Spell.GetSpellInfo(spellId)

  -- Auto-Shot icon changes to equipped weapon. Override it
  if spellId == 75 then spellInfo.iconID = 132369 end

  return "|T"..spellInfo.iconID..":20|t "..spellInfo.name
end

local function buildNameWithIcon(iconId, name)
  return "|T"..iconId..":20|t "..name
end

ns.Options = {
  defaults = {
    profile = {
      mainBar = {
        style = "UNITFRAME",
        scale = 1.0,
        position = { "UIParent", 0, -90 }
      },
      altBar = {
        style = "UNITFRAME",
        scale = 1.0,
        position = { "UIParent", 0, -110 }
      },
      autoShot = {
        bar = "MainBar"
      },
      multiShot = {
        bar = "AltBar"
      },
      aimedShot = {
        bar = "AltBar"
      }
    }
  },

  optionsTable = {
    name = addonNameColorized,
    type = "group",
    get = function(info) return ns.db.profile[info[2]][info[3]] end,
    set = function(info, value) ns.db.profile[info[2]][info[3]] = value; ns.Options:RefreshConfig(ns.db) end,
    args = {
      bars = {
        name = "Bars",
        order = 1,
        type = "group",
        args = {
          mainBar = {
            name = buildNameWithIcon(136116, "Main Bar"),
            order = 1,
            type = "group",
            args = {
              style = {
                name = "Style",
                order = 1,
                type = "select",
                style = "radio",
                values = {
                  ["CLASSIC"] = "Classic",
                  ["UNITFRAME"] = "Unitframe"
                }
              },
              scale = {
                name = "Scale",
                order = 2,
                type = "range",
                isPercent = true,
                min = 0.1,
                max = 3.0,
                bigStep = 0.1
              }
            }
          },
          altBar = {
            name = buildNameWithIcon(237556, "Alt Bar"),
            order = 2,
            type = "group",
            args = {}
          }
        }
      },
      shots = {
        name = "Shots",
        order = 2,
        type = "group",
        args = {
          autoShot = {
            name = buildNameFromSpell(75), -- Auto Shot
            order = 1,
            type = "group",
            args = {}
          },
          multiShot = {
            name = buildNameFromSpell(2643), -- Multi-Shot
            order = 2,
            type = "group",
            args = {}
          },
          aimedShot = {
            name = buildNameFromSpell(19434), -- Aimed Shot
            order = 3,
            type = "group",
            args = {}
          }
        }
      }
    }
  },

  Init = function(self)
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(addonName, self.optionsTable)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName)
    LibStub("AceConfigDialog-3.0"):SelectGroup(addonName, "bars", "mainBar")
  end,

  InitDB = function(self)
    local db = LibStub("AceDB-3.0"):New("TrueflightDB", self.defaults, true)
    db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    self:RefreshConfig(db)
    return db
  end,

  RefreshConfig = function(self, db)
    local object = ns.MainBar
    local settings = db.profile.mainBar
    object:SetScale(settings.scale)
    object:SetStyle(settings.style)
    object:SetPoint("CENTER", unpack(settings.position))

    object = ns.AltBar
    settings = db.profile.altBar
    object:SetScale(settings.scale)
    object:SetStyle(settings.style)
    object:SetPoint("CENTER", unpack(settings.position))

    object = ns.AutoShot
    settings = db.profile.autoShot
    object.bar = ns[settings.bar]

    object = ns.MultiShot
    settings = db.profile.multiShot
    object.bar = ns[settings.bar]

    object = ns.AimedShot
    settings = db.profile.aimedShot
    object.bar = ns[settings.bar]
  end
}
