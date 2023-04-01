-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6014 = class("bs_6014", LuaSkillBase)
local base = LuaSkillBase
bs_6014.config = {buffId_Taunt = 3002, buffId_fanshang = 601401}
bs_6014.ctor = function(self)
  -- function num : 0_0
end

bs_6014.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_6014_13", 1, self.OnAfterPlaySkill)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultEnd, "bs_6014_14", 99, self.OnHurtResultEnd)
end

bs_6014.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and not skill.isCommonAttack then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_fanshang, 1, (self.arglist)[1])
    local rangeOffset = 1
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, rangeOffset)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        if ((targetList[i]).targetRole).intensity ~= 0 then
          LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId_Taunt, 1, (self.arglist)[1])
        end
      end
    end
  end
end

bs_6014.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  if targetRole ~= self.caster or skill.maker == self.caster then
    return 
  end
  if (skill.maker).hp <= 0 then
    return 
  end
  local returnDmgValue = LuaSkillCtrl:CallFormulaNumber(1000, self.caster, nil, hurtValue)
  if returnDmgValue > 0 then
    LuaSkillCtrl:RemoveLife((self.caster).maxHp * (self.arglist)[3] // 1000, self, skill.maker, true, nil, true, false, eHurtType.RealDmg)
  end
end

bs_6014.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6014

