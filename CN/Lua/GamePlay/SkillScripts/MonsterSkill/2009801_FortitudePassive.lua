-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_2009801 = class("bs_2009801", LuaSkillBase)
local base = LuaSkillBase
bs_2009801.config = {hurtConfigId = 2, effectId_1 = 2009809, buffId_1 = 2009801}
bs_2009801.ctor = function(self)
  -- function num : 0_0
end

bs_2009801.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_2009801_4", 1, self.OnAfterHurt, nil, self.caster)
  self:AddAfterAddBuffTrigger("bs_2009801_8", 1, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).buffId_1)
  self:AddLuaTrigger(eSkillLuaTrigger.OnFortitudeSkill, self.OnFortitudeSkill, self)
end

bs_2009801.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, isRealDmg, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if LuaSkillCtrl:CallRange(1, 1000) < (self.arglist)[1] then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_1, self)
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 0)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = (targetList[i]).targetRole
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_1, 1)
      end
    end
  end
end

bs_2009801.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  if (self.arglist)[3] <= target:GetBuffTier((self.config).buffId_1) then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {(self.arglist)[4]})
    skillResult:EndResult()
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_1, (self.arglist)[3])
  end
end

bs_2009801.OnFortitudeSkill = function(self, target, num)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_1, num)
end

bs_2009801.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_2009801

