local addonName, ns = ...

ns.Bar = {
  New = function(self, name)
    local bar = CreateFrame("StatusBar", addonName..name, UIParent, "TrueflightBarTemplate")
    Mixin(bar, self)
    return bar
  end,

  StartCast = function(self, duration)
    self.value = 0
    self.maxValue = duration
    self:SetMinMaxValues(0, duration)
    self:SetValue(self.value)
    self:SetStatusBarColor(1, 0.7, 0)
    self.Text:SetText()
    self.Spark:SetPoint("CENTER", self, "LEFT", 0, self.Spark.offsetY)
    self.Spark:Show()
    self:Show()
    self:SetScript("OnUpdate", self.UpdateCast)
  end,

  UpdateCast = function(self, elapsed)
    self.value = self.value + elapsed
    if self.value >= self.maxValue then
      self:FinishCast()
      return
    end

    self:SetValue(self.value)

    local sparkPosition = (self.value / self.maxValue) * self:GetWidth()
    self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, self.Spark.offsetY)
  end,

  FinishCast = function(self)
    self:SetScript("OnUpdate", nil)
    self:SetValue(self.maxValue)
    self.value = self.maxValue
    self.Spark:Hide()
  end,

  StartCooldown = function(self, duration, initTime)
    self.value = initTime or duration
    self.maxValue = duration
    self:SetMinMaxValues(0, duration)
    self:SetValue(self.value)
    self:SetStatusBarColor(0.7, 0.7, 0.7)
    self.Text:SetText()
    self.Spark:SetPoint("CENTER", self, "RIGHT")
    self.Spark:Show()
    self:Show()
    self:SetScript("OnUpdate", self.UpdateCooldown)
  end,

  UpdateCooldown = function(self, elapsed)
    self.value = self.value - elapsed
    if self.value <= 0 then
      self:FinishCooldown()
      return
    end

    self:SetValue(self.value)

    local sparkPosition = (self.value / self.maxValue) * self:GetWidth()
    self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, self.Spark.offsetY)
  end,

  FinishCooldown = function(self)
    self:SetScript("OnUpdate", nil)
    self:SetValue(0)
    self.value = 0
    self.Spark:Hide()
  end,

  Interrupt = function(self)
    self:SetScript("OnUpdate", nil)
    self:SetValue(self.maxValue)
    self:SetStatusBarColor(1, 0, 0)
    self.Spark:Hide()
    self.Text:SetText(INTERRUPTED)
  end,

  SetStyle = function(self, style)
    if style == "CLASSIC" then
      self:SetWidth(195)
      self:SetHeight(13)
      -- border
      self.Border:ClearAllPoints()
      self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border")
      self.Border:SetWidth(256)
      self.Border:SetHeight(64)
      self.Border:SetPoint("TOP", 0, 28)
      -- text
      self.Text:ClearAllPoints()
      self.Text:SetWidth(185)
      self.Text:SetHeight(16)
      self.Text:SetPoint("TOP", 0, 5)
      self.Text:SetFontObject("GameFontHighlight")
      -- bar spark
      self.Spark.offsetY = 2
    elseif style == "UNITFRAME" then
      self:SetWidth(150)
      self:SetHeight(10)
      -- border
      self.Border:ClearAllPoints()
      self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
      self.Border:SetWidth(0)
      self.Border:SetHeight(49)
      self.Border:SetPoint("TOPLEFT", -23, 20)
      self.Border:SetPoint("TOPRIGHT", 23, 20)
      -- text
      self.Text:ClearAllPoints()
      self.Text:SetWidth(0)
      self.Text:SetHeight(16)
      self.Text:SetPoint("TOPLEFT", 0, 4)
      self.Text:SetPoint("TOPRIGHT", 0, 4)
      self.Text:SetFontObject("SystemFont_Shadow_Small")
      -- bar spark
      self.Spark.offsetY = 0
    end
  end
}
