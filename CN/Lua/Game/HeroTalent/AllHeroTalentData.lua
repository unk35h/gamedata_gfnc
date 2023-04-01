-- params : ...
-- function num : 0 , upvalues : _ENV
local AllHeroTalentData = class("AllHeroTalentData")
local HeroTalentData = require("Game.HeroTalent.HeroTalentData")
AllHeroTalentData.ctor = function(self)
  -- function num : 0_0
  self._modelCfgDic = {}
  self._dic = {}
end

AllHeroTalentData.InitHeroTalent = function(self)
  -- function num : 0_1 , upvalues : _ENV, HeroTalentData
  if (ConfigData.buildinConfig).HeroTalentForbid then
    return false
  end
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Talent) then
    return 
  end
  local talentCfg = ConfigData.hero_talent
  for heroId,cfg in pairs(talentCfg) do
    local hero = (PlayerDataCenter.heroDic)[heroId]
    if hero ~= nil and (ConfigData.game_config).heroTalentUnlockLevel <= hero.level then
      local data = (HeroTalentData.New)(cfg)
      -- DECOMPILER ERROR at PC36: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self._dic)[heroId] = data
      hero:BindHeroDataTalent(data)
    end
  end
end

AllHeroTalentData.TryCreateAndBindHeroTalentByHeroId = function(self, heroId)
  -- function num : 0_2 , upvalues : _ENV, HeroTalentData
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Talent) then
    return 
  end
  local cfg = (ConfigData.hero_talent)[heroId]
  if cfg == nil then
    return 
  end
  local hero = (PlayerDataCenter.heroDic)[heroId]
  if hero == nil or hero.level < (ConfigData.game_config).heroTalentUnlockLevel then
    return 
  end
  local data = (HeroTalentData.New)(cfg)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._dic)[heroId] = data
  hero:BindHeroDataTalent(data)
end

AllHeroTalentData.UpdateHeroTalent = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  if msg == nil then
    return 
  end
  for heroId,talent in pairs(msg) do
    local heroTalentData = (self._dic)[heroId]
    if heroTalentData == nil then
      error("talent is nil, heroId is " .. tostring(heroId))
    else
      heroTalentData:UpdateHeroTalent(talent)
      MsgCenter:Broadcast(eMsgEventId.HeroTalentLvUp, heroId)
    end
  end
end

AllHeroTalentData.SetHeroTalentBranch = function(self, heroId, nodeId, branchId)
  -- function num : 0_4 , upvalues : _ENV
  local heroTalentData = (self._dic)[heroId]
  if heroTalentData == nil then
    return 
  end
  heroTalentData:SetHeroTalentBranchInData(nodeId, branchId)
  MsgCenter:Broadcast(eMsgEventId.HeroTalentLvUp, heroId)
end

AllHeroTalentData.GetHeroTalent = function(self, heroId)
  -- function num : 0_5
  if self._dic == nil then
    return nil
  end
  return (self._dic)[heroId]
end

AllHeroTalentData.HeroTalentIsSystemOpen = function(self, heroId)
  -- function num : 0_6 , upvalues : _ENV
  if (ConfigData.buildinConfig).HeroTalentForbid then
    return false
  end
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Talent) then
    return false
  end
  do return (ConfigData.hero_talent)[heroId] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

AllHeroTalentData.GetHeroTalentModelCfg = function(self, modelId)
  -- function num : 0_7 , upvalues : _ENV
  local cfg = (self._modelCfgDic)[modelId]
  if cfg ~= nil then
    return cfg
  end
  local path = "HeroTalentModelConfig.hero_talent_model_" .. tostring(modelId)
  local ok, err = pcall(function()
    -- function num : 0_7_0 , upvalues : cfg, _ENV, path, self, modelId
    cfg = require(path)
    cfg.modelPath = path
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self._modelCfgDic)[modelId] = cfg
    return true
  end
)
  if not ok then
    error("Can\'t get HeroTalentModelCfg, path = " .. path .. ",\n" .. tostring(err))
    return nil
  end
  return cfg
end

AllHeroTalentData.RemoveHeroTalentModelCfg = function(self, modelId)
  -- function num : 0_8 , upvalues : _ENV
  local cfg = (self._modelCfgDic)[modelId]
  if cfg == nil then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._modelCfgDic)[modelId] = nil
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (package.loaded)[cfg.modelPath] = nil
end

return AllHeroTalentData

