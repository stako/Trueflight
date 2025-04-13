local addonName, ns = ...

local AutoShotBar = ns.NewBar("AutoShotBar", "autoShotBar")
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

AutoShotBar.TestTimers = {}
function AutoShotBar:RunImitation()
  self:BeginCast(0.5, self:GetName())
  self.TestTimers.CooldownTimer = C_Timer.NewTimer(0.5, function() self:BeginCooldown(2.2) end)
  self.TestTimers.CastTimer = C_Timer.NewTimer(2.7, function() self:BeginCast(0.5, self:GetName()) end)
  self.TestTimers.InterruptTimer = C_Timer.NewTimer(3.1, function() self:Interrupt() end)
end
