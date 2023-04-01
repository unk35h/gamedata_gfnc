-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Home.UI.UINHomeGeneralBtn")
local UINHomeLotteryBtn = class("UINHomeLotteryBtn", base)
UINHomeLotteryBtn.InitHomeLotteryBtn = function(self)
  -- function num : 0_0 , upvalues : _ENV
  local ok, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.LotteryPr)
  if ok then
    self:_UpdRedDot(node)
  end
  self.__UpdRedDotFunc = BindCallback(self, self._UpdRedDot)
  RedDotController:AddListener(RedDotStaticTypeId.LotteryPr, self.__UpdRedDotFunc)
end

UINHomeLotteryBtn._UpdRedDot = function(self, node)
  -- function num : 0_1
  ((self.ui).obj_LtrTenPrior):SetActive(node:GetRedDotCount() > 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINHomeLotteryBtn.OnDelete = function(self)
  -- function num : 0_2 , upvalues : _ENV, base
  RedDotController:RemoveListener(RedDotStaticTypeId.LotteryPr, self.__UpdRedDotFunc)
  ;
  (base.OnDelete)(self)
end

return UINHomeLotteryBtn

