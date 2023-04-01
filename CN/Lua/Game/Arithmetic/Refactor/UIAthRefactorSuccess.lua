-- params : ...
-- function num : 0 , upvalues : _ENV
local UIAthRefactorSuccess = class("UIAthRefactorSuccess", UIBaseWindow)
local base = UIBaseWindow
local UINAthDetailItem = require("Game.Arithmetic.AthDetail.UINAthDetailItem")
local AthEnum = require("Game.Arithmetic.ArthmeticEnum")
local UINAthUsingRate = require("Game.Arithmetic.UsingRate.UINAthUsingRate")
local cs_MessageCommon = CS.MessageCommon
local cs_tweening = (CS.DG).Tweening
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local nodeHightList = {[1] = 120, [2] = 763.4835, [3] = 197.87}
UIAthRefactorSuccess.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAthDetailItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Save, self, self._OnClickSave)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self._OnClickCancel)
  self.athDetailOld = (UINAthDetailItem.New)()
  ;
  (self.athDetailOld):Init((self.ui).athDetailOld)
  self.athDetailNew = (UINAthDetailItem.New)()
  ;
  (self.athDetailNew):Init((self.ui).athDetailNew)
  self.athNetwork = NetworkManager:GetNetwork(NetworkTypeID.Arithmetic)
end

UIAthRefactorSuccess.InitAthRefactorSuccess = function(self, athData, heroData)
  -- function num : 0_1
  self:_InitData(athData)
  local isMulti = #self._affixGroupList > 1
  ;
  ((self.athDetailOld):SetAthDetailItemBrief(isMulti)):InitAthDetailItem(nil, athData, heroData, nil, nil, true)
  ;
  ((self.athDetailNew):SetAthDetailItemBrief(isMulti)):InitAthDetailItem(nil, athData, heroData, nil, nil, true)
  if isMulti then
    self:_InitExtra()
  else
    self:_SelectResult(1)
  end
  self:_UpdAthRfctDetailUsingRate()
  self:_PlayTween()
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIAthRefactorSuccess._PlayTween = function(self)
  -- function num : 0_2
  self:__InitTheTween()
  ;
  ((self.ui).fXP_StarUpSuccessbj):Play()
end

UIAthRefactorSuccess._InitData = function(self, athData)
  -- function num : 0_3 , upvalues : _ENV
  self.athData = athData
  self.hasHighQuality = false
  self._affixGroupList = {}
  for k,v in ipairs((PlayerDataCenter.allAthData).athReconsitutionDataList) do
    local newAffixList = {}
    for k,affixElem in ipairs(athData.affixList) do
      if affixElem.lock then
        (table.insert)(newAffixList, affixElem)
      else
        local elem = (v.reco)[k - 1]
        local newAffixElem = DeepCopy(affixElem)
        newAffixElem.id = elem.id
        newAffixElem.quality = elem.quality
        newAffixElem.value = (PlayerDataCenter.allAthData):GenAthAffixValue(newAffixElem.id, newAffixElem.quality, newAffixElem.level)
        if affixElem.quality < newAffixElem.quality then
          self.hasHighQuality = true
        end
        ;
        (table.insert)(newAffixList, newAffixElem)
      end
    end
    ;
    (table.insert)(self._affixGroupList, newAffixList)
  end
end

UIAthRefactorSuccess._InitExtra = function(self)
  -- function num : 0_4 , upvalues : _ENV, cs_LayoutRebuilder
  do
    if self._resultItemPool == nil then
      local UINRfctSuccessResultItem = require("Game.Arithmetic.Refactor.Success.UINRfctSuccessResultItem")
      self._resultItemPool = (UIItemPool.New)(UINRfctSuccessResultItem, (self.ui).resultItem, false)
    end
    ;
    ((self.ui).ResultRect):SetAllTogglesOff()
    ;
    (self._resultItemPool):HideAll()
    if not self._selectResultFunc then
      self._selectResultFunc = BindCallback(self, self._SelectResult)
      for k,affixList in ipairs(self._affixGroupList) do
        local isSelected = k == 1
        local resultItem = (self._resultItemPool):GetOne()
        resultItem:InitRfctSuccessResultItem(k, affixList, self._selectResultFunc, isSelected)
      end
      ;
      (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)(((self.ui).ResultRect).transform)
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end
end

UIAthRefactorSuccess._UpdAthRfctDetailUsingRate = function(self)
  -- function num : 0_5 , upvalues : UINAthUsingRate, _ENV
  if (self.athData).bindInfo == nil then
    ((self.ui).athUsingRate):SetActive(false)
    return 
  end
  self._showUsingRate = true
  do
    if self.athUsingRateNode == nil then
      local athUsingRate = (UINAthUsingRate.New)()
      athUsingRate:Init((self.ui).athUsingRate)
      athUsingRate:InitAthUsingRate(BindCallback(self, self._ShowUsingRateWin))
      self.athUsingRateNode = athUsingRate
    end
    ;
    (self.athUsingRateNode):Show()
  end
end

UIAthRefactorSuccess._ShowUsingRateWin = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local heroData = (PlayerDataCenter.heroDic)[((self.athData).bindInfo).id]
  local areaId = ((self.athData).bindInfo).idx
  ;
  (self.athUsingRateNode):ShowAthUsingRateDetail(heroData, areaId)
end

UIAthRefactorSuccess._SelectResult = function(self, idx)
  -- function num : 0_7
  self._selectResultIdx = idx
  ;
  (self.athDetailNew):RefreshAthDetailItemSubAttr((self._affixGroupList)[idx])
end

UIAthRefactorSuccess._OnClickSave = function(self)
  -- function num : 0_8 , upvalues : _ENV, cs_MessageCommon
  local sendFunc = function()
    -- function num : 0_8_0 , upvalues : self, _ENV
    if not self.__OnSaveComplete then
      self.__OnSaveComplete = BindCallback(self, self._OnSaveComplete)
      ;
      (self.athNetwork):CS_ATH_ReconsitutionSave(self._selectResultIdx - 1, self.__OnSaveComplete)
    end
  end

  if self:_AnyBetterResult() then
    (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(6049), sendFunc, nil)
    return 
  end
  sendFunc()
end

UIAthRefactorSuccess._AnyBetterResult = function(self)
  -- function num : 0_9 , upvalues : _ENV, AthEnum
  local selectAffixList = (self._affixGroupList)[self._selectResultIdx]
  local selTotalQuality = 0
  for k,selectedAffix in ipairs(selectAffixList) do
    selTotalQuality = selTotalQuality + (AthEnum.GetAthRfctBetterQualityWeight)(selectedAffix.quality)
  end
  for k,affixList in ipairs(self._affixGroupList) do
    if k ~= self._selectResultIdx then
      local curQuality = 0
      for k2,selectedAffix in ipairs(affixList) do
        curQuality = curQuality + (AthEnum.GetAthRfctBetterQualityWeight)(selectedAffix.quality)
      end
      if selTotalQuality < curQuality then
        return true
      end
    end
  end
  return false
end

UIAthRefactorSuccess._OnSaveComplete = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local window = UIManager:GetWindow(UIWindowTypeID.AthRefactor)
  if window ~= nil then
    window:ResetAthRefactor()
  end
  self:Hide()
end

UIAthRefactorSuccess._OnClickCancel = function(self)
  -- function num : 0_11 , upvalues : _ENV, cs_MessageCommon
  if self.__OnCancelComplete == nil then
    self.__OnCancelComplete = BindCallback(self, self._OnCancelComplete)
  end
  local sendFunc = function()
    -- function num : 0_11_0 , upvalues : self
    (self.athNetwork):CS_ATH_ReconsitutionDrop(self.__OnCancelComplete)
  end

  if self.hasHighQuality then
    (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(TipContent.ATH_ConfirmCancelRefactor), sendFunc, nil)
  else
    sendFunc()
  end
end

UIAthRefactorSuccess._OnCancelComplete = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local window = UIManager:GetWindow(UIWindowTypeID.AthRefactor)
  if window ~= nil then
    window:ResetAthRefactor()
  end
  self:Hide()
end

UIAthRefactorSuccess.__InitTheTween = function(self)
  -- function num : 0_13 , upvalues : cs_tweening, _ENV, nodeHightList
  ((self.ui).obj_isNew):SetActive(false)
  if self.tweenSeq ~= nil then
    (self.tweenSeq):Kill()
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).interactable = false
  self.tweenSeq = ((cs_tweening.DOTween).Sequence)()
  local count = 0
  local delay = 0
  for index,Hight in ipairs(nodeHightList) do
    count = count + 1
    delay = count == 2 and 0.35 or 0
    self:__SetNodeShowTween(index, Hight, delay)
  end
end

UIAthRefactorSuccess.__SetNodeShowTween = function(self, index, height, SetDelay)
  -- function num : 0_14 , upvalues : _ENV, cs_tweening
  local delay = SetDelay or 0
  local fade = ((self.ui).fadeList)[index]
  local layout = ((self.ui).layoutList)[index]
  layout.minHeight = 0
  ;
  (self.tweenSeq):Append((layout:DOMinSize((Vector2.New)(0, height), 0.3, true)):SetDelay(delay))
  if index == 1 then
    (self.tweenSeq):Join((fade:DOFade(0, 0.1)):SetLoops(6, (cs_tweening.LoopType).Yoyo))
  else
    if index == 2 then
      fade.alpha = 0
      ;
      (self.tweenSeq):Join(fade:DOFade(1, 0.3))
      self:_SetAthItemTween((self.ui).athDetailOld, 300)
      self:_SetAthItemTween((self.ui).athDetailNew, 300)
    else
      fade.alpha = 0
      ;
      (self.tweenSeq):Join(fade:DOFade(1, 0.3))
      self:_SetAthItemTween(((self.ui).btn_Cancle).gameObject, 100)
      self:_SetAthItemTween(((self.ui).btn_Save).gameObject, 100)
    end
  end
  ;
  (self.tweenSeq):OnComplete(function()
    -- function num : 0_14_0 , upvalues : self
    ((self.ui).obj_isNew):SetActive(true)
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).canvasGroup).interactable = true
  end
)
end

UIAthRefactorSuccess._SetAthItemTween = function(self, itemObj, office)
  -- function num : 0_15
  local transform = itemObj.transform
  ;
  (self.tweenSeq):Join((transform:DOAnchorPosY((transform.anchoredPosition).y - office, 0.3)):From())
end

UIAthRefactorSuccess.OnDelete = function(self)
  -- function num : 0_16 , upvalues : base
  (self.athDetailOld):Delete()
  ;
  (self.athDetailNew):Delete()
  if self._resultItemPool ~= nil then
    (self._resultItemPool):DeleteAll()
  end
  if self.athUsingRateNode then
    (self.athUsingRateNode):Delete()
  end
  if self.tweenSeq ~= nil then
    (self.tweenSeq):Kill()
    self.tweenSeq = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIAthRefactorSuccess

