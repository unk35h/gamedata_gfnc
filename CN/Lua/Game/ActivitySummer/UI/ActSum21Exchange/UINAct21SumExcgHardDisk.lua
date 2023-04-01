-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAct21SumExcgHardDisk = class("UINAct21SumExcgHardDisk", UIBaseNode)
local base = UIBaseNode
local UINAct21SumExcgHardDiskItem = require("Game.ActivitySummer.UI.ActSum21Exchange.UINAct21SumExcgHardDiskItem")
local cs_EventTriggerListener = CS.EventTriggerListener
UINAct21SumExcgHardDisk.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAct21SumExcgHardDiskItem, cs_EventTriggerListener
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Last, self, self.OnLastClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Next, self, self.OnNextClick)
  self.itemPool = (UIItemPool.New)(UINAct21SumExcgHardDiskItem, (self.ui).obj_HDItem)
  ;
  ((self.ui).obj_HDItem):SetActive(false)
  self.unitShelfWith = (((self.ui).tran_totalShelf).rect).width
  local eventTigger = (cs_EventTriggerListener.Get)((self.ui).scroll)
  eventTigger:onBeginDrag("+", BindCallback(self, self.OnRectBeginDrag))
  eventTigger:onEndDrag("+", BindCallback(self, self.OnRectEndDrag))
end

UINAct21SumExcgHardDisk.InitHDNode = function(self, sectorIData, poolIdcallback)
  -- function num : 0_1 , upvalues : _ENV
  local poolIdList = sectorIData:GetActSectorIDataPoolIdList()
  if poolIdList == nil or #poolIdList <= 0 then
    return 
  end
  self.poolIdcallback = poolIdcallback
  self.poolIdList = poolIdList
  self.poolIdDic = {}
  for k,poolId in ipairs(self.poolIdList) do
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R9 in 'UnsetPending'

    (self.poolIdDic)[poolId] = k
  end
  self:_InitUI(poolIdList)
  self:_SelectPool(sectorIData.roundId, true)
end

UINAct21SumExcgHardDisk._InitUI = function(self, poolIdList)
  -- function num : 0_2
  self:_InitHDItem(poolIdList)
  self:_InitShelfCount(#poolIdList)
end

UINAct21SumExcgHardDisk._InitHDItem = function(self, poolIdList)
  -- function num : 0_3 , upvalues : _ENV
  (self.itemPool):HideAll()
  for idx,poolId in ipairs(poolIdList) do
    local item = (self.itemPool):GetOne()
    item:InitHardDiskItem(idx, poolId)
  end
  self.totalRectWith = (self.ui).ItemUnitWith * #poolIdList
end

UINAct21SumExcgHardDisk._InitShelfCount = function(self, totalCount)
  -- function num : 0_4 , upvalues : _ENV
  local hight = (((self.ui).tran_totalShelf).rect).height
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tran_totalShelf).sizeDelta = (Vector2.New)(self.unitShelfWith * totalCount, hight)
end

UINAct21SumExcgHardDisk._SelectPool = function(self, curPoolId, isInit)
  -- function num : 0_5
  self.curPoolId = curPoolId or 1
  self.curIndex = (self.poolIdDic)[curPoolId] or 1
  self:_SetCurShelfPointPos(self.curIndex)
  self:_SetBtnGroupEnabled(self.curIndex)
  if isInit then
    self:_RefreshItemAnchorPos(self.curIndex)
  else
    self:_DOTweenItemAnchorPos(self.curIndex)
  end
  if self.poolIdcallback ~= nil then
    (self.poolIdcallback)(self.curPoolId, self.curIndex)
  end
end

UINAct21SumExcgHardDisk._SelectPoolByIndex = function(self, curIdx)
  -- function num : 0_6
  local poolId = (self.poolIdList)[curIdx]
  self:_SelectPool(poolId)
end

UINAct21SumExcgHardDisk._SetCurShelfPointPos = function(self, curIdx)
  -- function num : 0_7 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tran_curShelf).anchoredPosition = (Vector3.New)(self.unitShelfWith * (curIdx - 1), 0, 0)
end

UINAct21SumExcgHardDisk._SetBtnGroupEnabled = function(self, curIdx)
  -- function num : 0_8
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).btn_Last).interactable = curIdx ~= 1
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).btn_Next).interactable = curIdx ~= #self.poolIdList
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINAct21SumExcgHardDisk._DOTweenItemAnchorPos = function(self, curIdx)
  -- function num : 0_9
  ((self.ui).tran_rect):DOKill()
  ;
  ((self.ui).tran_rect):DOAnchorPosX(-(self.ui).ItemUnitWith * (curIdx - 1), 0.25)
end

UINAct21SumExcgHardDisk._RefreshItemAnchorPos = function(self, curIdx)
  -- function num : 0_10 , upvalues : _ENV
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tran_rect).anchoredPosition = (Vector3.New)(-(self.ui).ItemUnitWith * (curIdx - 1), 0, 0)
end

UINAct21SumExcgHardDisk.OnLastClick = function(self)
  -- function num : 0_11
  self:_OnClickChangePool(-1)
end

UINAct21SumExcgHardDisk.OnNextClick = function(self)
  -- function num : 0_12
  self:_OnClickChangePool(1)
end

UINAct21SumExcgHardDisk._OnClickChangePool = function(self, idxOffset)
  -- function num : 0_13 , upvalues : _ENV
  local newIdx = (self.poolIdDic)[self.curPoolId] + idxOffset
  newIdx = (math.clamp)(newIdx, 1, #self.poolIdList)
  local poolId = (self.poolIdList)[newIdx]
  self:_SelectPool(poolId)
  AudioManager:PlayAudioById(1135)
end

UINAct21SumExcgHardDisk.OnRectBeginDrag = function(self, go, eventData)
  -- function num : 0_14
  self._beginDragPosX = (eventData.position).x
  self._ratio = 1 / #self.poolIdList
end

UINAct21SumExcgHardDisk.OnRectEndDrag = function(self, go, eventData)
  -- function num : 0_15 , upvalues : _ENV
  local offset = self._beginDragPosX - (eventData.position).x
  ;
  ((self.ui).scroll):StopMovement()
  local hPos = ((self.ui).scroll).horizontalNormalizedPosition
  if hPos <= 0 then
    self:_SelectPoolByIndex(1)
    return 
  end
  if hPos >= 1 then
    self:_SelectPoolByIndex(#self.poolIdList)
    return 
  end
  if (math.abs)(offset) < (self.ui).ItemUnitWith / 3 then
    self:_DOTweenItemAnchorPos(self.curIndex)
    return 
  end
  do
    if offset <= 0 or not 1 then
      local idxOffset = (self.ui).ItemUnitWith / 3 >= (math.abs)(offset) or (math.abs)(offset) >= (self.ui).ItemUnitWith or -1
    end
    self:_OnClickChangePool(idxOffset)
    do return  end
    local curPage = 1
    if (self.ui).ItemUnitWith < (math.abs)(offset) then
      curPage = 1
      for i = 1, #self.poolIdList do
        if hPos < self._ratio * i then
          curPage = i
          break
        end
      end
    end
    do
      self:_SelectPoolByIndex(curPage)
    end
  end
end

UINAct21SumExcgHardDisk.RefreshHD = function(self, curPickedNum, allRewardNum)
  -- function num : 0_16
  for i = 1, self.curIndex - 1 do
    local item = ((self.itemPool).listItem)[i]
    if item ~= nil then
      item:SetHardDiskItemDissolve(1)
    end
  end
  local item = ((self.itemPool).listItem)[self.curIndex]
  if item ~= nil then
    item:SetHardDiskItemDissolve(curPickedNum / allRewardNum)
  end
end

UINAct21SumExcgHardDisk.PlayHDItemTween = function(self, poolID, curPickedNum, allRewardNum)
  -- function num : 0_17 , upvalues : _ENV
  local idx = (self.poolIdDic)[poolID]
  idx = (math.clamp)(idx, 1, #self.poolIdList)
  if self.oldItem ~= nil then
    (self.oldItem):KillTween()
    self.oldItem = nil
  end
  local item = ((self.itemPool).listItem)[self.curIndex]
  if item ~= nil then
    item:PlayFxDOTween(curPickedNum, allRewardNum)
    self.oldItem = item
  end
end

UINAct21SumExcgHardDisk.OnDelete = function(self)
  -- function num : 0_18 , upvalues : base
  (self.itemPool):DeleteAll()
  ;
  ((self.ui).tran_rect):DOKill()
  ;
  (base.OnDelete)(self)
end

return UINAct21SumExcgHardDisk

