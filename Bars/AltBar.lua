local addonName, ns = ...

local AltBar = ns.NewBar("AltBar")
ns.AltBar = AltBar
ns.AltBar:SetAlpha(1)

do
  local fadeTime = 0
  local oInterrupt = AltBar.Interrupt
  function AltBar:Interrupt()
    oInterrupt(self, elapsed)
    fadeTime = 0
    self:SetScript("OnUpdate", self.UpdateInterrupt)
  end

  function AltBar:UpdateInterrupt(elapsed)
    fadeTime = fadeTime + elapsed
    if fadeTime < 1 then return end

    local alpha = self:GetAlpha() - 0.05
    if alpha >= 0 then
      self:SetAlpha(alpha)
    else
      self:SetScript("OnUpdate", nil)
      self:Hide()
    end
  end
end
