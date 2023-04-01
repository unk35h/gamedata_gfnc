-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDamieCharaItem = class("UIDamieCharaItem", UIBaseNode)
local base = UIBaseNode
local cs_Tweening = (CS.DG).Tweening
local cs_DoTween = cs_Tweening.DOTween
UIDamieCharaItem.OnShow = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, cs_DoTween, cs_Tweening
  (base.OnShow)(self)
  if self.bornSeq ~= nil then
    (self.bornSeq):Kill()
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).localRotation = (Quaternion.Euler)(90, 0, 0)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).localPosition = Vector3.zero
  self.bornSeq = (cs_DoTween.Sequence)()
  ;
  (self.bornSeq):Append(((((self.transform):DOLocalRotate(Vector3.zero, 0.1, (cs_Tweening.RotateMode).FastBeyond360)):SetUpdate(true)):SetEase((cs_Tweening.Ease).OutQuad)):SetAutoKill(false))
end

UIDamieCharaItem.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (((self.ui).btn_HeroPic).onPressDown):AddListener(BindCallback(self, self.__OnPressItem))
  self.__recycleItem = BindCallback(self, self.__RecycleItem)
end

UIDamieCharaItem.InitWithData = function(self, id, existTime, maxPressedCount)
  -- function num : 0_2
  self.dataId = id
  self.existTime = existTime
  self.isUpdateExistTime = false
  self.scoreGetted = 0
  self.maxPressedCount = maxPressedCount or 1
end

UIDamieCharaItem.UpdateExistTime = function(self, existTime)
  -- function num : 0_3 , upvalues : _ENV
  if self.isUpdateExistTime then
    return 
  end
  self.existTime = existTime
  if self.existTimerId ~= nil then
    TimerManager:StopTimer(self.existTimerId)
    self.existTimerId = nil
  end
  self:Active()
  self.isUpdateExistTime = true
end

UIDamieCharaItem.CheckAndActiveExtraState = function(self, value)
  -- function num : 0_4
  if (self.ui).state2 ~= nil and ((self.ui).state2).activeSelf ~= value then
    ((self.ui).state2):SetActive(value)
  end
end

UIDamieCharaItem.InjectPressFunc = function(self, onPressedAction)
  -- function num : 0_5
  self.__onPressedAction = onPressedAction
end

UIDamieCharaItem.InjectRecycleItemFunc = function(self, onRecycleItem)
  -- function num : 0_6
  self.__onRecycleItem = onRecycleItem
end

UIDamieCharaItem.Active = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self.existTimerId = TimerManager:StartTimer(self.existTime, self.__recycleItem, nil, true)
end

UIDamieCharaItem.__OnPressItem = function(self)
  -- function num : 0_8 , upvalues : cs_DoTween, _ENV, cs_Tweening
  if self.__onPressedAction == nil then
    return 
  end
  local result = false
  self.maxPressedCount = self.maxPressedCount - 1
  if self.shakeSeq ~= nil then
    (self.shakeSeq):Kill()
  end
  self.shakeSeq = (cs_DoTween.Sequence)()
  ;
  (self.shakeSeq):Append(((((self.transform):DOShakePosition(0.1, (Vector3.New)(200, 0, 200), 50)):SetUpdate(true)):SetEase((cs_Tweening.Ease).OutQuad)):SetAutoKill(false))
  if self.__onPressedAction ~= nil then
    result = (self.__onPressedAction)(self.maxPressedCount)
  end
  if result then
    self.__onPressedAction = nil
    self:__RecycleItem()
  end
end

UIDamieCharaItem.UpdateScoreGetted = function(self, score)
  -- function num : 0_9
  self.scoreGetted = self.scoreGetted + score
end

UIDamieCharaItem.GetDamieCharaItemHeroId = function(self)
  -- function num : 0_10
  return (self.ui).dataId
end

UIDamieCharaItem.__RecycleItem = function(self)
  -- function num : 0_11 , upvalues : _ENV, cs_DoTween, cs_Tweening
  if self.existTimerId ~= nil then
    TimerManager:StopTimer(self.existTimerId)
    self.existTimerId = nil
  end
  if self.deadSeq ~= nil then
    (self.deadSeq):Kill()
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).localRotation = Quaternion.identity
  self.deadSeq = (cs_DoTween.Sequence)()
  ;
  (self.deadSeq):Append(((self.transform):DOLocalRotate((Vector3.New)(85, 0, 0), 0.1, (cs_Tweening.RotateMode).FastBeyond360)):SetEase((cs_Tweening.Ease).InBounce))
  ;
  (self.deadSeq):Join(((self.transform):DOLocalMoveY(-120, 0.1)):SetEase((cs_Tweening.Ease).InBounce))
  ;
  (self.deadSeq):SetAutoKill(false)
  ;
  (self.deadSeq):SetUpdate(true)
  TimerManager:StartTimer(0.2, function()
    -- function num : 0_11_0 , upvalues : self
    if self.__onRecycleItem ~= nil then
      (self.__onRecycleItem)(self.dataId)
    end
  end
, nil, true, false, true)
end

UIDamieCharaItem.__ResetData = function(self)
  -- function num : 0_12
  self:CheckAndActiveExtraState(false)
  self.dataId = nil
  self.existTime = nil
  self.maxPressedCount = nil
  self.__onPressedAction = nil
  self.__onRecycleItem = nil
  self.isUpdateExistTime = false
  self.scoreGetted = 0
end

UIDamieCharaItem.OnHide = function(self)
  -- function num : 0_13 , upvalues : base
  (base.OnHide)(self)
  self:__StopExistTimer()
  self:__ResetData()
end

UIDamieCharaItem.OnDelete = function(self)
  -- function num : 0_14 , upvalues : base
  self:__StopExistTimer()
  if self.bornSeq ~= nil then
    (self.bornSeq):Kill()
    self.bornSeq = nil
  end
  if self.shakeSeq ~= nil then
    (self.shakeSeq):Kill()
    self.shakeSeq = nil
  end
  if self.deadSeq ~= nil then
    (self.deadSeq):Kill()
    self.deadSeq = nil
  end
  ;
  (base.OnDelete)(self)
end

UIDamieCharaItem.__StopExistTimer = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if self.existTimerId ~= nil then
    TimerManager:StopTimer(self.existTimerId)
    self.existTimerId = nil
  end
end

return UIDamieCharaItem

