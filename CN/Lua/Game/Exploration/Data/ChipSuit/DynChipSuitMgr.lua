-- params : ...
-- function num : 0 , upvalues : _ENV
local DynChipSuitMgr = class("DynChipSuitMgr")
local DynChipSuit = require("Game.Exploration.Data.ChipSuit.DynChipSuit")
DynChipSuitMgr.ctor = function(self, dynplayer)
  -- function num : 0_0
  self.__chipSuitDic = {}
  self.__chipSuitList = {}
  self.__dynplayer = dynplayer
end

DynChipSuitMgr.CreateSuitWithChips = function(chipList)
  -- function num : 0_1 , upvalues : _ENV, DynChipSuit
  local tagDic = {}
  for _,chipData in pairs(chipList) do
    local tagId = chipData:GetChipFuncTag()
    if not tagDic[tagId] then
      do
        tagDic[tagId] = (tagId == 0 or 0) + 1
        -- DECOMPILER ERROR at PC15: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC15: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  local chipSuitDic = {}
  for tagId,count in pairs(tagDic) do
    local chipSuit = (DynChipSuit.New)(tagId, count)
    chipSuitDic[tagId] = chipSuit
  end
  return chipSuitDic
end

local ChipSuitSortFunc = function(suit1, suit2)
  -- function num : 0_2
  local c1 = suit1:GetChipSuitCount()
  local c2 = suit2:GetChipSuitCount()
  if c2 >= c1 then
    do return c1 == c2 end
    do return suit1.tagId < suit2.tagId end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

DynChipSuitMgr.UpdateAllChipSuit = function(self, chipList)
  -- function num : 0_3 , upvalues : _ENV, DynChipSuitMgr, ChipSuitSortFunc
  while #self.__chipSuitList > 0 do
    (table.remove)(self.__chipSuitList)
  end
  self.__chipSuitDic = (DynChipSuitMgr.CreateSuitWithChips)(chipList)
  for k,chipSuit in pairs(self.__chipSuitDic) do
    chipSuit:UpdateChipSuitEffector(self.__dynplayer)
    ;
    (table.insert)(self.__chipSuitList, chipSuit)
  end
  ;
  (table.sort)(self.__chipSuitList, ChipSuitSortFunc)
  MsgCenter:Broadcast(eMsgEventId.OnEpChipSuitUpdate)
end

DynChipSuitMgr.UpdateChipSuitDiff = function(self, chipDel, chipAdd)
  -- function num : 0_4 , upvalues : _ENV, DynChipSuit, ChipSuitSortFunc
  local updateTag = {}
  for chipId,_ in pairs(chipDel) do
    local chipCfg = (ConfigData.chip)[chipId]
    local tagId = chipCfg.fun_tag
    if tagId ~= 0 then
      local chipSuit = (self.__chipSuitDic)[tagId]
      chipSuit:AddChipSuitCount(-1)
      updateTag[tagId] = true
    end
  end
  for chipId,_ in pairs(chipAdd) do
    local chipCfg = (ConfigData.chip)[chipId]
    local tagId = chipCfg.fun_tag
    if tagId ~= 0 then
      local chipSuit = (self.__chipSuitDic)[tagId]
      if chipSuit == nil then
        chipSuit = (DynChipSuit.New)(tagId, 1)
        -- DECOMPILER ERROR at PC39: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (self.__chipSuitDic)[tagId] = chipSuit
      else
        chipSuit:AddChipSuitCount(1)
      end
      updateTag[tagId] = true
    end
  end
  for tagId,_ in pairs(updateTag) do
    local chipSuit = (self.__chipSuitDic)[tagId]
    if chipSuit:GetChipSuitCount() > 0 then
      chipSuit:UpdateChipSuitEffector(self.__dynplayer)
    else
      chipSuit:ClearChipSuitEffector(self.__dynplayer)
      -- DECOMPILER ERROR at PC65: Confused about usage of register: R10 in 'UnsetPending'

      ;
      (self.__chipSuitDic)[tagId] = nil
    end
  end
  do
    while #self.__chipSuitList > 0 do
      (table.remove)(self.__chipSuitList)
    end
    for tagId,chipSuit in pairs(self.__chipSuitDic) do
      (table.insert)(self.__chipSuitList, chipSuit)
    end
    ;
    (table.sort)(self.__chipSuitList, ChipSuitSortFunc)
    for _,chipSuit in ipairs(self.__chipSuitList) do
      chipSuit:UpdateChipSuitTotalQty(self.__dynplayer)
    end
    MsgCenter:Broadcast(eMsgEventId.OnEpChipSuitUpdate)
  end
end

DynChipSuitMgr.TempAddChipSuit = function(self, chipData)
  -- function num : 0_5 , upvalues : DynChipSuit
  local tagId = chipData:GetChipFuncTag()
  if tagId ~= 0 then
    local chipSuit = (self.__chipSuitDic)[tagId]
    if chipSuit == nil then
      chipSuit = (DynChipSuit.New)(tagId, 1)
      -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (self.__chipSuitDic)[tagId] = chipSuit
    else
      chipSuit:AddChipSuitCount(1)
    end
    chipSuit:UpdateChipSuitEffector(self.__dynplayer)
  end
end

DynChipSuitMgr.TempSubChipSuit = function(self, chipData, needClear)
  -- function num : 0_6 , upvalues : _ENV
  local tagId = chipData:GetChipFuncTag()
  if tagId ~= 0 then
    local chipSuit = (self.__chipSuitDic)[tagId]
    if chipSuit == nil then
      error("try del null chip suit,tagId:" .. tostring(tagId))
      return 
    end
    chipSuit:AddChipSuitCount(-1)
    if chipSuit:GetChipSuitCount() > 0 then
      chipSuit:UpdateChipSuitEffector(self.__dynplayer)
    else
      chipSuit:ClearChipSuitEffector(self.__dynplayer)
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

      if needClear then
        (self.__chipSuitDic)[tagId] = nil
      end
    end
  end
end

DynChipSuitMgr.ExecuteAllSuitChipForList = function(self, heroList, dynplayer)
  -- function num : 0_7 , upvalues : _ENV
  for k,chipSuit in pairs(self.__chipSuitDic) do
    chipSuit:ExecuteSuitChipForList(heroList, dynplayer)
  end
end

DynChipSuitMgr.GetChipSuitListData = function(self)
  -- function num : 0_8
  return self.__chipSuitList
end

DynChipSuitMgr.GetChipTagIdCount = function(self, tagId)
  -- function num : 0_9 , upvalues : _ENV
  local chipSuit = (self.__chipSuitDic)[tagId]
  if chipSuit ~= nil then
    return chipSuit:GetChipSuitCount(), chipSuit:GetChipSuitMaxCount()
  end
  local chipTagCfg = (ConfigData.chip_tag)[tagId]
  return 0, chipTagCfg.chip_max_count
end

DynChipSuitMgr.GetChipSuitTotalQty = function(self, tagId)
  -- function num : 0_10
  local chipSuit = (self.__chipSuitDic)[tagId]
  local totalQty = chipSuit ~= nil and chipSuit:GetTotalQty() or 0
  return totalQty
end

DynChipSuitMgr.RemoveAllChipSuitTemp = function(self)
  -- function num : 0_11 , upvalues : _ENV
  for _,chipSuit in pairs(self.__chipSuitList) do
    chipSuit:ClearChipSuitEffector(self.__dynplayer)
  end
end

return DynChipSuitMgr

