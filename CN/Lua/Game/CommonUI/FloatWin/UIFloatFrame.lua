-- params : ...
-- function num : 0 , upvalues : _ENV
local UIFloatFrame = class("UIFloatFrame", UIBaseWindow)
local base = UIBaseWindow
local UINFloatUINode = require("Game.CommonUI.FloatWin.UINFloatUINode")
UIFloatFrame.OnInit = function(self)
  -- function num : 0_0 , upvalues : UINFloatUINode
  self.floatFrame = (UINFloatUINode.New)()
  ;
  (self.floatFrame):Init(((self.ui).frame).gameObject)
end

UIFloatFrame.SetTitleAndContext = function(self, title, context)
  -- function num : 0_1
  (((self.ui).tex_Title).gameObject):SetActive(title ~= nil)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = title
  ;
  (((self.ui).tex_Content).gameObject):SetActive(context ~= nil)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Content).text = context
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIFloatFrame.FloatTo = function(self, transform, horizontalAlign, verticalAlign, shiftX, shiftY, customTargetCamer)
  -- function num : 0_2 , upvalues : _ENV
  (self.floatFrame):FloatTo(transform, horizontalAlign, verticalAlign, shiftX, shiftY, customTargetCamer)
  TimerManager:StartTimer(1, function()
    -- function num : 0_2_0 , upvalues : self, transform, horizontalAlign, verticalAlign, shiftX, shiftY, customTargetCamer
    (self.floatFrame):FloatTo(transform, horizontalAlign, verticalAlign, shiftX, shiftY, customTargetCamer)
  end
, nil, true, true, true)
end

UIFloatFrame.Copy3DModifier = function(self, comp_3dModifier)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).comp_3dModifier).rotation = comp_3dModifier.rotation
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).comp_3dModifier).position = comp_3dModifier.position
  ;
  ((self.ui).comp_3dModifier):RefreshGraphics()
end

UIFloatFrame.Clean3DModifier = function(self)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).comp_3dModifier).rotation = (Vector3.New)()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).comp_3dModifier).position = (Vector3.New)()
  ;
  ((self.ui).comp_3dModifier):RefreshGraphics()
end

UIFloatFrame.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UIFloatFrame

