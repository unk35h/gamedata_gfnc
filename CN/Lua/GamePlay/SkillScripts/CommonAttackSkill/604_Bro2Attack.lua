-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_604 = class("bs_604", bs_1)
local base = bs_1
bs_604.config = {effectId_skill = 60401, radius = 10, spd = 15, 
Hurt_config = {hit_formula = 0, basehurt_formula = 502, crit_formula = 0, returndamage_formula = 0}
, effectId_sj = 208602, buffIdBro = 60401}
bs_604.config = setmetatable(bs_604.config, {__index = base.config})
bs_604.ctor = function(self)
  -- function num : 0_0
end

bs_604.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_604_1", 1, self.OnAfterBattleStart)
end

bs_604.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 19, 0)
  if targetList.Count > 0 and ((targetList[0]).targetRole):GetBuffTier((self.config).buffIdBro) == 0 then
    LuaSkillCtrl:CallBuff(self, (targetList[0]).targetRole, (self.config).buffIdBro, 1, nil)
  end
end

bs_604.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId)
  -- function num : 0_3 , upvalues : _ENV
  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange) then
    (self.caster):LookAtTarget(target)
    self:CallBack(target)
  end
end

bs_604.CallBack = function(self, targetRole)
  -- function num : 0_4 , upvalues : _ENV
  local cusEffect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_skill, self)
  local collisionTrigger = BindCallback(self, self.OnCollision)
  LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, targetRole, (self.config).radius, 10, eColliderInfluenceType.Enemy, collisionTrigger, nil, nil, cusEffect, true, true, nil)
end

bs_604.OnCollision = function(self, collider, index, entity)
  -- function num : 0_5 , upvalues : _ENV
  if entity.intensity == 0 and entity.career == 1 then
    return 
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
  LuaSkillCtrl:CallEffect(entity, (self.config).effectId_sj, self)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).Hurt_config, {1})
  skillResult:EndResult()
end

bs_604.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_604

