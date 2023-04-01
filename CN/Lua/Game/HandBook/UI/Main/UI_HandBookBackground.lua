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
  -- function num : 0_3 , upvalues : _ENV
  if IsNull((self.ui).tex_Top) then
    return 
  end
  ;
  ((self.ui).tex_Top):SetIndex(index, viewLayerList[1], viewLayerList[2], viewLayerList[3], viewLayerList[4])
end

UI_HandBookBackground.ShowHBBGSetTop = function(self, flag)
  -- function num : 0_4 , upvalues : _ENV
  if IsNull((self.ui).top) then
    return 
  end
  ;
  (((self.ui).top).gameObject):SetActive(flag)
end

UI_HandBookBackground.ShowHBBGTime = function(self, flag)
  -- function num : 0_5 , upvalues : _ENV
  if IsNull((self.ui).time) then
    return 
  end
  ;
  ((self.ui).time):SetActive(flag)
  -- DECOMPILER ERROR at PC18: Unhandled construct in 'MakeBoolean' P1

  if flag and self._timerId == nil then
    self:__RefreshTime()
    self._timerId = TimerManager:StartTimer(1, function()
    -- function num : 0_5_0 , upvalues : self
    self:__RefreshTime()
  end
)
  end
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
end

UI_HandBookBackground.__RefreshTime = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local time = TimeUtil:TimestampToDate((math.floor)(PlayerDataCenter.timestamp), flag, true)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = (string.format)("%d/%02d/%02d %02d:%02d", time.year, time.month, time.day, time.hour, time.min)
end

UI_HandBookBackground.__OnClickBack = function(self)
  -- function num : 0_7
  self:Delete()
end

UI_HandBookBackground.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, base
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UI_HandBookBackground

