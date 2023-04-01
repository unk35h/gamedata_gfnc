-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMain_PNStrategyBar = class("UINWarChessMain_PNStrategyBar", base)
UINWarChessMain_PNStrategyBar.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__refreshWCStrategyExpAndLevel = BindCallback(self, self.RefreshWCStrategyExpAndLevel)
  MsgCenter:AddListener(eMsgEventId.WC_StrategyExpChange, self.__refreshWCStrategyExpAndLevel)
end

UINWarChessMain_PNStrategyBar.InitWCStrategyBar = function(self)
  -- function num : 0_1
  self:RefreshWCStrategyExpAndLevel()
end

UINWarChessMain_PNStrategyBar.RefreshWCStrategyExpAndLevel = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local curLevel = (wcCtrl.wcStragegyCtrl):GetWCStrategyLevel()
  local curExp, fullExp = (wcCtrl.wcStragegyCtrl):GetWCStrategyExp()
  ;
  ((self.ui).tex_StrategyLevel):SetIndex(0, tostring(curLevel))
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_exp).fillAmount = curExp / fullExp
  ;
  ((self.ui).tex_StrategyExp):SetIndex(0, tostring(curExp), tostring(fullExp))
end

UINWarChessMain_PNStrategyBar.OnDelete = function(self)
  -- function num : 0_3 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.WC_StrategyExpChange, self.__refreshWCStrategyExpAndLevel)
end

return UINWarChessMain_PNStrategyBar

