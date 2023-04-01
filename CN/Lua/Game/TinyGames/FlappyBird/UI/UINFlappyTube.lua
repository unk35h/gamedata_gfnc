-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFlappyTube = class("UINFlappyTube", UIBaseNode)
local base = UIBaseNode
UINFlappyTube.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINFlappyTube.SetImgWithTubeType = function(self, tubeType)
  -- function num : 0_1
  ((self.ui).img):SetIndex(tubeType)
end

UINFlappyTube.SetTubeUISize = function(self, colliderBox)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tubeRect).sizeDelta = (Vector2.New)(colliderBox.right / 500, colliderBox.top / 500)
end

UINFlappyTube.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINFlappyTube

