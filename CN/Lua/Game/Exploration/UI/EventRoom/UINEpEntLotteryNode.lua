-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.EventRoom.UINEventRoomPageBase")
local UINEpEntLotteryNode = class("UINEpEventNode", base)
local UINEpEventSlotMachineItem = require("Game.Exploration.UI.EventRoom.UINEpEventSlotMachineItem")
local cs_Edge = ((CS.UnityEngine).RectTransform).Edge
local CS_DOTween = ((CS.DG).Tweening).DOTween
UINEpEntLotteryNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, UINEpEventSlotMachineItem
  (base.OnInit)(self)
  self.__ChoiceFinihsEftEvent = BindCallback(self, self.__ChoiceFinihsEft)
  self._onSlotMachinePressUp = BindCallback(self, self._OnSlotMachinePressUp)
  self._onSlotMachinePressDown = BindCallback(self, self._OnSlotMachinePressDown)
  self.slotMachinePool = (UIItemPool.New)(UINEpEventSlotMachineItem, (self.ui).obj_rankdomItem)
  ;
  ((self.ui).obj_rankdomItem):SetActive(false)
end

UINEpEntLotteryNode.InitBranchPage = function(self, uiEvent, onChoiceClick)
  -- function num : 0_1 , upvalues : base
  (base.InitBranchPage)(self, uiEvent, onChoiceClick)
end

UINEpEntLotteryNode.RefreshBranchPage = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.RefreshBranchPage)(self)
  ;
  ((ExplorationManager.epCtrl).eventCtrl):RegistEventSelectSuccessFunc(self.__ChoiceFinihsEftEvent)
  ;
  (self.slotMachinePool):HideAll()
  for index,choiceData in ipairs(((self.uiEvent).roomData).choiceDatalist) do
    if choiceData.cfg ~= nil and (choiceData.cfg).gamblebenefit_tag > 0 then
      local slotItem = (self.slotMachinePool):GetOne(true)
      slotItem:InitSlotMachineItem(choiceData, self._onSlotMachinePressUp, self._onSlotMachinePressDown)
    end
  end
end

UINEpEntLotteryNode._OnSlotMachinePressUp = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.RichIntro)
end

UINEpEntLotteryNode._OnSlotMachinePressDown = function(self, name, desc)
  -- function num : 0_4 , upvalues : _ENV, cs_Edge
  UIManager:ShowWindowAsync(UIWindowTypeID.RichIntro, function(win)
    -- function num : 0_4_0 , upvalues : self, name, desc, cs_Edge
    if win ~= nil then
      win:ShowIntroCustom(((self.uiEvent).ui).introHolder, name, desc, true)
      win:SetIntroListPosition(cs_Edge.Right, cs_Edge.Top)
    end
  end
)
end

UINEpEntLotteryNode.__ChoiceFinihsEft = function(self, selectIndex, completeFunc)
  -- function num : 0_5 , upvalues : _ENV, CS_DOTween
  ((ExplorationManager.epCtrl).eventCtrl):CancleEventSelectSuccessFunc(self.__ChoiceFinihsEftEvent)
  local choiceItem = (self.choiceItemDic)[selectIndex + 1]
  if choiceItem == nil then
    completeFunc()
    return 
  end
  local eventChoiceCfg = (ConfigData.event_choice)[choiceItem.choiceId]
  if (choiceItem.cfg).gamble_group or choiceItem.cfg == nil or 0 == 0 then
    completeFunc()
    return 
  end
  local eftStopItem = nil
  for _,slotItem in ipairs((self.slotMachinePool).listItem) do
    do
      if slotItem.cfg ~= nil and (slotItem.cfg).group == (choiceItem.cfg).gamble_group then
        do
          eftStopItem = slotItem
          do break end
          -- DECOMPILER ERROR at PC48: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC48: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  if eftStopItem == nil then
    completeFunc()
    return 
  end
  if self.finishTween ~= nil then
    (self.finishTween):Kill()
    self.finishTween = nil
  end
  local finishTween = (CS_DOTween.Sequence)()
  ;
  ((self.ui).obj_SelectRankdomNode):SetActive(true)
  ;
  (self.uiEvent):ActiveUIMask(true)
  do
    for i = 1, (self.ui).rankdomTotalCycle do
      for _,slotItem in ipairs((self.slotMachinePool).listItem) do
        finishTween:AppendCallback(function()
    -- function num : 0_5_0 , upvalues : self, slotItem
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R0 in 'UnsetPending'

    (((self.ui).obj_SelectRankdomNode).transform).position = (slotItem.transform).position
  end
)
        finishTween:AppendInterval((self.ui).rankdomIntervialTime)
      end
    end
  end
  for _,slotItem in ipairs((self.slotMachinePool).listItem) do
    finishTween:AppendCallback(function()
    -- function num : 0_5_1 , upvalues : self, slotItem
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R0 in 'UnsetPending'

    (((self.ui).obj_SelectRankdomNode).transform).position = (slotItem.transform).position
  end
)
    if slotItem ~= eftStopItem then
      do
        finishTween:AppendInterval((self.ui).rankdomIntervialTime)
        -- DECOMPILER ERROR at PC109: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC109: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  finishTween:AppendInterval((self.ui).rankdomStayTime)
  finishTween:AppendCallback(function()
    -- function num : 0_5_2 , upvalues : self, completeFunc
    if self.finishTween ~= nil then
      (self.finishTween):Kill()
      self.finishTween = nil
    end
    ;
    ((self.ui).obj_SelectRankdomNode):SetActive(false)
    ;
    (self.uiEvent):ActiveUIMask(false)
    completeFunc()
  end
)
end

UINEpEntLotteryNode.OnDelete = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  if ExplorationManager.epCtrl ~= nil and (ExplorationManager.epCtrl).eventCtrl ~= nil then
    ((ExplorationManager.epCtrl).eventCtrl):CancleEventSelectSuccessFunc(self.__ChoiceFinihsEftEvent)
  end
  ;
  (base.OnDelete)(self)
end

return UINEpEntLotteryNode

