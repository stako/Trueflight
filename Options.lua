local addonName, ns = ...
if not ns.validEnvironment then
  return
end
local addonNameColorized = "|cffabd473" .. addonName .. "|r"
local ACD = LibStub("AceConfigDialog-3.0")

SLASH_TRUEFLIGHT1, SLASH_TRUEFLIGHT2 = "/trueflight", "/tf"
function SlashCmdList.TRUEFLIGHT(msg)
  if msg == "test" then
    ns.AutoShotBar:EnableTestMode(not ns.AutoShotBar.isTesting)
    ns.CastBar:EnableTestMode(not ns.CastBar.isTesting)
  elseif msg == "hide" then
    ns.AutoShotBar:EnableTestMode(false)
    ns.CastBar:EnableTestMode(false)
  elseif ACD.OpenFrames[addonName] then
    ACD:Close(addonName)
  else
    ACD:Open(addonName)
  end
end

local function textWithIcon(text, iconId)
  return "|T" .. iconId .. ":0|t " .. text
end

local Options = {}
ns.Options = Options

function Options:Init()
  LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(addonName, self.optionsTable)
  ACD:AddToBlizOptions(addonName)
  ACD:SelectGroup(addonName, "bars", "AutoShotBar")
end

function Options:InitDB()
  self.db = LibStub("AceDB-3.0"):New("TrueflightDB", self.defaults, true)
  self.optionsTable.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
  local profiles = self.optionsTable.args.profiles
  profiles.name = textWithIcon(profiles.name, 442272)
  self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
  self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
  self:RefreshConfig()
  return self.db
end

do
  local bars = {
    AutoShotBar = "autoShotBar",
    CastBar = "castBar",
  }

  function Options:RefreshConfig()
    for barName, dbNodeName in pairs(bars) do
      local bar = ns[barName]
      local settings = self.db.profile[dbNodeName]
      bar:SetScale(settings.scale)
      bar:SetStyle(settings.style)
      bar:ClearAllPoints()
      if not _G[settings.position[1]] then
        settings.position[1] = "UIParent"
      end
      bar:SetPoint("CENTER", unpack(settings.position))
      if dbNodeName == "autoShotBar" then
        bar.ClipIndicator:SetAlpha(settings.clipIndicator and 1 or 0)
      end
    end
  end
end

anchorPoints = {
  ["UIParent"] = "Center Screen",
  ["CastingBarFrame"] = "Blizz Cast Bar",
}
if WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
  anchorPoints["CastingBarFrame"] = nil
end

Options.defaults = {
  profile = {
    autoShotBar = {
      style = "UNITFRAME",
      scale = 1.0,
      position = { "UIParent", 0, -190 },
      clipIndicator = true,
    },
    castBar = {
      style = "CLASSIC",
      scale = 1.0,
      position = { "UIParent", 0, -215 },
    },
  },
}

local barOptions = {
  position = {
    name = "Position",
    type = "group",
    order = 1,
    inline = true,
    get = function(info)
      return ns.db.profile[info[#info - 2]][info[#info - 1]][info.arg]
    end,
    set = function(info, value)
      ns.db.profile[info[#info - 2]][info[#info - 1]][info.arg] = value
      ns.Options:RefreshConfig()
    end,
    args = {
      offsetX = {
        name = "X Offset",
        type = "range",
        order = 1,
        arg = 2,
        min = -1500,
        max = 1500,
        step = 0.1,
        bigStep = 1,
      },
      offsetY = {
        name = "Y Offset",
        type = "range",
        order = 2,
        arg = 3,
        min = -1500,
        max = 1500,
        step = 0.1,
        bigStep = 1,
      },
      relativeTo = {
        name = "Relative To",
        type = "select",
        order = 3,
        arg = 1,
        style = "dropdown",
        values = anchorPoints,
      },
    },
  },
  style = {
    name = "Style",
    type = "select",
    order = 2,
    style = "radio",
    values = {
      ["CLASSIC"] = "Classic",
      ["UNITFRAME"] = "Unitframe",
    },
  },
  scale = {
    name = "Scale",
    type = "range",
    order = 4,
    isPercent = true,
    min = 0.1,
    max = 3.0,
    bigStep = 0.1,
  },
}

local autoShotBarOptions = {}
for k, v in pairs(barOptions) do
  autoShotBarOptions[k] = v
end

autoShotBarOptions.clipIndicator = {
  name = "Multi-Shot Clip Indicator",
  desc = "Shows a shaded area that, if Multi-Shot were used in it, would delay your next Auto Shot",
  type = "toggle",
  width = "full",
  order = 3,
}

Options.optionsTable = {
  name = addonNameColorized,
  type = "group",
  get = function(info)
    return ns.db.profile[info[#info - 1]][info[#info]]
  end,
  set = function(info, value)
    ns.db.profile[info[#info - 1]][info[#info]] = value
    ns.Options:RefreshConfig()
  end,
  args = {
    testMode = {
      name = "Toggle Test Mode",
      type = "execute",
      order = 1,
      func = function()
        ns.AutoShotBar:EnableTestMode(not ns.AutoShotBar.isTesting)
        ns.CastBar:EnableTestMode(not ns.CastBar.isTesting)
      end,
    },
    dragNote = {
      name = "  Note: During test mode, the bars can be dragged using the mouse",
      type = "description",
      order = 2,
      width = 2.5,
      fontSize = "medium",
    },
    autoShotBar = {
      name = textWithIcon("Auto Shot Bar", 132369),
      type = "group",
      order = 3,
      args = autoShotBarOptions,
    },
    castBar = {
      name = textWithIcon("Cast Bar", 135130),
      type = "group",
      order = 4,
      args = barOptions,
    },
  },
}
