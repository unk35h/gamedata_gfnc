-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105201 = class("bs_105201", LuaSkillBase)
local base = LuaSkillBase
bs_105201.config = {effectId_start = 105205, effectId_heal = 105207, buffId_passive = 105201, buffId_power = 105202, heal_resultId = 3, heal_resultId_over = 5, selectId_passive = 6}
bs_105201.ctor = function(self)
  -- function num : 0_0
end

bs_105201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_105201_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_105201_4", 1, self.OnAfterHurt, nil, nil, nil, (self.caster).belongNum)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_105201_5", 1, self.BeforeEndBattle)
end

bs_105201.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId_passive, 10)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = (targetList[i]).targetRole
      LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_passive, 1)
    end
  end
end

bs_105201.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, isRealDmg, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= nil and target.hp > 0 and target.belongNum == (self.caster).belongNum and target:GetBuffTier((self.config).buffId_passive) > 0 then
    local limit = target.maxHp * (self.arglist)[1] // 1000
    if target.hp < limit then
      LuaSkillCtrl:DispelBuff(target, (self.config).buffId_passive, 0)
      local tier = (self.caster):GetBuffTier((self.config).buffId_power)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HealResultWithConfig(self, skillResult, (self.config).heal_resultId, {(self.arglist)[2] * tier})
      skillResult:EndResult()
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_heal, self)
    end
  end
end

bs_105201.BeforeEndBattle = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local tier = (self.caster):GetBuffTier((self.config).buffId_power)
  if tier > 0 then
    local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId_passive, 10)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = (targetList[i]).targetRole
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
        LuaSkillCtrl:HealResultWithConfig(self, skillResult, (self.config).heal_resultId_over, {(self.arglist)[3] * tier})
        skillResult:EndResult()
      end
    end
  else
  end
  do
    if tier <= 0 then
    end
  end
end

bs_105201.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105201

