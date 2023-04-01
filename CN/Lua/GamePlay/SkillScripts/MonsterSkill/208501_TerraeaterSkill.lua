-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208501 = class("bs_208501", LuaSkillBase)
local base = LuaSkillBase
bs_208501.config = {buffId_151 = 3019, skill_time = 38, skill_speed = 1, start_time = 13, end_time = 16, sum_time = 15, buffId_170 = 170, startAnimId = 1008, effectId_skill = 208501, effectId_hit = 208502, effectId_xs = 208506, monsterId = 52, maxHpPer = 50, powPer = 1000, 
hurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, crithur_ratio = 0}
}
bs_208501.ctor = function(self)
  -- function num : 0_0
end

bs_208501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_208501_1", 1, self.OnAfterHurt, nil, nil, nil, (self.caster).belongNum)
end

bs_208501.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  local grid_dict = LuaSkillCtrl:FindEmptyGridsWithinRange((self.caster).x, (self.caster).y, 10)
  if grid_dict ~= nil then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
    self:CallCasterWait((self.config).start_time + (self.config).end_time + (self.config).sum_time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).startAnimId, (self.config).skill_speed, (self.config).start_time, attackTrigger)
  end
end

bs_208501.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.arglist)[2])
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[2])
  local targetrole = nil
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 10002, 20)
  if targetList ~= 0 then
    for i = 0, targetList.Count - 1 do
      if (targetList[i]).targetRole ~= nil and ((targetList[i]).targetRole).belongNum ~= eBattleRoleBelong.neutral and not LuaSkillCtrl:RoleContainsBuffFeature((targetList[i]).targetRole, eBuffFeatureType.CtrlImmunity) then
        targetrole = (targetList[i]).targetRole
        break
      end
    end
  end
  do
    if targetrole ~= nil then
      LuaSkillCtrl:CallEffect(targetrole, (self.config).effectId_hit, self)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetrole)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[1]})
      skillResult:EndResult()
      local grid = LuaSkillCtrl:GetGridWithRole(targetrole)
      local target_grid = (LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y))
      local grid_t = nil
      local grid_dict = LuaSkillCtrl:FindEmptyGridsWithinRange((self.caster).x, (self.caster).y, 10)
      if grid_dict ~= nil or grid_dict.Count >= 1 then
        local minDis = 99
        for i = 0, grid_dict.Count - 1 do
          local grid1 = grid_dict[i]
          if grid1 ~= grid then
            local dis1 = LuaSkillCtrl:GetGridsDistance(grid1.x, grid1.y, (self.caster).x, (self.caster).y)
            if dis1 < minDis then
              minDis = dis1
              grid_t = grid1
            end
          end
        end
      end
      do
        do
          if self.eff_skill ~= nil then
            (self.eff_skill):Die()
            self.eff_skill = nil
          end
          LuaSkillCtrl:CallPhaseMoveWithoutTurnAndAllowCcd(self, targetrole, grid_t.x, grid_t.y, 7, 3020, 1)
          self:summoner(grid)
          LuaSkillCtrl:StartTimer(self, (self.config).sum_time, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, 1009)
  end
)
          LuaSkillCtrl:StartTimer(self, (self.config).sum_time, function()
    -- function num : 0_3_1 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, 1009)
  end
)
          do return  end
        end
      end
    end
  end
end

bs_208501.summoner = function(self, grid)
  -- function num : 0_4 , upvalues : _ENV
  if self.summonerEntity ~= nil then
    return 
  end
  local x = grid.x
  local y = grid.y
  local target = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
  local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.arglist)[3] // 1000)
  summoner:SetAttr(eHeroAttr.def, (self.caster).def * (self.arglist)[4] // 1000)
  summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res * (self.arglist)[4] // 1000)
  summoner:SetAsRealEntity(1)
  self.summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
  if self.summonerEntity == nil then
    return 
  end
  self.eff_skill = LuaSkillCtrl:CallEffect(self.summonerEntity, (self.config).effectId_skill, self)
  LuaSkillCtrl:CallRoleAction(self.summonerEntity, 1008)
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], function(entity)
    -- function num : 0_4_0 , upvalues : _ENV, self
    if entity == nil or entity.hp <= 0 then
      return 
    end
    LuaSkillCtrl:RemoveLife(entity.maxHp + 1, self, entity, true, nil, false, true, eHurtType.RealDmg)
    LuaSkillCtrl:CallRoleAction(entity, 1009)
    if self.eff_skill ~= nil then
      (self.eff_skill):Die()
      self.eff_skill = nil
    end
    LuaSkillCtrl:CallEffect(entity, (self.config).effectId_xs, self)
    self.summonerEntity = nil
  end
, self.summonerEntity)
end

bs_208501.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_5 , upvalues : _ENV
  if target == self.summonerEntity and target.hp >= 0 then
    local hurtNum = hurt
    LuaSkillCtrl:RemoveLife(hurtNum, self, self.caster, false, nil, true, false)
    if target.hp <= 0 then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
      LuaSkillCtrl:StopShowSkillDurationTime(self)
      if self.eff_skill ~= nil then
        (self.eff_skill):Die()
        self.eff_skill = nil
      end
      if self.summonerEntity ~= nil then
        LuaSkillCtrl:CallEffect(self.summonerEntity, (self.config).effectId_xs, self)
        self.summonerEntity = nil
      end
    end
  end
end

bs_208501.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  if self.summonerEntity ~= nil then
    LuaSkillCtrl:RemoveLife((self.summonerEntity).maxHp + 1, self, self.summonerEntity, true, nil, false, true, eHurtType.RealDmg)
    self.summonerEntity = nil
  end
  if self.eff_skill ~= nil then
    (self.eff_skill):Die()
    self.eff_skill = nil
  end
end

bs_208501.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  (base.LuaDispose)(self)
  self.summonerEntity = nil
  if self.eff_skill ~= nil then
    (self.eff_skill):Die()
    self.eff_skill = nil
  end
end

return bs_208501

