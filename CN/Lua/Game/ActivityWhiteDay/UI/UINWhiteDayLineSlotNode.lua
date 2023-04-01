-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayLineSlotNode = class("UINWhiteDayLineSlotNode", UIBaseNode)
local base = UIBaseNode
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local ActivityWhiteDayEnum = require("Game.ActivityWhiteDay.ActivityWhiteDayEnum")
UINWhiteDayLineSlotNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.loop1Effect = nil
  self.loop2Effect = nil
  self.picEffect = nil
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_slot, self, self.OnAWDClickSlot)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_speedUpNode, self, self.OnAWDClickAcc)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Event, self, self.OnAWDClickEvent)
end

UINWhiteDayLineSlotNode.InitWhiteDayLineSlot = function(self, AWDCtrl, AWDLineData, resloader)
  -- function num : 0_1
  self.AWDCtrl = AWDCtrl
  self.AWDLineData = AWDLineData
  self.resloader = resloader
  self:RefreshAWDLineSlot()
end

UINWhiteDayLineSlotNode.RefreshAWDLineSlot = function(self)
  -- function num : 0_2 , upvalues : ActivityWhiteDayEnum, _ENV
  local isUnlcok = (self.AWDLineData):GetIsWDLUnlock()
  local isInProduction = (self.AWDLineData):GetIsInProduction()
  local isHaveEvent = (self.AWDLineData):GetIsHaveEvent()
  local isComplete = (self.AWDLineData):GetIsProductionOver()
  ;
  ((self.ui).obj_frame):SetActive(not isComplete)
  if isUnlcok then
    ((self.ui).obj_tex_Start):SetActive(not isInProduction)
    ;
    ((self.ui).obj_condition):SetActive(not isUnlcok)
    ;
    ((self.ui).obj_timeAndAcc):SetActive(isInProduction)
    ;
    ((self.ui).obj_count):SetActive(false)
    self:__RefreshWDEventTween()
    ;
    (((self.ui).btn_Event).gameObject):SetActive(isHaveEvent)
    if self.loop1Effect ~= nil then
      (self.loop1Effect):SetActive(false)
      ;
      (self.loop2Effect):SetActive(false)
    end
    if isComplete then
      ((self.ui).img_buttom):SetIndex(1)
      if self.loop1Effect == nil then
        local prefab1 = (self.resloader):LoadABAsset((ActivityWhiteDayEnum.effect).loop1)
        local prefab2 = (self.resloader):LoadABAsset((ActivityWhiteDayEnum.effect).loop2)
        self.loop1Effect = prefab1:Instantiate(((self.ui).go_EffectLoop1Root).transform)
        self.loop2Effect = prefab2:Instantiate(((self.ui).go_EffectLoop2Root).transform)
      else
        do
          ;
          (self.loop1Effect):SetActive(false)
          ;
          (self.loop1Effect):SetActive(true)
          ;
          (self.loop2Effect):SetActive(false)
          ;
          (self.loop2Effect):SetActive(true)
          ;
          ((self.ui).img_buttom):SetIndex(0)
          if not isUnlcok then
            local unlockLevel = (self.AWDLineData):GetWDLUnlockLevel()
            ;
            ((self.ui).img_AddLocked):SetIndex(1)
            ;
            (((self.ui).img_Icon).gameObject):SetActive(false)
            ;
            ((self.ui).tex_Condition):SetIndex(0, tostring(unlockLevel))
          else
            do
              ;
              (((self.ui).img_AddLocked).gameObject):SetActive(not isInProduction)
              ;
              (((self.ui).img_Icon).gameObject):SetActive(isInProduction)
              if isInProduction then
                local WDOrderData = (self.AWDLineData):GetWDProductionOrderData()
                local orderItemId = WDOrderData:GetWDOrderItemId()
                local orderItemCfg, itemNum = WDOrderData:GetWDOrderItemIdAndNum()
                -- DECOMPILER ERROR at PC165: Confused about usage of register: R9 in 'UnsetPending'

                ;
                ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemId(orderItemId)
                if itemNum > 1 then
                  ((self.ui).obj_count):SetActive(true)
                  -- DECOMPILER ERROR at PC178: Confused about usage of register: R9 in 'UnsetPending'

                  ;
                  ((self.ui).tex_Count).text = tostring(itemNum)
                end
                self:RefreshAWDOrderProcess()
              else
                do
                  ;
                  ((self.ui).img_AddLocked):SetIndex(0)
                  if isInProduction and not isComplete then
                    if self.accLoopEffect == nil then
                      local prefab = (self.resloader):LoadABAsset((ActivityWhiteDayEnum.effect).accLoop)
                      self.accLoopEffect = prefab:Instantiate(((self.ui).obj_EffectAccLoopRoot).transform)
                    else
                      do
                        ;
                        (self.accLoopEffect):SetActive(true)
                        if self.accLoopEffect ~= nil then
                          (self.accLoopEffect):SetActive(false)
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

UINWhiteDayLineSlotNode.WDSlotPlayAccEffect = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActivityWhiteDayEnum
  local isInProduction = (self.AWDLineData):GetIsInProduction()
  local isComplete = (self.AWDLineData):GetIsProductionOver()
  if self.__accEffectTimerId ~= nil then
    TimerManager:StopTimer(self.__accEffectTimerId)
    self.__accEffectTimerId = nil
  end
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

  if isInProduction and not isComplete then
    ((self.ui).tex_Time).text = TimeUtil:TimestampToTime(0, false, false, true)
    ;
    ((self.ui).obj_frame):SetActive(true)
    ;
    ((self.ui).obj_tex_Start):SetActive(false)
    ;
    ((self.ui).obj_condition):SetActive(false)
    ;
    ((self.ui).obj_timeAndAcc):SetActive(true)
    if self.accHitEffect == nil then
      local prefab = (self.resloader):LoadABAsset((ActivityWhiteDayEnum.effect).accHit)
      self.accHitEffect = prefab:Instantiate(((self.ui).obj_EffectAccHitRoot).transform)
    else
      do
        ;
        (self.accHitEffect):SetActive(true)
        AudioManager:PlayAudioById(1208)
        local OnEndPlayAccEffect = function()
    -- function num : 0_3_0 , upvalues : self
    (self.accHitEffect):SetActive(false)
    self:RefreshAWDLineSlot()
    self.__accEffectTimerId = nil
  end

        self.__accEffectTimerId = TimerManager:StartTimer(2.5, OnEndPlayAccEffect, self, true)
      end
    end
  end
end

UINWhiteDayLineSlotNode.RefreshAWDOrderProcess = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local isInProduction = (self.AWDLineData):GetIsInProduction()
  if isInProduction then
    local isComplete = (self.AWDLineData):GetIsProductionOver()
    if self.__accEffectTimerId == nil then
      ((self.ui).obj_frame):SetActive(not isComplete)
    end
    if isComplete then
      ((self.ui).img_buttom):SetIndex(1)
    else
      ;
      ((self.ui).img_buttom):SetIndex(0)
      local leftTime = (self.AWDLineData):GetInProductionLeftTime()
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_Time).text = TimeUtil:TimestampToTime(leftTime, false, false, true)
    end
  end
end

UINWhiteDayLineSlotNode.RefreshAWDLineSlotPos = function(self)
  -- function num : 0_5
end

UINWhiteDayLineSlotNode.TryRefreshWDEventTween = function(self, taskData)
  -- function num : 0_6
  if taskData.id == (self.AWDLineData):GetWDLEventTaksId() then
    self:__RefreshWDEventTween()
  end
end

UINWhiteDayLineSlotNode.__RefreshWDEventTween = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local isHaveEvent = (self.AWDLineData):GetIsHaveEvent()
  if not isHaveEvent then
    ((self.ui).tween_event):DORewind()
    return 
  end
  local taskId = (self.AWDLineData):GetWDLEventTaksId()
  if taskId == nil then
    ((self.ui).tween_event):DORewind()
    return 
  end
  local taskData = ((PlayerDataCenter.allTaskData).taskDatas)[taskId]
  if taskData == nil then
    ((self.ui).tween_event):DORewind()
    return 
  end
  local isComplete = taskData:CheckComplete()
  if isComplete then
    ((self.ui).tween_event):DOPlayForward()
  else
    ;
    ((self.ui).tween_event):DORewind()
  end
end

UINWhiteDayLineSlotNode.OnAWDClickSlot = function(self)
  -- function num : 0_8 , upvalues : _ENV, ActivityWhiteDayEnum, CommonRewardData
  local isUnlcok = (self.AWDLineData):GetIsWDLUnlock()
  local isInProduction = (self.AWDLineData):GetIsInProduction()
  local lineId = (self.AWDLineData):GetWDLDLineID()
  local AWDData = (self.AWDLineData):GetAWDData()
  local actFrameId = AWDData:GetActFrameId()
  if not isInProduction and isUnlcok then
    UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayLine, function(win)
    -- function num : 0_8_0 , upvalues : self
    if win ~= nil then
      win:InitWDLine(self.AWDCtrl, self.AWDLineData)
    end
  end
)
  end
  if isInProduction then
    if (self.AWDLineData):GetIsProductionOver() then
      local orderData = (self.AWDLineData):GetWDProductionOrderData()
      do
        local AWDData = (self.AWDLineData):GetAWDData()
        if self.picEffect == nil then
          local prefab = (self.resloader):LoadABAsset((ActivityWhiteDayEnum.effect).hit)
          self.picEffect = prefab:Instantiate(((self.ui).go_EffectPickRoot).transform)
        else
          do
            do
              ;
              (self.picEffect):SetActive(false)
              ;
              (self.picEffect):SetActive(true)
              ;
              (self.AWDCtrl):WDFinishLineOrder(actFrameId, lineId, function(rewardDic)
    -- function num : 0_8_1 , upvalues : self, _ENV, CommonRewardData, AWDData
    (self.AWDLineData):SetWDLDAssistHeroID(nil)
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_8_1_0 , upvalues : CommonRewardData, rewardDic, self, AWDData, _ENV
      if window == nil then
        return 
      end
      local CRData = ((CommonRewardData.CreateCRDataUseDic)(rewardDic)):SetCRShowOverFunc(function()
        -- function num : 0_8_1_0_0 , upvalues : self, AWDData, _ENV
        (self.AWDCtrl):WDTryShowFactroyLevelUp(AWDData, function()
          -- function num : 0_8_1_0_0_0 , upvalues : _ENV
          local whiteDayWin = UIManager:GetWindow(UIWindowTypeID.WhiteDay)
          if whiteDayWin ~= nil then
            (whiteDayWin.infoBtnNode):TryPlayWDLevelExpTween()
          end
        end
)
      end
)
      if AWDData:GetWhiteDayPhotoConvertItemIsAboveLimit() then
        local randomId, _ = AWDData:GetWDRandomPhotoItemIdAndNum()
        local exchangeId, _ = AWDData:GetWDExchangePhotoItemIdAndNum()
        local randomNum = rewardDic[randomId] or 0
        local exchangeNum = rewardDic[exchangeId] or 0
        local converItems = {}
        if randomNum > 0 then
          converItems[randomId] = randomNum
        end
        if exchangeNum > 0 then
          converItems[exchangeId] = exchangeNum
        end
        CRData:SetCRItemTransDic(converItems)
      end
      do
        window:AddAndTryShowReward(CRData)
      end
    end
)
  end
)
            end
            self:OnAWDClickAcc()
          end
        end
      end
    end
  end
end

UINWhiteDayLineSlotNode.OnAWDClickAcc = function(self)
  -- function num : 0_9 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayAccOrder, function(win)
    -- function num : 0_9_0 , upvalues : self
    if win ~= nil then
      win:InitWDAccOrder(self.AWDCtrl, self.AWDLineData)
    end
  end
)
end

UINWhiteDayLineSlotNode.OnAWDClickEvent = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayEvent, function(win)
    -- function num : 0_10_0 , upvalues : self
    if win ~= nil then
      win:InitWDEvent(self.AWDCtrl, self.AWDLineData)
    end
  end
)
end

UINWhiteDayLineSlotNode.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  if self.__accEffectTimerId ~= nil then
    TimerManager:StopTimer(self.__accEffectTimerId)
    self.__accEffectTimerId = nil
  end
  ;
  ((self.ui).tween_event):DOKill()
  ;
  (base.OnDelete)(self)
end

return UINWhiteDayLineSlotNode

