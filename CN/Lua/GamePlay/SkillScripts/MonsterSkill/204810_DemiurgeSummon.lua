-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204810 = class("bs_204810", LuaSkillBase)
local base = LuaSkillBase
bs_204810.config = {
middleMonsterId = {25, 26, 27, 28}
, buffId = 1033, effectId = 10264, effectId1 = 10263, startAnimID = 1001, maxEnemyNum = 8, maxSummonNum = 10, buffId_196 = 196, buffId_1033 = 1033, skill_time = 18, maxHpPer = 100, powPer = 500, audioId1 = 300, monsterTime = 3, timeDuration = 15, totalTime = 30}
bs_204810.ctor = function(self)
  -- function num : 0_0
end

bs_204810.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, nil, true)
  self.index = 1
  self.totalTime = (self.config).totalTime * 15
  self.timeValue = self.totalTime
  if (self.caster).roleDataId ~= 113 then
    LuaSkillCtrl:SetGameScoreAcitve(2, true)
    LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
    local arriveCallBack = BindCallback(self, self.OnArriveAction)
    LuaSkillCtrl:StartTimer(nil, (self.config).timeDuration, arriveCallBack, self, -1)
    local timeCallBack = BindCallback(self, self.TimeUp)
    LuaSkillCtrl:StartTimer(nil, self.totalTime, timeCallBack)
  end
end

bs_204810.PlaySkill = function(self, data)
  -- function num : 0_2
  self:CallBack()
end

bs_204810.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetList.Count < (self.config).maxEnemyNum then
    self:CallCasterWait((self.config).skill_time)
    local moveAttackTrigger = BindCallback(self, self.OnMoveAttackTrigger)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).startAnimID, 1, (self.config).skill_time, moveAttackTrigger)
  end
  do
    if (self.caster).roleDataId == 113 then
      self:CallCasterWait((self.config).skill_time)
      local moveAttackTrigger = BindCallback(self, self.OnMoveAttackTrigger)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).startAnimID, 1, (self.config).skill_time, moveAttackTrigger)
    end
  end
end

bs_204810.OnMoveAttackTrigger = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
  if (self.caster).roleDataId == 113 then
    if self.index > 4 then
      self.index = 1
    end
    for i = 1, (self.config).monsterTime do
      if i == 1 then
        self:CallBack2(1, 1)
      else
        if i == 2 then
          self:CallBack2(2, 2)
        else
          if i == 3 then
            self:CallBack2(1, 3)
          end
        end
      end
    end
    LuaSkillCtrl:CallBuff(self, self.caster, 2048021, 1, 10, true)
    self.index = self.index + 1
  else
    for i = 1, (self.config).monsterTime do
      local gridData = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
      if gridData == nil then
        return 
      end
      LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
      self:CallBack1(gridData.x, gridData.y)
    end
  end
end

bs_204810.CallBack1 = function(self, x, y)
  -- function num : 0_5 , upvalues : _ENV
  local gridData = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  if gridData == nil then
    return 
  end
  x = gridData.x
  y = gridData.y
  local target = LuaSkillCtrl:GetTargetWithGrid(gridData.x, gridData.y)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  if self.index > 4 then
    self.index = 1
  end
  local summoner = LuaSkillCtrl:CreateSummoner(self, ((self.config).middleMonsterId)[self.index], x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.config).maxHpPer // 1000)
  summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.intensity, (self.caster).intensity * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
  summoner:SetAsRealEntity(1)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
end

bs_204810.CallBack2 = function(self, x, y)
  -- function num : 0_6 , upvalues : _ENV
  local target = LuaSkillCtrl:GetTargetWithGrid(x, y)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  local summoner = LuaSkillCtrl:CreateSummoner(self, ((self.config).middleMonsterId)[self.index], x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.config).maxHpPer // 2000)
  summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.intensity, (self.caster).intensity * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
  summoner:SetAsRealEntity(1)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
end

bs_204810.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

bs_204810.OnArriveAction = function(self)
  -- function num : 0_8 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = (math.max)(0, self.timeValue // 15)
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
end

bs_204810.TimeUp = function(self)
  -- function num : 0_9 , upvalues : _ENV
  LuaSkillCtrl:ForceEndBattle(true)
end

bs_204810.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  (base.LuaDispose)(self)
  self.index = nil
  self.totalTime = nil
  self.timeValue = nil
end

return bs_204810

