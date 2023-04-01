-- params : ...
-- function num : 0 , upvalues : _ENV
local AdjCustomPresetData = class("AdjCustomPresetData")
AdjCustomPresetData.InitPresetData = function(self, teamId)
  -- function num : 0_0
  self._teamId = teamId
  self._heroList = {}
end

AdjCustomPresetData.UpdatePresetMsg = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV
  self._useL2d = msg.useL2D
  self._bgId = msg.bgId
  self._teamName = msg.name
  if self._useL2d and msg.mainHero ~= nil then
    local mainHeroId = (msg.mainHero).heroId
    local mainHeroSkinId = (msg.mainHero).skinId
    if mainHeroSkinId == 0 then
      mainHeroSkinId = ((ConfigData.hero_data)[mainHeroId]).default_skin
    end
    local skinCfg = (ConfigData.skin)[mainHeroSkinId]
    self._useL2d = skinCfg ~= nil and skinCfg.live2d_level > 0
  end
  self._heroDic = {}
  ;
  (table.removeall)(self._heroList)
  if msg.mainHero ~= nil then
    (table.insert)(self._heroList, (msg.mainHero).heroId)
    self:__RecordData(msg.mainHero, true)
  end
  if msg.minorHero ~= nil then
    (table.insert)(self._heroList, (msg.minorHero).heroId)
    self:__RecordData(msg.minorHero, false)
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

AdjCustomPresetData.__RecordData = function(self, single, isMain)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  if (self._heroDic)[single.heroId] == nil then
    (self._heroDic)[single.heroId] = {}
  end
  local data = (self._heroDic)[single.heroId]
  data.dataId = single.heroId
  data.skinId = single.skinId
  if single.posX ~= 0 or single.posY ~= 0 then
    data.pos = {single.posX / 1000, single.posY / 1000}
  else
    data.pos = nil
  end
  if single.heroSize > 0 then
    data.size = single.heroSize / 1000
  else
    data.size = nil
  end
  data.isMain = isMain
  if isMain then
    data.isL2d = self._useL2d
  end
end

AdjCustomPresetData.SetAdjPresetName = function(self, name)
  -- function num : 0_3
  self._teamName = name
end

AdjCustomPresetData.GetAdjPresetTeamId = function(self)
  -- function num : 0_4
  return self._teamId
end

AdjCustomPresetData.GetAdjPresetUseL2d = function(self)
  -- function num : 0_5
  return self._useL2d
end

AdjCustomPresetData.GetAdjPresetBgId = function(self)
  -- function num : 0_6
  return self._bgId
end

AdjCustomPresetData.GetAdjPresetElemData = function(self, heroId)
  -- function num : 0_7
  return (self._heroDic)[heroId]
end

AdjCustomPresetData.GetAdjPresetElemMain = function(self)
  -- function num : 0_8
  return (self._heroDic)[(self._heroList)[1]]
end

AdjCustomPresetData.GetAdjPresetHeroList = function(self)
  -- function num : 0_9
  return self._heroList
end

AdjCustomPresetData.GetAdjPresetName = function(self)
  -- function num : 0_10
  return self._teamName
end

return AdjCustomPresetData

