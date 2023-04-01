-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessNoticeShowBuff = class("UINWarChessNoticeShowBuff", base)
local UINBuffDescItem = require("Game.Exploration.UI.EpBuffDesc.UINBuffDescItem")
UINWarChessNoticeShowBuff.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBuffDescItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.buffDescItem = (UINBuffDescItem.New)()
  ;
  (self.buffDescItem):Init((self.ui).epBuffDescItem)
end

UINWarChessNoticeShowBuff.InitWCNShowBuffItem = function(self, buffData)
  -- function num : 0_1 , upvalues : _ENV
  if buffData == nil then
    error("show buff not have buff data")
    return 
  end
  ;
  (self.buffDescItem):InitBuffDescItemForWCBuff(buffData)
end

return UINWarChessNoticeShowBuff

