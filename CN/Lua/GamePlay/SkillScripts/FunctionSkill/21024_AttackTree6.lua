-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21024 = class("bs_21024", LuaSkillBase)
local base = LuaSkillBase
bs_21024.config = {}
bs_21024.ctor = function(self)
  -- function num : 0_0
end

bs_21024.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_21024_13", 1, self.OnAfterPlaySkill)
end

bs_21024.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and not skill.isCommonAttack then
    local targetlist = LuaSkillCtrl:CallTargetSelect(self, 60, 10)
    if targetlist.Count ~= 0 then
      for i = 0, targetlist.Count - 1 do
        local value = ((targetlist[i]).targetRole).hp * (self.arglist)[1] // 1000
        if (self.caster).skill_intensity * (self.arglist)[2] // 1000 <= value then
          value = (self.caster).skill_intensity * (self.arglist)[2] // 1000
        end
        LuaSkillCtrl:RemoveLife(value, self, (targetlist[i]).targetRole, true, nil, true, true, eHurtType.RealDmg)
      end
    end
  end
end

bs_21024.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21024

