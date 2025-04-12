local addonName, ns = ...
local addonNameColorized = "|cffabd473"..addonName.."|r"

SLASH_TRUEFLIGHT1, SLASH_TRUEFLIGHT2 = "/trueflight", "/tf"
function SlashCmdList.TRUEFLIGHT()
  LibStub("AceConfigDialog-3.0"):Open(addonName)
end

local Options = {}
ns.Options = Options

function Options:Init()
  LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(addonName, self.optionsTable)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName)
  LibStub("AceConfigDialog-3.0"):SelectGroup(addonName, "bars", "AutoShotBar")
end

function Options:InitDB()
local db = LibStub("AceDB-3.0"):New("TrueflightDB", self.defaults, true)
  db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
  db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
  db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
  self:RefreshConfig(db)
  return db
end

function Options:RefreshConfig(db)
  local object = ns.AutoShotBar
  local settings = db.profile.autoShotBar
  object:SetScale(settings.scale)
  object:SetStyle(settings.style)
  object:SetPoint("CENTER", unpack(settings.position))

  object = ns.CastBar
  settings = db.profile.castBar
  object:SetScale(settings.scale)
  object:SetStyle(settings.style)
  object:SetPoint("CENTER", unpack(settings.position))
end

Options.defaults = {
  profile = {
    autoShotBar = {
      style = "UNITFRAME",
      scale = 1.0,
      position = { "UIParent", 0, -190 }
    },
    castBar = {
      style = "CLASSIC",
      scale = 1.0,
      position = { "UIParent", 0, -215 }
    }
  }
}

local function textWithIcon(text, iconId)
  return "|T"..iconId..":0|t "..text
end

local barOptions = {
  dragNote = {
    type = "description",
    name = "Note: During test mode, the bar can be dragged using the mouse",
    fontSize = "medium",
    order = 1
  },
  position = {
    name = "Position",
    type = "group",
    order = 2,
    inline = true,
    get = function(info) return ns.db.profile[info[#info-2]][info[#info-1]][info.arg] end,
    set = function(info, value) ns.db.profile[info[#info-2]][info[#info-1]][info.arg] = value; ns.Options:RefreshConfig(ns.db) end,
    args = {
      offsetX = {
        name = "X Offset",
        type = "range",
        order = 1,
        arg = 2,
        min = -1500,
        max = 1500,
        bigStep = 1
      },
      offsetY = {
        name = "Y Offset",
        type = "range",
        order = 2,
        arg = 3,
        min = -1500,
        max = 1500,
        bigStep = 1
      },
      relativeTo = {
        name = "Relative To",
        type = "select",
        order = 3,
        arg = 1,
        style = "dropdown",
        values = {
          ["UIParent"] = "Center Screen",
          ["CastingBarFrame"] = "Blizz Cast Bar"
        }
      }
    }
  },
  style = {
    name = "Style",
    type = "select",
    order = 3,
    style = "radio",
    values = {
      ["CLASSIC"] = "Classic",
      ["UNITFRAME"] = "Unitframe"
    }
  },
  scale = {
    name = "Scale",
    type = "range",
    order = 4,
    isPercent = true,
    min = 0.1,
    max = 3.0,
    bigStep = 0.1
  }
}

Options.optionsTable = {
  name = addonNameColorized,
  type = "group",
  get = function(info) return ns.db.profile[info[#info-1]][info[#info]] end,
  set = function(info, value) ns.db.profile[info[#info-1]][info[#info]] = value; ns.Options:RefreshConfig(ns.db) end,
  args = {
    autoShotBar = {
      name = textWithIcon("Auto Shot Bar", 132369),
      type = "group",
      order = 1,
      args = barOptions
    },
    castBar = {
      name = textWithIcon("Cast Bar", 135130),
      type = "group",
      order = 2,
      args = barOptions
    }
  }
}