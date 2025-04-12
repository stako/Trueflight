local addonName, ns = ...

local BarMixin = {}
ns.BarMixin = BarMixin

function ns.NewBar(name)
  local bar = CreateFrame("StatusBar", addonName..name, UIParent, "TrueflightBarTemplate")
  return Mixin(bar, BarMixin)
end

function BarMixin:BeginCast(duration)
  self.value = 0
  self.maxValue = duration
  self:SetMinMaxValues(0, duration)
  self:SetValue(self.value)
  self:SetStatusBarColor(1, 0.7, 0)
  self.Text:SetText()
  self.Spark:SetPoint("CENTER", self, "LEFT", 0, self.Spark.offsetY)
  self.Spark:Show()
  self:SetAlpha(1)
  self:Show()
  self:SetScript("OnUpdate", self.UpdateCast)
end

function BarMixin:UpdateCast(elapsed)
  self.value = self.value + elapsed
  if self.value >= self.maxValue then
    self:SetScript("OnUpdate", nil)
    self:SetValue(self.value)
    self.value = self.maxValue
    self.Spark:Hide()
    return
  end

  self:SetValue(self.value)
  self.Spark:SetPoint("CENTER", self, "LEFT", (self.value / self.maxValue) * self:GetWidth(), self.Spark.offsetY)
end

function BarMixin:Interrupt()
  self:SetScript("OnUpdate", nil)
  self:SetValue(self.maxValue)
  self:SetStatusBarColor(1, 0, 0)
  self.Spark:Hide()
  self.Text:SetText(INTERRUPTED)
end

function BarMixin:SetStyle(style)
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
