-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204201 = class("bs_204201", LuaSkillBase)
local base = LuaSkillBase
bs_204201.config = {buffId_110 = 204203, buffId_111 = 204204, buffId_112 = 104008, buffId_66 = 66, buffId_170 = 170, effectId = 204206, effectId2 = 204207, effectId_buff1 = 204203, effectId_buff2 = 204204, effectId_buff3 = 204205, hurt_delay = 10, effectHitId = 10571, 
HurtConfig = {hit_formula = 0, crit_formula = 0, correct_formula = 9989, basehurt_formula = 10077}
, 
hurt_config1 = {basehurt_formula = 3010, hit_formula = 0, crit_formula = 0, correct_formula = 9989, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
, select_id = 9, select_range = 0, select_range2 = 20, start_time = 0, end_time = 60, startAnimId = 1002, endAnimId2 = 100, endAnimDelay = 5, endAnimDelay = 5, audioId1 = 419}
bs_204201.ctor = function(self)
  -- function num : 0_0
end

bs_204201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_204201_7", 1, self.OnAfterAddBuff)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).arg = (self.arglist)[4]
end

bs_204201.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  do
    if buff.dataId == (self.config).buffId_110 then
      local restTier = target:GetBuffTier((self.config).buffId_110)
      if restTier >= 6 then
        LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_66, 1, 30)
        LuaSkillCtrl:DispelBuff(target, (self.config).buffId_110, 0, true)
      end
    end
    if buff.dataId == (self.config).buffId_111 and target:GetBuffTier((self.config).buffId_111) >= 4 then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      local skillValue = 1500
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config1, {skillValue}, true)
      LuaSkillCtrl:DispelBuff(target, (self.config).buffId_111, 0)
      skillResult:EndResult()
    end
  end
end

bs_204201.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_3 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_id, (self.config).select_range)
  if targetList ~= nil and targetList.Count > 0 and targetList[0] ~= nil then
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
    self:CallCasterWait((self.config).start_time + (self.config).end_time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).startAnimId, 1, (self.config).start_time, attackTrigger)
  end
end

bs_204201.OnAttackTrigger = function(self, data)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(self, 25, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self, nil, nil, nil, true)
    local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_id, (self.config).select_range)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, (targetList[i]).targetRole)
        LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId_110, (self.arglist)[3], (self.arglist)[4])
        LuaSkillCtrl:CallBuffRepeated(self, (targetList[i]).targetRole, (self.config).buffId_111, (self.arglist)[3], (self.arglist)[4], false, self.OnBuffExecute)
        LuaSkillCtrl:CallBuffRepeated(self, (targetList[i]).targetRole, (self.config).buffId_112, (self.arglist)[3], (self.arglist)[4], false, self.OnBuffExecute2)
        LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig)
        skillResult:EndResult()
        LuaSkillCtrl:CallEffect((targetList[i]).targetRole, (self.config).effectId_buff1, self, nil, nil, nil, true)
        LuaSkillCtrl:CallEffect((targetList[i]).targetRole, (self.config).effectId_buff2, self, nil, nil, nil, true)
        LuaSkillCtrl:CallEffect((targetList[i]).targetRole, (self.config).effectId_buff3, self, nil, nil, nil, true)
      end
    end
  end
)
end

bs_204201.OnBuffExecute = function(self, buff, targetRole)
  -- function num : 0_5 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  local skillValue2 = 100 * buff.tier
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config1, {skillValue2}, true)
  skillResult:EndResult()
end

bs_204201.OnBuffExecute2 = function(self, buff, targetRole)
  -- function num : 0_6 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  local skillVlue3 = 100 * buff.tier
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config1, {skillVlue3}, true)
  skillResult:EndResult()
end

bs_204201.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_id, (self.config).select_range2)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local buffrole = (targetList[i]).targetRole
      if buffrole.hp > 0 then
        LuaSkillCtrl:DispelBuff(buffrole, (self.config).buffId_110, 1, true)
        LuaSkillCtrl:DispelBuff(buffrole, (self.config).buffId_111, 1, true)
        LuaSkillCtrl:DispelBuff(buffrole, (self.config).buffId_112, 1, true)
      end
    end
  end
end

return bs_204201

