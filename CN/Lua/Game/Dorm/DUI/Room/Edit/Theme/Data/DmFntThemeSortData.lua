-- params : ...
-- function num : 0 , upvalues : _ENV
local DmFntThemeSortData = class("DmFntThemeSortData")
local DmThemeSortEnum = require("Game.Dorm.DUI.Room.Edit.Theme.Sort.DmThemeSortEnum")
local eDmFntThemeSortType = DmThemeSortEnum.eDmFntThemeSortType
local _inDmBigRoom, _reverseSort, themeUseableNRateDic = nil, nil, nil
local bigRoomSortFunc = function(a, b)
  -- function num : 0_0 , upvalues : _inDmBigRoom
  if (a.dmFntThemeCfg).only_big == (b.dmFntThemeCfg).only_big then
    return nil
  end
  if _inDmBigRoom then
    return (a.dmFntThemeCfg).only_big
  else
    return not (a.dmFntThemeCfg).only_big
  end
end

local eSortFunc = {[eDmFntThemeSortType.Default] = function(a, b)
  -- function num : 0_1 , upvalues : bigRoomSortFunc, _reverseSort
  local result = bigRoomSortFunc(a, b)
  if result ~= nil then
    return result
  end
  local inSellA, inSellB = a:IsDmFntThemeInSell(), b:IsDmFntThemeInSell()
  if inSellA ~= inSellB then
    if _reverseSort then
      return inSellB
    end
    return inSellA
  end
  if _reverseSort then
    if (a.dmFntThemeCfg).sortord >= (b.dmFntThemeCfg).sortord then
      do return (a.dmFntThemeCfg).sortord == (b.dmFntThemeCfg).sortord end
      do return (b.dmFntThemeCfg).sortord < (a.dmFntThemeCfg).sortord end
      if a.id >= b.id then
        do return not _reverseSort end
        do return b.id < a.id end
        -- DECOMPILER ERROR: 7 unprocessed JMP targets
      end
    end
  end
end
, [eDmFntThemeSortType.Comfort] = function(a, b)
  -- function num : 0_2 , upvalues : bigRoomSortFunc, _reverseSort
  local result = bigRoomSortFunc(a, b)
  if result ~= nil then
    return result
  end
  local comfortA = a:GetDmFntThemeComformt()
  local comfortB = b:GetDmFntThemeComformt()
  if _reverseSort then
    if comfortA >= comfortB then
      do return comfortA == comfortB end
      do return comfortB < comfortA end
      if a.id >= b.id then
        do return not _reverseSort end
        do return b.id < a.id end
        -- DECOMPILER ERROR: 7 unprocessed JMP targets
      end
    end
  end
end
, [eDmFntThemeSortType.UseableRate] = function(a, b)
  -- function num : 0_3 , upvalues : bigRoomSortFunc, themeUseableNRateDic, _reverseSort
  local result = bigRoomSortFunc(a, b)
  if result ~= nil then
    return result
  end
  if not themeUseableNRateDic then
    themeUseableNRateDic = {}
    local useableRateA = themeUseableNRateDic[a.id]
    local useableRateB = themeUseableNRateDic[b.id]
    if useableRateA == nil then
      useableRateA = a:GetDmFntThemeUseableNum() / a:GetDmFntThemeTotalNum()
      themeUseableNRateDic[a.id] = useableRateA
    end
    if useableRateB == nil then
      useableRateB = b:GetDmFntThemeUseableNum() / b:GetDmFntThemeTotalNum()
      themeUseableNRateDic[b.id] = useableRateB
    end
    if _reverseSort then
      if useableRateA >= useableRateB then
        do return useableRateA == useableRateB end
        do return useableRateB < useableRateA end
        if a.id >= b.id then
          do return not _reverseSort end
          do return b.id < a.id end
          -- DECOMPILER ERROR: 7 unprocessed JMP targets
        end
      end
    end
  end
end
}
DmFntThemeSortData.GetDmThemeSortFunc = function(self, inDmBigRoom)
  -- function num : 0_4 , upvalues : _inDmBigRoom, _reverseSort, eSortFunc
  local sortType, isReverse = self:GetDmThemeCurSortType()
  _inDmBigRoom = inDmBigRoom
  _reverseSort = isReverse
  local sortFunc = eSortFunc[sortType]
  return sortFunc
end

DmFntThemeSortData.ClearDmThemeSort = function()
  -- function num : 0_5 , upvalues : _inDmBigRoom, _reverseSort, themeUseableNRateDic
  _inDmBigRoom = nil
  _reverseSort = nil
  themeUseableNRateDic = nil
end

DmFntThemeSortData.ctor = function(self, inBigRoom)
  -- function num : 0_6 , upvalues : eDmFntThemeSortType
  self._sortReverseDic = {}
  self._curSortType = eDmFntThemeSortType.Default
end

DmFntThemeSortData.GetDmThemeCurSortTypeReverse = function(self, sortType)
  -- function num : 0_7
  return (self._sortReverseDic)[sortType] or false
end

DmFntThemeSortData.ChangeDmThemeCurSortTypeReverse = function(self, sortType)
  -- function num : 0_8
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  (self._sortReverseDic)[sortType] = not (self._sortReverseDic)[sortType]
end

DmFntThemeSortData.IsDmThemeCurSortType = function(self, sortType)
  -- function num : 0_9
  do return self._curSortType == sortType end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DmFntThemeSortData.GetDmThemeCurSortType = function(self)
  -- function num : 0_10
  return self._curSortType, (self._sortReverseDic)[self._curSortType]
end

DmFntThemeSortData.SetDmThemeCurSortType = function(self, sortType)
  -- function num : 0_11
  self._curSortType = sortType
end

return DmFntThemeSortData

