-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101908 = class("bs_101908", LuaSkillBase)
local base = LuaSkillBase
bs_101908.config = {effectId_boom = 101910, effectId_boom_skill = 101911, 
Aoe = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, hurt_configId = 3}
bs_101908.ctor = function(self)
  -- function num : 0_0
end

bs_101908.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weaponLv3 = true
  self:AddLuaTrigger(eSkillLuaTrigger.FernDragonHurt, self.DragonHurt)
end

bs_101908.DragonHurt = function(self, target, skill)
  -- function num : 0_2 , upvalues : _ENV
  if skill == false then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_boom, self)
  else
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_boom_skill, self)
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target.targetRole, (self.config).Aoe)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurt_configId, {(self.arglist)[1]}, true)
  skillResult:EndResult()
end

bs_101908.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101908

