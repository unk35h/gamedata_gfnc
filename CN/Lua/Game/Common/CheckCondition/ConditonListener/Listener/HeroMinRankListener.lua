-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroMinRankListener = class("HeroMinRankListener")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local checkerTypeId = CheckerTypeId.MinHeroStar
HeroMinRankListener.ctor = function(self)
  -- function num : 0_0 , upvalues : CheckerGlobalConfig, checkerTypeId, _ENV
  self.__checker = CheckerGlobalConfig[checkerTypeId]
  self.__OnOutCondititonChangeCallback = BindCallback(self, self.__OnOutCondititonChange)
  self.__HeroUpdateCallback = BindCallback(self, self.__HeroUpdate)
  MsgCenter:AddListener(eMsgEventId.OnHeroRankChange, self.__OnOutCondititonChangeCallback)
  MsgCenter:AddListener(eMsgEventId.UpdateHero, self.__HeroUpdateCallback)
end

HeroMinRankListener.InitListener = function(self, onConditonChangeCallback, removeConditonFunc)
  -- function num : 0_1
  self.onConditonChangeCallback = onConditonChangeCallback
  self.removeConditonFunc = removeConditonFunc
end

HeroMinRankListener.AddNewCondition = function(self, conditonDataDic)
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

HeroMinRankListener.__OnOutCondititonChange = function(self)
  -- function num : 0_3 , upvalues : checkerTypeId
  if self.onConditonChangeCallback ~= nil then
    (self.onConditonChangeCallback)(checkerTypeId)
  end
end

HeroMinRankListener.__HeroUpdate = function(self, heroUpdate, newHero)
  -- function num : 0_4
  if newHero then
    self:__OnOutCondititonChange()
  end
end

HeroMinRankListener.Delete = function(self)
  -- function num : 0_5 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.OnHeroRankChange, self.__OnOutCondititonChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.UpdateHero, self.__HeroUpdateCallback)
end

return HeroMinRankListener

