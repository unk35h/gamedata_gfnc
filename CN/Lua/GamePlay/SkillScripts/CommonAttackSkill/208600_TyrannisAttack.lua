-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_208600 = class("bs_208600", bs_1)
local base = bs_1
bs_208600.config = {effectId_end = 208601, effectId_hit = 208602, radius = 20, spd = 15, 
Hurt_config = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, returndamage_formula = 0}
, effectId_start1 = 208607, effectId_start2 = 208608, effectId_sj = 208602}
bs_208600.config = setmetatable(bs_208600.config, {__index = base.config})
bs_208600.ctor = function(self)
  -- function num : 0_0
end

bs_208600.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_208600.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId)
  -- function num : 0_2 , upvalues : _ENV
  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange) then
    (self.caster):LookAtTarget(target)
    self:CallBack(target)
  end
end

bs_208600.CallBack = function(self, targetRole)
  -- function num : 0_3 , upvalues : _ENV
  local collisionTrigger = BindCallback(self, self.OnCollision)
  local skillEmission = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, targetRole, (self.config).radius, (self.config).spd, eColliderInfluenceType.Enemy, collisionTrigger, nil, nil, nil, true, true, nil)
end

bs_208600.OnCollision = function(self, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  if entity.intensity == 0 and entity.career == 1 then
    return 
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
  LuaSkillCtrl:CallEffect(entity, (self.config).effectId_sj, self)
  local num = ((self.caster).recordTable)["208601_hurt"]
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).Hurt_config, {num})
  skillResult:EndResult()
end

bs_208600.CallSelectExecute = function(self, targetRole)
  -- function num : 0_5 , upvalues : _ENV
  if targetRole == nil or targetRole.hp <= 0 then
    return 
  end
  if targetRole.belongNum ~= (self.caster).belongNum then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).Hurt_config, {(self.arglist)[1]})
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId_hit, self)
  end
end

bs_208600.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208600

