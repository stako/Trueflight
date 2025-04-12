local addonName, ns = ...

local AutoShotBar = ns.NewBar("AutoShotBar")
ns.AutoShotBar = AutoShotBar

function AutoShotBar:BeginCooldown(duration, initTime)
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
end

function AutoShotBar:UpdateCooldown(elapsed)
  self.value = self.value - elapsed
  if self.value <= 0 then
    self:SetScript("OnUpdate", nil)
    self:SetValue(0)
    self.value = 0
    self.Spark:Hide()
    ns.AutoShot:HideBar()
    return
  end

  self:SetValue(self.value)
  self.Spark:SetPoint("CENTER", self, "LEFT", (self.value / self.maxValue) * self:GetWidth(), self.Spark.offsetY)
end
