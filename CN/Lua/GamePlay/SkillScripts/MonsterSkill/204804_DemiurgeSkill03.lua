-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204804 = class("bs_204804", LuaSkillBase)
local base = LuaSkillBase
bs_204804.config = {buffId_165 = 165, actionId = 1105, action_speed = 1, start_time = 15, findGridRange = 3, buffId_63 = 63, SummonerId = 31, effect_jifei = 204813, 
hurt_config = {hit_formula = 0, basehurt_formula = 10076, crit_formula = 0}
, nextSkillId = 204803}
bs_204804.ctor = function(self)
  -- function num : 0_0
end

bs_204804.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_204804.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:AbandonSkillCdAutoReset(true)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  local attackTrigger = BindCallback(self, self.Summon, targetList)
  self:CallCasterWait((self.config).start_time + 1)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
end

bs_204804.Summon = function(self, targetList)
  -- function num : 0_3 , upvalues : _ENV
  if targetList.Count <= 0 then
    return 
  end
  local index = 0
  LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_3_0 , upvalues : targetList, index, self
    local targetRole = (targetList[index]).targetRole
    self:CallSummoner(targetRole)
    index = index + 1
  end
, nil, targetList.Count - 1, 1)
  self:CancleCasterWait()
  self:CallNextBossSkill()
end

bs_204804.CallSummoner = function(self, targetRole)
  -- function num : 0_4 , upvalues : _ENV
  if targetRole.hp > 0 and targetRole.intensity > 0 then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, nil, false)
    skillResult:EndResult()
    local x = targetRole.x
    local y = targetRole.y
    local isOverlap = false
    local tempRole = LuaSkillCtrl:GetRoleWithPos(x, y)
    if tempRole ~= targetRole then
      isOverlap = true
    end
    LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId_165, 1, (self.arglist)[2])
    LuaSkillCtrl:CallEffect(targetRole, (self.config).effect_jifei, self)
    local maxRange = (self.config).findGridRange
    local grid = nil
    for tempRange = 1, maxRange do
      grid = LuaSkillCtrl:FindEmptyGridWithinRange(targetRole, tempRange)
      if grid ~= nil then
        if isOverlap then
          x = grid.x
          y = grid.y
          isOverlap = false
        else
          LuaSkillCtrl:CallPhaseMove(self, targetRole, grid.x, grid.y, 5, (self.config).buffId_63)
          break
        end
      end
    end
    do
      if grid == nil then
        grid = LuaSkillCtrl:FindEmptyGrid()
        if grid == nil then
          self:CancleCasterWait()
          self:CallNextBossSkill()
          return 
        end
        if isOverlap then
          x = grid.x
          y = grid.y
          isOverlap = false
          grid = nil
        end
        if grid == nil then
          grid = LuaSkillCtrl:FindEmptyGrid()
        end
        LuaSkillCtrl:CallPhaseMove(self, targetRole, grid.x, grid.y, 5, (self.config).buffId_63)
      end
      local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).SummonerId, x, y)
      summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.arglist)[3] // 1000)
      summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.arglist)[4] // 1000)
      summoner:SetAttr(eHeroAttr.intensity, (self.caster).intensity * (self.arglist)[4] // 1000)
      summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
      summoner:SetAsRealEntity(1)
      local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
      LuaSkillCtrl:CallRoleAction(summonerEntity, 1002, 1)
    end
  end
end

bs_204804.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_204804.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_204804

