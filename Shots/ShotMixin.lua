local addonName, ns = ...

local PlayerState = ns.PlayerState

local ShotMixin = {}
ns.ShotMixin = ShotMixin

ShotMixin.castTime = 0.5

function ns.NewShot(shotName)
  return Mixin({shotName = shotName}, ShotMixin)
end

function ShotMixin:UpdateCastTime()
  self.castTime = 0.5 / PlayerState.haste
end

function ShotMixin:BeginCast()
  if not self.bar then return end

  self.bar:BeginCast(self.castTime, self.shotName)
end

function ShotMixin:FinishCast()
  if not self.bar then return end

  self.bar:Hide()
end

function ShotMixin:Interrupt()
  if not self.bar then return end

  self.bar:Interrupt()
end

