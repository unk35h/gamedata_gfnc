-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySectorII.Dungeon.Data.SectorIIDungeonData")
local ActivitySectorIIIDungeonData = class("ActivitySectorIIIDungeonData", base)
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
ActivitySectorIIIDungeonData.GetDungeonLevelType = function(self)
  -- function num : 0_0 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).SectorIII
end

ActivitySectorIIIDungeonData.GetDungeonIndex = function(self)
  -- function num : 0_1
  return self.__index
end

ActivitySectorIIIDungeonData.GetWADunRewardRate = function(self)
  -- function num : 0_2
  local sectorIIData = self:GetSectorIIIActivityData()
  local isOpenRate = sectorIIData:SectorIII_IsFarmDouble()
  if not isOpenRate then
    return 1
  end
  return sectorIIData:GetSectorIII_EffiMultRate() + 1
end

ActivitySectorIIIDungeonData.GetSectorIIIActivityData = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local ctrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII)
  if ctrl == nil then
    return nil
  end
  local sectorIII = ctrl:GetSectorIIIAct(self.__actId)
  return sectorIII
end

ActivitySectorIIIDungeonData.GetDunExtraBuffDic = function(self)
  -- function num : 0_4
  local sectorIII = self:GetSectorIIIActivityData()
  if sectorIII == nil then
    return nil
  end
  local actBuffUnlockDic = sectorIII:GetCommonActUnlockedBuffList()
  return actBuffUnlockDic
end

ActivitySectorIIIDungeonData.GetDunExtraDelectedBuffDic = function(self)
  -- function num : 0_5
  local sectorIII = self:GetSectorIIIActivityData()
  if sectorIII == nil then
    return nil
  end
  local actBuffRemoveDic = sectorIII:GetCommonActDelectedBuffList()
  return actBuffRemoveDic
end

ActivitySectorIIIDungeonData.GetCommonActDropData = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local sectorIII = self:GetSectorIIIActivityData()
  local pointMultRateDic = sectorIII:GetSectorIII_PointMultRat()
  local rate = self:GetWADunRewardRate()
  local dropDic = {}
  for itemId,itemNumTable in pairs((self.__ActivityWinterCfg).drop_show) do
    dropDic[itemId] = {}
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (dropDic[itemId]).min = itemNumTable.minValue * rate
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R10 in 'UnsetPending'

    if itemNumTable.maxValue ~= nil then
      (dropDic[itemId]).max = itemNumTable.maxValue * rate
    end
    local pointRate = pointMultRateDic[itemId]
    if pointRate ~= nil then
      pointRate = pointRate / 1000
      for key,value in pairs(dropDic[itemId]) do
        -- DECOMPILER ERROR at PC39: Confused about usage of register: R16 in 'UnsetPending'

        (dropDic[itemId])[key] = (math.floor)(value * (pointRate + 1))
      end
    end
  end
  return dropDic
end

return ActivitySectorIIIDungeonData

