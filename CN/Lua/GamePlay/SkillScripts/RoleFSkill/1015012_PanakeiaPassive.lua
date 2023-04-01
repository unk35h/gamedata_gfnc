-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1015012 = class("bs_1015012", base)
bs_1015012.config = {effectId_heal = 101507, effectId_heal_up = 101511, effectId_p = 101508, buffId_drug = 101502, buffId_drugUp = 101503, buffId_Ult = 101501, 
HealConfig = {baseheal_formula = 101501}
}
bs_1015012.ctor = function(self)
  -- function num : 0_0
end

bs_1015012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1015012_12", 5, self.OnAfterHurt, self.caster)
end

bs_1015012.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and (skill.isCommonAttack or skill.dataId == 101502) and target.belongNum ~= (self.caster).belongNum then
    if (LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[4] or (self.caster):GetBuffTier((self.config).buffId_Ult) > 0) and target:GetBuffTier((self.config).buffId_drug) > 0 then
      local num = 1 - target.attackRange
      local targetlist = LuaSkillCtrl:CallTargetSelect(self, 9, num, target)
      local up = 1000
      if (self.caster):GetBuffTier((self.config).buffId_Ult) > 0 then
        up = 1000 + ((self.caster).recordTable).Ult_pass_up
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_heal_up, self)
      else
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_heal, self)
      end
      if targetlist.Count > 0 then
        local heal_Count = targetlist.Count
        for i = 0, targetlist.Count - 1 do
          local _role = (targetlist[i]).targetRole
          if _role.intensity == 0 then
            heal_Count = heal_Count - 1
          end
        end
        if heal_Count > 0 then
          for i = 0, targetlist.Count - 1 do
            local _role = (targetlist[i]).targetRole
            if _role.intensity ~= 0 then
              local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, _role)
              LuaSkillCtrl:HealResult(skillResult, (self.config).HealConfig, {1, up})
              skillResult:EndResult()
            end
          end
        end
      end
    end
    do
      if (self.caster):GetBuffTier((self.config).Ult) > 0 then
        LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_drugUp, 1, (self.arglist)[6])
      else
        LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_drug, 1, (self.arglist)[6])
      end
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_p, self)
    end
  end
end

bs_1015012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1015012

