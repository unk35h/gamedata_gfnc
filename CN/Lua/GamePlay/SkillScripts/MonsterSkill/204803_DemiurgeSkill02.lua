-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204803 = class("bs_204803", LuaSkillBase)
local base = LuaSkillBase
bs_204803.config = {actionId_start = 1020, actionId_loop = 1023, actionId_end = 1024, action_speed = 1, effectId_endhurt = 2048031, effectId_start = 2048033, effectId_loop = 2048034, effectId_end = 2048035, start_time = 15, protect_time = 3, buffId_stifle = 2048031, buffId_target = 2048037, buffId_SuperArmor = 2048032, buffId_CannotSelect = 2048033, buffId_LockCD = 2048034, buffId_SummonerSign = 2048035, buffId_SummonerHealdecrease = 2048038, buffId_SuperArmorTencle = 2048036, buffignoretype = 5, findGridRange = 1, selectId = 10002, selectRange = 20, MonsterId = 30, 
realDamage = {basehurt_formula = 502, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
}
bs_204803.ctor = function(self)
  -- function num : 0_0
end

bs_204803.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_204803_1", 10, self.OnRoleDie)
end

bs_204803.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:AbandonSkillCdAutoReset(true)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId, (self.config).selectrange)
  if targetList == nil or targetList.Count <= 0 then
    return 
  end
  local grid = nil
  local findTarget = targetList.count
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      if (targetList[i]).targetRole ~= nil then
        local target = (targetList[i]).targetRole
        local cantChoose = LuaSkillCtrl:RoleContainsBuffFeature(self.caster, (self.config).buffignoretype)
        if cantChoose ~= true then
          grid = LuaSkillCtrl:FindEmptyGridAroundRole(target)
          if grid ~= nil then
            self:callSummoner((self.config).MonsterId, grid, target)
            LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_target, 1, (self.arglist)[2] + (self.config).start_time, true)
            ;
            (self.caster):LookAtTarget(targetList[i])
            self:CallCasterWait((self.config).start_time)
            local stifletarget = BindCallback(self, self.stifle, target, data)
            LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).start_time, stifletarget)
            self:EndSkillAndCallNext()
            break
          end
        end
      end
    end
  end
end

bs_204803.EndSkillAndCallNext = function(self)
  -- function num : 0_3
  if self.caster == nil then
    return 
  end
  self:CancleCasterWait()
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  self:CallNextBossSkill()
end

bs_204803.stifle = function(self, target, data)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_stifle, 1, (self.arglist)[2], true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_SuperArmor, 1, (self.arglist)[2], true)
end

bs_204803.callSummoner = function(self, monsterId, grid, target)
  -- function num : 0_5 , upvalues : _ENV
  local tentacleHP = (self.arglist)[1] * (self.caster).maxHp // 1000
  local tentacleAliveTime = (self.arglist)[2] + (self.config).start_time
  local recordTable = {HP = tentacleHP, aliveTime = tentacleAliveTime, actionTarget = target, creater = self.caster}
  local summoner = LuaSkillCtrl:CreateSummoner(self, monsterId, grid.x, grid.y)
  summoner:SetAttr(eHeroAttr.maxHp, tentacleHP)
  summoner:SetAsRealEntity(1)
  summoner:SetRecordTable(recordTable)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
  LuaSkillCtrl:CallBuff(self, summonerEntity, (self.config).buffId_SummonerHealdecrease, 1, tentacleAliveTime, true)
  LuaSkillCtrl:CallBuff(self, summonerEntity, (self.config).buffId_SummonerSign, 1, tentacleAliveTime, true)
  LuaSkillCtrl:CallBuff(self, summonerEntity, (self.config).buffId_SuperArmorTencle, 1)
end

bs_204803.OnRoleDie = function(self, killer, role)
  -- function num : 0_6 , upvalues : _ENV
  local maker = self.caster
  local target = (role.recordTable).actionTarget
  local tencleACreater = (role.recordTable).creater
  local deadRoleSign = (role.recordTable).DemiurgeTentacleA
  local tencleASign = 2058
  if role.roleType == eBattleRoleType.realSummoner and tencleACreater == maker and deadRoleSign == tencleASign then
    self:CancleCasterWait()
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_CannotSelect, 1, true)
    self:endskill(target)
  end
end

bs_204803.endskill = function(self, target)
  -- function num : 0_7 , upvalues : _ENV
  local skillEnd = target:GetBuffTier((self.config).buffId_target)
  if skillEnd < 1 then
    local realHurt = target.maxHp * (self.arglist)[3] // 1000
    if realHurt <= 0 then
      realHurt = 1
    end
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_endhurt, self)
    LuaSkillCtrl:CallRealDamage(self, target, nil, (self.config).realDamage, {realHurt}, true)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_CannotSelect, 1, true)
    return 
  else
    do
      local dispelbuffs = BindCallback(self, self.dispelEffectBuff, target)
      LuaSkillCtrl:StartTimer(self, (self.config).protect_time, dispelbuffs)
      do return  end
    end
  end
end

bs_204803.dispelEffectBuff = function(self, target)
  -- function num : 0_8 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_SuperArmor, 1, true)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_CannotSelect, 1, true)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_LockCD, 1, true)
  LuaSkillCtrl:DispelBuff(target, (self.config).buffId_target, 1, true)
  LuaSkillCtrl:DispelBuff(target, (self.config).buffId_stifle, 1, true)
end

bs_204803.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204803

