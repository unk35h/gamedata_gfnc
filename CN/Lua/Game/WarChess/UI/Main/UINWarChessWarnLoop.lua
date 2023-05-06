-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessWarnLoop = class("UINWarChessWarnLoop", UIBaseNode)
local base = UIBaseNode
local cs_DoTween = ((CS.DG).Tweening).DOTween
UINWarChessWarnLoop.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__TeamChangeCallback = BindCallback(self, self.__TeamChange)
  MsgCenter:AddListener(eMsgEventId.WC_SelectTeam, self.__TeamChangeCallback)
  self.__TurnChangeCallback = BindCallback(self, self.__TurnChange)
  MsgCenter:AddListener(eMsgEventId.WC_TurnStart, self.__TurnChangeCallback)
  self.__HeroDynUpdateCallback = BindCallback(self, self.__HeroDynUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_HeroDynUpdate, self.__HeroDynUpdateCallback)
end

UINWarChessWarnLoop.__TeamChange = function(self, teamData)
  -- function num : 0_1 , upvalues : _ENV
  if teamData == self._teamData then
    return 
  end
  if teamData == nil then
    self:__ResetWarnState()
    self._teamData = nil
    return 
  end
  self._teamData = teamData
  self:__ResetWarnState()
  if teamData:GetWCTeamHP() <= (ConfigData.game_config).wcWarnHoPer / 100 then
    self:__PingPongFadeEffectPlay(false, -1, 0, 1, 0, 0.6)
  end
end

UINWarChessWarnLoop.__HeroDynUpdate = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self._teamData == nil then
    return 
  end
  self:__ResetWarnState()
  if (self._teamData):GetWCTeamHP() <= (ConfigData.game_config).wcWarnHoPer / 100 then
    self:__PingPongFadeEffectPlay(false, -1, 0, 1, 0, 0.6)
  end
end

UINWarChessWarnLoop.__PingPongFadeEffectPlay = function(self, flip, totalCount, curCount, time, minScale, maxScale)
  -- function num : 0_3
  if totalCount ~= -1 and curCount == totalCount then
    return 
  end
  if not minScale then
    minScale = 0
  end
  if not maxScale then
    maxScale = 1
  end
  if not flip then
    (((self.ui).img_turnWarrning):DOFade(maxScale, time)):OnComplete(function()
    -- function num : 0_3_0 , upvalues : self, flip, totalCount, curCount, time, minScale, maxScale
    self:__PingPongFadeEffectPlay(not flip, totalCount, curCount, time, minScale, maxScale)
  end
)
  else
    ;
    (((self.ui).img_turnWarrning):DOFade(minScale, time)):OnComplete(function()
    -- function num : 0_3_1 , upvalues : self, flip, totalCount, curCount, time, minScale, maxScale
    self:__PingPongFadeEffectPlay(not flip, totalCount, curCount + 1, time, minScale, maxScale)
  end
)
  end
end

UINWarChessWarnLoop.__TurnChange = function(self, num)
  -- function num : 0_4 , upvalues : _ENV
  local warningNumber = (WarChessManager.wcLevelCfg).warning
  if warningNumber or 0 > 0 and warningNumber - num <= 0 then
    self:__ResetWarnState()
    self:__PingPongFadeEffectPlay(false, 2, 0, 0.5)
    ;
    ((((self.ui).img_turnWarrning).transform):DOPunchScale((Vector3.New)(0.5, 0.5, 0), 0.5, 1, 0)):SetLoops(2)
  end
end

UINWarChessWarnLoop.__ResetWarnState = function(self)
  -- function num : 0_5
  ((self.ui).img_turnWarrning):DOKill()
  ;
  (((self.ui).img_turnWarrning).transform):DOKill()
  local color = ((self.ui).img_turnWarrning).color
  color.a = 0
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_turnWarrning).color = color
end

UINWarChessWarnLoop.OnDelete = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.WC_SelectTeam, self.__TeamChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.WC_TurnStart, self.__TurnChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.WC_HeroDynUpdate, self.__HeroDynUpdateCallback)
  ;
  (base.OnDelete)(self)
end

return UINWarChessWarnLoop

