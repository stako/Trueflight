local addonName, ns = ...

local BarMixin = {}
ns.BarMixin = BarMixin

local function setupDrag(self, dbNodeName)
  self:SetScript("OnMouseDown", function()
    self:StartMoving()
    self.isMoving = true
  end)

  self:SetScript("OnMouseUp", function()
    self:StopMovingOrSizing()
    self.isMoving = false

    local settings = ns.db.profile[dbNodeName]
    local relativeX, relativeY = _G[settings.position[1]]:GetCenter()
    local selfX, selfY = self:GetCenter()
    local scale = self:GetScale()

    -- adjust for scale
    selfX = ((selfX * scale) - relativeX) / scale
    selfY = ((selfY * scale) - relativeY) / scale

    -- round to 1 decimal place
    selfX = floor(selfX * 10 + 0.5) / 10
    selfY = floor(selfY * 10 + 0.5) / 10

    settings.position[2], settings.position[3] = selfX, selfY
    ns.Options:RefreshConfig()
    LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
  end)

  self:EnableMouse(false)
end

function ns.NewBar(name, dbNodeName)
  local bar = CreateFrame("StatusBar", addonName..name, UIParent, "TrueflightBarTemplate")
  setupDrag(bar, dbNodeName)
  return Mixin(bar, BarMixin)
end

function BarMixin:BeginCast(duration, text)
  self.value = 0
  self.maxValue = duration
  self:SetMinMaxValues(0, duration)
  self:SetValue(self.value)
  self:SetStatusBarColor(1, 0.7, 0)
  self.Text:SetText(text)
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

BarMixin.TestTimers = {}
function BarMixin:RunImitation()
  self:BeginCast(4, self:GetName())
  self.TestTimers.InterruptTimer = C_Timer.NewTimer(3, function() self:Interrupt() end)
end

function BarMixin:StopImitation()
  for _, timer in pairs(self.TestTimers) do
    timer:Cancel()
  end
end

BarMixin.isTesting = false
function BarMixin:EnableTestMode(enable)
  self.isTesting = enable
  if self.TestTimer then self.TestTimer:Cancel() end
  self:StopImitation()
  self:SetMouseClickEnabled(false)
  self:Hide()
  if not enable then return end

  self:SetMouseClickEnabled(true)
  self:RunImitation()

  self.TestTimer = C_Timer.NewTicker(4, function() self:RunImitation() end)
end
