-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthListSuit = class("UINAthListSuit", UIBaseNode)
local base = UIBaseNode
local UINAthListSuitItem = require("Game.Arithmetic.AthList.Suit.UINAthListSuitItem")
UINAthListSuit.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_SuitRate, self, self._OnClickUseSuitRate)
  self._OnClickSuitItemFunc = BindCallback(self, self._OnClickSuitItem)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onReturnItem = BindCallback(self, self.__OnReturnItem)
  self.suitItemDic = {}
  self._isInit = true
end

UINAthListSuit.InitAthListSuit = function(self, athListRoot, heroData, resLoader)
  -- function num : 0_1
  self.athListRoot = athListRoot
  if self.heroData ~= heroData and self._showSuitUsingRate then
    self._waitSuitUsingRate = true
    self:_ReqSuitUsingRate(heroData, function()
    -- function num : 0_1_0 , upvalues : self
    self._waitSuitUsingRate = false
    if self._waitRefreshList then
      self:RefreshAthListSuit(true)
    end
  end
)
  end
  self.heroData = heroData
  self.heroAthSuitRecommendDic = heroData:GetHeroAthSuitRecommendDic()
  self.resLoader = resLoader
end

UINAthListSuit.SetAthListSuitSelectedSuitId = function(self, athSuitId)
  -- function num : 0_2
  self.selectedAthSuitId = athSuitId
  ;
  (((self.ui).img_Select).transform):SetParent((self.ui).prefabHolder)
  if athSuitId == nil then
    return 
  end
  if self._suitSelSeq ~= nil then
    (self._suitSelSeq):Restart()
    return 
  end
  self:_InitSuitSelectSeq()
end

UINAthListSuit.SetAthListSuitArea = function(self, areaId)
  -- function num : 0_3 , upvalues : _ENV
  self.areaId = areaId
  ;
  (((self.ui).tog_SuitRate).gameObject):SetActive((areaId ~= nil and FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Algorithm_Rate)))
  self:RefreshAthListSuit(true)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINAthListSuit.RefreshAthListSuit = function(self, refill, targetSuitId)
  -- function num : 0_4
  if self._waitSuitUsingRate then
    self._waitRefreshList = true
    return 
  end
  self._waitRefreshList = false
  local refillIdx = self:_RefreshAthListSuitData(targetSuitId)
  if targetSuitId == nil then
    self:SetAthListSuitSelectedSuitId(nil)
  end
  self:_RefillScrollRect(refill, refillIdx)
end

UINAthListSuit._RefreshAthListSuitData = function(self, targetSuitId)
  -- function num : 0_5 , upvalues : _ENV
  self.curSuitIdList = {}
  if self.areaId == nil then
    for suitId,v in pairs(ConfigData.ath_suit) do
      if not (((ConfigData.ath_suit).suitParamDic)[suitId]).exclude then
        (table.insert)(self.curSuitIdList, suitId)
      end
    end
  else
    do
      if self._showSuitUsingRate then
        self._suitUseRateDic = {}
        local usingRateList = (((self._heroAthStat).slots)[self.areaId]).suit
        for k,elem in ipairs(usingRateList) do
          if not (((ConfigData.ath_suit).suitParamDic)[elem.id]).exclude then
            (table.insert)(self.curSuitIdList, elem.id)
            -- DECOMPILER ERROR at PC55: Confused about usage of register: R8 in 'UnsetPending'

            ;
            (self._suitUseRateDic)[elem.id] = elem.ratio
          end
        end
      else
        do
          if #self.curSuitIdList <= 3 then
            if not ((ConfigData.arithmetic).areaSuitDic)[self.areaId] then
              local suitIdDic = table.emptytable
            end
            for suitId,v in pairs(suitIdDic) do
              if not (((ConfigData.ath_suit).suitParamDic)[suitId]).exclude then
                (table.insert)(self.curSuitIdList, suitId)
              end
            end
          end
          do
            local allAthIdNumDic = (PlayerDataCenter.allAthData):GetAllAthIdNumDic()
            local suitAthNumDic = (table.GetDefaulValueTable)(0)
            for k,suitId in ipairs(self.curSuitIdList) do
              local suitCfltDic = ((ConfigData.arithmetic).suitDic)[suitId]
              if suitCfltDic == nil then
                error("Cant find suitCfltDic, suitId = " .. tostring(suitId))
              else
                for k2,suitAthIdList in pairs(suitCfltDic) do
                  for k3,athId in ipairs(suitAthIdList) do
                    suitAthNumDic[suitId] = suitAthNumDic[suitId] + allAthIdNumDic[athId]
                  end
                end
              end
            end
            self.suitAthNumDic = suitAthNumDic
            if not self._showSuitUsingRate or self.areaId == nil then
              self:_SortSuitList(suitAthNumDic)
            end
            if targetSuitId ~= nil then
              for k,suitId in ipairs(self.curSuitIdList) do
                if targetSuitId == suitId then
                  return k - 1
                end
              end
            end
          end
        end
      end
    end
  end
end

UINAthListSuit._SortSuitList = function(self, suitAthNumDic)
  -- function num : 0_6 , upvalues : _ENV
  local careerCfgcre = (self.heroData):GetCareerCfg()
  local suitRecommendArea = careerCfgcre.algorithm_suit_recommend
  ;
  (table.sort)(self.curSuitIdList, function(suitIdA, suitIdB)
    -- function num : 0_6_0 , upvalues : self, suitRecommendArea, _ENV, suitAthNumDic
    local recommendA = (self.heroAthSuitRecommendDic)[suitIdA] ~= nil
    local recommendB = (self.heroAthSuitRecommendDic)[suitIdB] ~= nil
    if recommendA ~= recommendB then
      return recommendA
    end
    local recommendArea = nil
    if self.areaId == nil then
      recommendArea = suitRecommendArea
    else
      recommendArea = self.areaId
    end
    local priorityDic = (self.recommendAredSuitDic)[recommendArea]
    if not priorityDic[suitIdA] then
      local priorityA = math.maxinteger
    end
    if not priorityDic[suitIdB] then
      local priorityB = math.maxinteger
    end
    if priorityA >= priorityB then
      do return priorityA == priorityB end
      local hasA = suitAthNumDic[suitIdA] > 0
      local hasB = suitAthNumDic[suitIdB] > 0
      if hasA ~= hasB then
        return hasA
      end
      local orderA = (((ConfigData.ath_suit).suitParamDic)[suitIdA]).suit_order
      local orderB = (((ConfigData.ath_suit).suitParamDic)[suitIdB]).suit_order
      if orderA >= orderB then
        do return orderA == orderB end
        do return suitIdA < suitIdB end
        -- DECOMPILER ERROR: 15 unprocessed JMP targets
      end
    end
  end
)
end

UINAthListSuit._RefillScrollRect = function(self, refill, refillIdx)
  -- function num : 0_7
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).scrollRect).totalCount = #self.curSuitIdList
  if not refillIdx then
    ((self.ui).scrollRect):RefillCells(not self._isInit and not refill and not self._nextFill or 0)
    self._isInit = false
    self._nextFill = not (((self.ui).scrollRect).gameObject).activeInHierarchy
    ;
    ((self.ui).scrollRect):RefreshCells()
    ;
    (self.athListRoot):ShowAthListEmpty(#self.curSuitIdList == 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

UINAthListSuit.__OnNewItem = function(self, go)
  -- function num : 0_8 , upvalues : UINAthListSuitItem
  local item = (UINAthListSuitItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.suitItemDic)[go] = item
end

UINAthListSuit.__OnChangeItem = function(self, go, index)
  -- function num : 0_9 , upvalues : _ENV
  local item = (self.suitItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local suitId = (self.curSuitIdList)[index + 1]
  if suitId == nil then
    error("Can\'t find suitId by index, index = " .. tonumber(index))
  end
  local curCount = (self.suitAthNumDic)[suitId]
  local isRecommend = (self.heroAthSuitRecommendDic)[suitId] ~= nil
  item:InitAthListSuitItem(suitId, isRecommend, self._OnClickSuitItemFunc, self.resLoader, curCount)
  do
    if self._showSuitUsingRate and self.areaId ~= nil then
      local usingRate = (self._suitUseRateDic)[suitId]
      item:ShowAthListSuitItemUsingRate(usingRate)
    end
    if self.selectedAthSuitId == suitId then
      (((self.ui).img_Select).transform):SetParent(item.transform)
      -- DECOMPILER ERROR at PC63: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (((self.ui).img_Select).transform).anchoredPosition = (Vector2.New)(-3, 3)
    end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UINAthListSuit.__OnReturnItem = function(self, go)
  -- function num : 0_10 , upvalues : _ENV
  local item = (self.suitItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  if self.selectedAthSuitId ~= nil and item.suitId == self.selectedAthSuitId then
    (((self.ui).img_Select).transform):SetParent((self.ui).prefabHolder)
  end
end

UINAthListSuit._OnClickSuitItem = function(self, suitId)
  -- function num : 0_11
  if (self.suitAthNumDic)[suitId] > 0 then
    (self.athListRoot):ShowAthListSuitAth(suitId)
  end
end

UINAthListSuit._OnClickUseSuitRate = function(self, isOn)
  -- function num : 0_12
  if isOn then
    self:_ReqSuitUsingRate(self.heroData, function()
    -- function num : 0_12_0 , upvalues : self
    self._showSuitUsingRate = true
    self:RefreshAthListSuit(true)
  end
)
    return 
  end
  self._showSuitUsingRate = false
  self:RefreshAthListSuit(true)
end

UINAthListSuit._ReqSuitUsingRate = function(self, heroData, callBack)
  -- function num : 0_13 , upvalues : _ENV
  (PlayerDataCenter.allAthData):GetHeroAthStat(heroData.dataId, function(heroAthStat)
    -- function num : 0_13_0 , upvalues : self, callBack
    self._heroAthStat = heroAthStat
    if callBack then
      callBack()
    end
  end
)
end

UINAthListSuit._InitSuitSelectSeq = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local cs_DoTween = ((CS.DG).Tweening).DOTween
  local seq = (cs_DoTween.Sequence)()
  seq:Append(((((self.ui).img_Select):DOColor(Color.white, 0.25)):From()):SetLoops(3))
  seq:Append((((self.ui).img_Select):DOFade(0, 0.25)):SetDelay(0.25))
  seq:SetAutoKill(false)
  seq:OnComplete(function()
    -- function num : 0_14_0 , upvalues : self
    self:SetAthListSuitSelectedSuitId(nil)
  end
)
  self._suitSelSeq = seq
end

UINAthListSuit.OnDelete = function(self)
  -- function num : 0_15 , upvalues : _ENV, base
  for k,suitItem in pairs(self.suitItemDic) do
    suitItem:Delete()
  end
  self.suitItemDic = nil
  if self._suitSelSeq ~= nil then
    (self._suitSelSeq):Kill()
    self._suitSelSeq = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINAthListSuit

