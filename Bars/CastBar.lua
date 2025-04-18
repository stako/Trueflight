local addonName, ns = ...

local CastBar = ns.NewBar("CastBar", "castBar")
ns.CastBar = CastBar
ns.CastBar:SetAlpha(1)

do
  local fadeTime = 0
  function CastBar:Interrupt()
    ns.BarMixin.Interrupt(self, elapsed)
    fadeTime = 0
    self:SetScript("OnUpdate", self.UpdateInterrupt)
  end

  function CastBar:UpdateInterrupt(elapsed)
    fadeTime = fadeTime + elapsed
    if fadeTime < 1 then return end

    local alpha = self:GetAlpha() - 0.05
    if alpha > 0 then
      self:SetAlpha(alpha)
    else
      self:SetScript("OnUpdate", nil)
      self:Hide()
    end
  end
end
