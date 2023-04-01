-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDormFighterInfoNode = class("UIDormFighterInfoNode", UIBaseNode)
local UIDormFighterHeadNode = require("Game.DormFight.UI.UIDormFighterHeadNode")
UIDormFighterInfoNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.headNodeList = {}
  ;
  (((self.ui).uINUserHead).gameObject):SetActive(false)
end

UIDormFighterInfoNode.InitUIDormFighterInfoNode = function(self, userName, headSpriteList)
  -- function num : 0_1 , upvalues : UIDormFighterHeadNode
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).txt_UserName).text = userName
  for i = 1, #headSpriteList do
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R7 in 'UnsetPending'

    (self.headNodeList)[i] = (UIDormFighterHeadNode.New)()
    ;
    ((self.headNodeList)[i]):Init((((self.ui).uINUserHead).gameObject):Instantiate(self.transform))
    ;
    ((self.headNodeList)[i]):InitUIDormFighterHeadNode(headSpriteList[i])
  end
end

UIDormFighterInfoNode.FighterRetired = function(self, index)
  -- function num : 0_2
  ((self.headNodeList)[index]):SetGray()
end

return UIDormFighterInfoNode

