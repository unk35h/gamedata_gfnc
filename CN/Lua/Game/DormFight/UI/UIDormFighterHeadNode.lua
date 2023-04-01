-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDormFighterHeadNode = class("UIDormFighterHeadNode", UIBaseNode)
UIDormFighterHeadNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.headNodeList = {}
end

UIDormFighterHeadNode.InitUIDormFighterHeadNode = function(self, headSprite)
  -- function num : 0_1
  ((self.transform).gameObject):SetActive(true)
  ;
  (((self.ui).img_GrayMask).gameObject):SetActive(false)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_FighterHead).sprite = headSprite
end

UIDormFighterHeadNode.SetGray = function(self)
  -- function num : 0_2
  (((self.ui).img_GrayMask).gameObject):SetActive(true)
end

return UIDormFighterHeadNode

