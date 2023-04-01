-- params : ...
-- function num : 0 , upvalues : _ENV
local PlayerLevelListerner = class("PlayerLevelListerner")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local checkerTypeId = CheckerTypeId.PlayerLevel
PlayerLevelListerner.ctor = function(self)
  -- function num : 0_0 , upvalues : CheckerGlobalConfig, checkerTypeId, _ENV
  self.__checker = CheckerGlobalConfig[checkerTypeId]
  self.__OnOutCondititonChange = BindCallback(self, self.__OnOutCondititonChange)
  MsgCenter:AddListener(eMsgEventId.UpdatePlayerLevel, self.__OnOutCondititonChange)
  self.__minPlayerLevel = math.maxinteger
end

PlayerLevelListerner.InitListener = function(self, onConditonChangeCallback, removeConditonFunc)
  -- function num : 0_1
  self.onConditonChangeCallback = onConditonChangeCallback
  self.removeConditonFunc = removeConditonFunc
end

PlayerLevelListerner.AddNewCondition = function(self, conditonDataDic)
  -- function num : 0_2 , upvalues : _ENV, checkerTypeId
  self.__minPlayerLevel = math.maxinteger
  for listenerId,conditonDataList in pairs(conditonDataDic) do
    for index = #conditonDataList, 1, -1 do
      local paramGoup = conditonDataList[index]
      local unlock = (((self.__checker).Checker).ParamsCheck)(paramGoup)
      if unlock then
        (self.removeConditonFunc)(checkerTypeId, listenerId, index)
      else
        self.__minPlayerLevel = (math.min)(self.__minPlayerLevel, paramGoup[1])
      end
    end
  end
end

PlayerLevelListerner.__OnOutCondititonChange = function(self)
  -- function num : 0_3 , upvalues : _ENV, checkerTypeId
  if self.__minPlayerLevel <= PlayerDataCenter.playerLevel then
    self.__minPlayerLevel = math.maxinteger
    if self.onConditonChangeCallback ~= nil then
      (self.onConditonChangeCallback)(checkerTypeId)
    end
  end
end

PlayerLevelListerner.Delete = function(self)
  -- function num : 0_4 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.UpdatePlayerLevel, self.__OnOutCondititonChange)
end

return PlayerLevelListerner

