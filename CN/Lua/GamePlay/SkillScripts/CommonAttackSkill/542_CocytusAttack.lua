-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_542 = class("bs_542", bs_1)
local base = bs_1
bs_542.config = {buffId_110 = 204203, buffId_111 = 204204, buffId_112 = 104008, effectId_trail = 204200, effectId_trail_ex = 204209, select_id = 9, select_range2 = 20, 
hurt_config = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, crithur_ratio = 0, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
}
bs_542.config = setmetatable(bs_542.config, {__index = base.config})
bs_542.ctor = function(self)
  -- function num : 0_0
end

bs_542.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.num_buff = 1
end

bs_542.SkillEventFunc = function(self, configData, effect, eventId, target)
  -- function num : 0_2 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    if configData.audioId5 ~= nil then
      LuaSkillCtrl:PlayAuSource(target.targetRole, configData.audioId5)
    end
    if configData.Imp == true then
      LuaSkillCtrl:PlayAuHit(self, target)
    end
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResult(self, skillResult, generalHurtConfig)
    skillResult:EndResult()
    self:CallBuff(target.targetRole)
  end
end

bs_542.CallBuff = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  local arg = ((self.caster).recordTable).arg
  if self.num_buff == 1 then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_110, 1, arg)
    self.num_buff = 2
    return 
  end
  if self.num_buff == 2 then
    LuaSkillCtrl:CallBuffRepeated(self, target, (self.config).buffId_111, 1, arg, false, self.OnBuffExecute)
    self.num_buff = 3
    return 
  end
  if self.num_buff == 3 then
    LuaSkillCtrl:CallBuffRepeated(self, target, (self.config).buffId_112, 1, arg, false, self.OnBuffExecute2)
    self.num_buff = 1
    return 
  end
end

bs_542.OnBuffExecute = function(self, buff, targetRole)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  LuaSkillCtrl:PlayAuHit(self, targetRole)
  local skillValue = 100 * buff.tier
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {skillValue}, true)
  skillResult:EndResult()
end

bs_542.OnBuffExecute2 = function(self, buff, targetRole)
  -- function num : 0_5 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  LuaSkillCtrl:PlayAuHit(self, targetRole)
  local skillValue2 = 100 * buff.tier
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {skillValue2}, true)
  skillResult:EndResult()
end

bs_542.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
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

return bs_542

