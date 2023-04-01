-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94201 = class("bs_94201", LuaSkillBase)
local base = LuaSkillBase
bs_94201.config = {}
bs_94201.ctor = function(self)
  -- function num : 0_0
end

bs_94201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_94201_13", 1, self.OnAfterPlaySkill)
end

bs_94201.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and (skill.dataId == 5031 or skill.dataId == 50310 or skill.dataId == 5032 or skill.dataId == 5033) then
    local targetlist = LuaSkillCtrl:CallTargetSelect(self, 31, 10)
    if targetlist.Count < 0 then
      return 
    end
    local targetRole = (targetlist[0]).targetRole
    if targetRole.roleType ~= 1 then
      return 
    end
    local Shieldvalue = targetRole.def * (self.arglist)[1] // 1000
    LuaSkillCtrl:AddRoleShield(targetRole, eShieldType.Normal, Shieldvalue)
  end
end

bs_94201.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94201

