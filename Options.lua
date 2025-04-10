local addonName, ns = ...

ns.Options = {
  defaults = {
    profile = {
      mainBar = {
        style = "UNITFRAME",
        scale = 1.0,
        position = { "UIParent", 0, -90 }
      }
    }
  },

  GetDB = function(self)
    local db = LibStub("AceDB-3.0"):New("TrueflightDB", self.defaults, true)
    db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    self:RefreshConfig(db)
    return db
  end,

  RefreshConfig = function(self, db)
    local MainBar = ns.MainBar
    local section = db.profile.mainBar
    MainBar:SetScale(section.scale)
    MainBar:SetStyle(section.style)
    MainBar:SetPoint("CENTER", unpack(section.position))
  end
}
