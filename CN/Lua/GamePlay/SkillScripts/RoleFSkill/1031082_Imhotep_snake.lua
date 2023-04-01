-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1031082 = class("bs_1031082", LuaSkillBase)
local base = LuaSkillBase
bs_1031082.config = {
HurtConfig = {hit_formula = 0, basehurt_formula = 10152, crit_formula = 0, crithur_ratio = 0}
}
bs_1031082.ctor = function(self)
  -- function num : 0_0
end

bs_1031082.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1031082_4", 1, self.OnAfterHurt, self.caster)
end

bs_1031082.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack == true then
    local cskill = ((self.caster).recordTable)["2_caster_cskill"]
    local heal_num = ((self.caster).recordTable)["2_skill_int"] * ((self.caster).recordTable)["2_Atk_arg_ex"] // 1000
    if heal_num ~= nil then
      LuaSkillCtrl:CallHealWithCSkill(heal_num, cskill, self.caster, true)
    end
  end
end

bs_1031082.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1031082

