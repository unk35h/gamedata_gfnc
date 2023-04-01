-- params : ...
-- function num : 0 , upvalues : _ENV
local CharDungeonConsumeListerner = class("CharDungeonConsumeListerner")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local checkerTypeId = CheckerTypeId.CharDungeonConsume
CharDungeonConsumeListerner.ctor = function(self)
  -- function num : 0_0 , upvalues : CheckerGlobalConfig, checkerTypeId, _ENV
  self.__checker = CheckerGlobalConfig[checkerTypeId]
  self.__OnOutCondititonChange = BindCallback(self, self.__OnOutCondititonChange)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityUpdate, self.__OnOutCondititonChange)
end

CharDungeonConsumeListerner.InitListener = function(self, onConditonChangeCallback, removeConditonFunc)
  -- function num : 0_1
  self.onConditonChangeCallback = onConditonChangeCallback
  self.removeConditonFunc = removeConditonFunc
end

CharDungeonConsumeListerner.AddNewCondition = function(self, conditonDataDic)
  -- function num : 0_2 , upvalues : _ENV, checkerTypeId
  for listenerId,conditonDataList in pairs(conditonDataDic) do
    for index = #conditonDataList, 1, -1 do
      local paramGoup = conditonDataList[index]
      local unlock = (((self.__checker).Checker).ParamsCheck)(paramGoup)
      if unlock then
        (self.removeConditonFunc)(checkerTypeId, listenerId, index)
      end
    end
  end
end

CharDungeonConsumeListerner.__OnOutCondititonChange = function(self)
  -- function num : 0_3 , upvalues : checkerTypeId
  if self.onConditonChangeCallback ~= nil then
    (self.onConditonChangeCallback)(checkerTypeId)
  end
end

CharDungeonConsumeListerner.Delete = function(self)
  -- function num : 0_4 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityUpdate, self.__OnOutCondititonChange)
end

return CharDungeonConsumeListerner

