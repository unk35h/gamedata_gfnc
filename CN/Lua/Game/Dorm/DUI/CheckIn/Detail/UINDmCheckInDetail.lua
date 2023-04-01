-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDmCheckInDetail = class("UINDmCheckInDetail", UIBaseNode)
local base = UIBaseNode
local UINDmCheckInDetailSlot = require("Game.Dorm.DUI.CheckIn.Detail.UINDmCheckInDetailSlot")
local UINDmCheckInDetailHero = require("Game.Dorm.DUI.CheckIn.Detail.UINDmCheckInDetailHero")
local DormUtil = require("Game.Dorm.DormUtil")
local cs_MessageCommon = CS.MessageCommon
UINDmCheckInDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDmCheckInDetailSlot
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Last, self, self._OnClickLastRoom)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Next, self, self._OnClickNextRoom)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self._OnClickConfim)
  ;
  ((self.ui).roomSlotItem):SetActive(false)
  self.slotPool = (UIItemPool.New)(UINDmCheckInDetailSlot, (self.ui).roomSlotItem)
  self._UnbindSlotFunc = BindCallback(self, self._UnbindSlot)
  self._OnHeroListItemClickFunc = BindCallback(self, self._OnHeroListItemClick)
  self.heroItemDic = {}
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onInstantiateItem = BindCallback(self, self._OnInstantiateItem)
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onChangeItem = BindCallback(self, self._OnChangeItem)
end

UINDmCheckInDetail.InitDmCheckInDetail = function(self, roomData, index, houseData, checkInRoomDataList, dmCheckInCtrl)
  -- function num : 0_1 , upvalues : _ENV
  self.houseData = houseData
  self.checkInRoomDataList = checkInRoomDataList
  self.dmCheckInCtrl = dmCheckInCtrl
  self.heroList = {}
  for k,v in pairs(PlayerDataCenter.heroDic) do
    (table.insert)(self.heroList, v)
  end
  self.bindHeroIdFntDic = ((dmCheckInCtrl.dormCtrl).allDormData):GetDmBindHeroIdFntAllDic()
  self.bindInfoDic = {}
  self:_InitRoom(roomData, index)
end

UINDmCheckInDetail._InitRoom = function(self, roomData, index)
  -- function num : 0_2 , upvalues : _ENV, DormUtil
  self.roomData = roomData
  self.roomIdx = index
  local roomIdx = roomData:GetDmRoomIndex()
  local roomName = roomData:GetName()
  ;
  ((self.ui).tex_RoomName):SetIndex(0, (string.format)("%02d", roomIdx), roomName)
  local canBindFntList = roomData:GetRoomCanBindList()
  self.canBindFntList = canBindFntList
  ;
  (self.slotPool):HideAll()
  for i = 1, DormUtil:GetBedCount() do
    local fntData = canBindFntList[i]
    local heroId = nil
    if fntData ~= nil then
      heroId = (self.fntHeroIdDic)[fntData]
    end
    local slotItem = (self.slotPool):GetOne()
    slotItem:InitDmCheckInDetailSlot(i, heroId, self._UnbindSlotFunc)
  end
  ;
  (table.sort)(self.heroList, function(a, b)
    -- function num : 0_2_0 , upvalues : self
    local fntDataA = (self.bindHeroIdFntDic)[a.dataId]
    local fntDataB = (self.bindHeroIdFntDic)[b.dataId]
    local binda = fntDataA ~= nil
    local bindb = fntDataB ~= nil
    local inCurRoomA = not binda or fntDataA:GetFntRoom() == self.roomData
    local inCurRoomB = not bindb or fntDataB:GetFntRoom() == self.roomData
    if inCurRoomA ~= inCurRoomB then
      return inCurRoomA
    end
    if binda ~= bindb then
      return bindb
    end
    do return a.dataId < b.dataId end
    -- DECOMPILER ERROR: 9 unprocessed JMP targets
  end
)
  self:_RefillScrollRect(true)
end

UINDmCheckInDetail._UnbindSlot = function(self, index)
  -- function num : 0_3
  local fntData = (self.canBindFntList)[index]
  if fntData == nil then
    return 
  end
  local heroId = (self.fntHeroIdDic)[fntData]
  if heroId == nil or heroId == 0 then
    return 
  end
  self:_UpdBindInfo(fntData, heroId, false)
end

UINDmCheckInDetail._RefillScrollRect = function(self, isRefill)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if isRefill then
    ((self.ui).scrollRect).totalCount = #self.heroList
    ;
    ((self.ui).scrollRect):RefillCells()
  else
    ;
    ((self.ui).scrollRect):RefreshCells()
  end
end

UINDmCheckInDetail._OnInstantiateItem = function(self, go)
  -- function num : 0_5 , upvalues : UINDmCheckInDetailHero
  local item = (UINDmCheckInDetailHero.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.heroItemDic)[go] = item
end

UINDmCheckInDetail._OnChangeItem = function(self, go, index)
  -- function num : 0_6 , upvalues : _ENV
  local item = (self.heroItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local heroData = (self.heroList)[index + 1]
  if heroData == nil then
    error("Can\'t find heroData by index, index = " .. tonumber(index))
  end
  local inCurRoom, inOtherRoom = false, false
  local fntData = (self.bindHeroIdFntDic)[heroData.dataId]
  if fntData:GetFntRoom() ~= self.roomData then
    inCurRoom = fntData == nil
    inOtherRoom = not inCurRoom
    item:InitDmCheckInDetailHero(heroData, inCurRoom, inOtherRoom, self._OnHeroListItemClickFunc)
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UINDmCheckInDetail._OnHeroListItemClick = function(self, heroItem, heroData)
  -- function num : 0_7 , upvalues : _ENV, cs_MessageCommon
  local isAdd = false
  local inCurRoom, inOtherRoom = false, false
  local fntData = (self.bindHeroIdFntDic)[heroData.dataId]
  if fntData == nil then
    isAdd = true
  else
    if fntData:GetFntRoom() == self.roomData then
      inCurRoom = true
      isAdd = false
    else
      inOtherRoom = true
      isAdd = true
    end
  end
  if isAdd then
    local curNum = 0
    do
      local allNum = #self.canBindFntList
      do
        local emptyFnt = nil
        do
          for k,fntData in ipairs(self.canBindFntList) do
            local heroId = (self.fntHeroIdDic)[fntData]
            if heroId > 0 then
              curNum = curNum + 1
            else
              if emptyFnt == nil then
                emptyFnt = fntData
              end
            end
          end
        end
        if allNum <= curNum then
          (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(2028))
          return 
        end
        if inOtherRoom then
          local otherRoomData = fntData.roomData
          local confimFunc = function()
    -- function num : 0_7_0 , upvalues : self, fntData, heroData, emptyFnt
    self:_UpdBindInfo(fntData, heroData.dataId, false)
    self:_UpdBindInfo(emptyFnt, heroData.dataId, true)
  end

          UIManager:ShowWindowAsync(UIWindowTypeID.DormReplaceHero, function(window)
    -- function num : 0_7_1 , upvalues : otherRoomData, heroData, self, confimFunc
    if window == nil then
      return 
    end
    window:InitDmReplaceHero(otherRoomData, heroData, self.roomData, confimFunc)
  end
)
          return 
        end
        do
          self:_UpdBindInfo(emptyFnt, heroData.dataId, true)
        end
        self:_UpdBindInfo(fntData, heroData.dataId, false)
        do return  end
      end
    end
  end
end

UINDmCheckInDetail._UpdBindInfo = function(self, fntData, heroId, bindHero)
  -- function num : 0_8 , upvalues : _ENV
  local bindInfo = (self.bindInfoDic)[fntData]
  local fntRoomData = fntData:GetFntRoom()
  if bindInfo == nil then
    bindInfo = {heroId = heroId, houseId = (self.houseData).id, roomPos = fntRoomData.spos, elemIdx = fntRoomData:GetFntDataIndex(fntData), bindHero = bindHero}
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.bindInfoDic)[fntData] = bindInfo
  end
  bindInfo.heroId = heroId
  bindInfo.bindHero = bindHero
  local newHeroId = bindHero and heroId or 0
  if fntRoomData == self.roomData then
    local index = nil
    for k,fnt in ipairs(self.canBindFntList) do
      if fnt == fntData then
        index = k
        break
      end
    end
    do
      do
        local slotItem = ((self.slotPool).listItem)[index]
        if slotItem ~= nil then
          slotItem:UpdDmCheckInDetailSlot(newHeroId)
        end
        -- DECOMPILER ERROR at PC53: Confused about usage of register: R7 in 'UnsetPending'

        if bindHero then
          (self.bindHeroIdFntDic)[heroId] = fntData
        else
          -- DECOMPILER ERROR at PC56: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.bindHeroIdFntDic)[heroId] = nil
        end
        -- DECOMPILER ERROR at PC58: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (self.fntHeroIdDic)[fntData] = newHeroId
        self:_RefillScrollRect()
      end
    end
  end
end

UINDmCheckInDetail._OnClickLastRoom = function(self)
  -- function num : 0_9
  self:_ChangeRoom(false)
end

UINDmCheckInDetail._OnClickNextRoom = function(self)
  -- function num : 0_10
  self:_ChangeRoom(true)
end

UINDmCheckInDetail._ChangeRoom = function(self, isNext)
  -- function num : 0_11
  local offset = isNext and 1 or -1
  local newIdx = self.roomIdx + offset
  if #self.checkInRoomDataList < newIdx then
    newIdx = 1
  else
    if newIdx < 1 then
      newIdx = #self.checkInRoomDataList
    end
  end
  local roomData = (self.checkInRoomDataList)[newIdx]
  self:_InitRoom(roomData, newIdx)
end

UINDmCheckInDetail._OnClickConfim = function(self)
  -- function num : 0_12
  (self.dmCheckInCtrl):ChangeDmBindInfo(self.bindInfoDic)
end

UINDmCheckInDetail.OnDelete = function(self)
  -- function num : 0_13 , upvalues : _ENV, base
  (self.slotPool):DeleteAll()
  for k,v in pairs(self.heroItemDic) do
    v:Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UINDmCheckInDetail

