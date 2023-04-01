-- params : ...
-- function num : 0 , upvalues : _ENV
local UI_HandBookBackground = class("UI_HandBookBackground", UIBaseWindow)
local base = UIBaseWindow
UI_HandBookBackground.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.handBookCtrl = ControllerManager:GetController(ControllerTypeId.HandBook, true)
end

UI_HandBookBackground.HBBGPalyerEnterTween = function(self)
  -- function num : 0_1
  self:__PlayDoTweenAnimation("bg_fromBlack")
  self:__PlayDoTweenAnimation("bg_grigUp")
end

UI_HandBookBackground.__PlayDoTweenAnimation = function(self, id)
  -- function num : 0_2
  ((self.ui).DoTweenAnimation):DORestartAllById(id)
end

UI_HandBookBackground.HBBGSetTop = function(self, index, viewLayerList)
  -- function num : 0_3
  if (self.ui).tex_Top == nil then
    return 
  end
  ;
  ((self.ui).tex_Top):SetIndex(index, viewLayerList[1], viewLayerList[2], viewLayerList[3])
end

UI_HandBookBackground.__OnClickBack = function(self)
  -- function num : 0_4
  self:Delete()
end

UI_HandBookBackground.OnDelete = function(self)
  -- function num : 0_5
end

return UI_HandBookBackground

