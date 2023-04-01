-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHallowmas.UI.Bouns.UINHalloweenBounsItem")
local UINChristmasBounsItem = class("UINChristmasBounsItem", base)
local cs_MessageCommon = CS.MessageCommon
UINChristmasBounsItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Unlock, self, self.OnClickAVG)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_RewardBg, self, self.OnClickGet)
end

UINChristmasBounsItem.SetLoopEftCreateFunc = function(self, func)
  -- function num : 0_1
  self._eftCreateFunc = func
end

UINChristmasBounsItem.RefreshBounsItem = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.RefreshBounsItem)(self)
  local curLevel = (self._data):GetHallowmasLv()
  local isPicked = (self._data):IsHallowmasLevelReceived(self._level)
  local isCanPick = not isPicked and self._level <= curLevel
  if isCanPick then
    if self._loopEft == nil then
      self._loopEft = (self._eftCreateFunc)()
      ;
      ((self._loopEft).transform):SetParent((self.ui).loopEftRoot)
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self._loopEft).transform).localPosition = Vector3.zero
      -- DECOMPILER ERROR at PC40: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self._loopEft).transform).localRotation = Vector3.zero
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self._loopEft).transform).localScale = Vector3.one
    end
    ;
    (self._loopEft):SetActive(true)
  elseif self._loopEft ~= nil then
    (self._loopEft):SetActive(false)
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UINChristmasBounsItem.OnClickAVG = function(self)
  -- function num : 0_3 , upvalues : cs_MessageCommon, _ENV
  (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8718))
end

return UINChristmasBounsItem

