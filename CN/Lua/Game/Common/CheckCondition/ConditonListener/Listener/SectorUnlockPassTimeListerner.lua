-- params : ...
-- function num : 0 , upvalues : _ENV
local SectorUnlockPassTimeListerner = class("SectorUnlockPassTimeListerner")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local checkerTypeId = CheckerTypeId.SectorStagePassTm
SectorUnlockPassTimeListerner.ctor = function(self)
  -- function num : 0_0 , upvalues : CheckerGlobalConfig, checkerTypeId, _ENV
  self.__checker = CheckerGlobalConfig[checkerTypeId]
  self.__OnOutCondititonChange = BindCallback(self, self.__OnOutCondititonChange)
  MsgCenter:AddListener(eMsgEventId.SectorStateUpdate, self.__OnOutCondititonChange)
end

SectorUnlockPassTimeListerner.InitListener = function(self, onConditonChangeCallback, removeConditonFunc)
  -- function num : 0_1
  self.onConditonChangeCallback = onConditonChangeCallback
  self.removeConditonFunc = removeConditonFunc
end

SectorUnlockPassTimeListerner.AddNewCondition = function(self, conditonDataDic)
  -- function num : 0_2 , upvalues : _ENV, checkerTypeId
  for listenerId,conditonDataList in pairs(conditonDataDic) do
    for index = #conditonDataList, 1, -1 do
      local paramGoup = conditonDataList[index]
      local unlock = (((self.__checker).Checker).ParamsCheck)(paramGoup)
      if unlock then
        local sectorId = paramGoup[2]
        local passTime = paramGoup[3]
        local ok, outRange = (PlayerDataCenter.sectorStage):CheckSectorPassTmInRange(sectorId, passTime)
        if ok and outRange then
          (self.removeConditonFunc)(checkerTypeId, listenerId, index)
        end
      end
    end
  end
end

SectorUnlockPassTimeListerner.__OnOutCondititonChange = function(self)
  -- function num : 0_3 , upvalues : checkerTypeId
  if self.onConditonChangeCallback ~= nil then
    (self.onConditonChangeCallback)(checkerTypeId)
  end
end

SectorUnlockPassTimeListerner.Delete = function(self)
  -- function num : 0_4 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.SectorStateUpdate, self.__OnOutCondititonChange)
end

return SectorUnlockPassTimeListerner

