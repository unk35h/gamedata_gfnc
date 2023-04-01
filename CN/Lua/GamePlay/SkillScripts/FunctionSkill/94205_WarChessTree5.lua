-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94205 = class("bs_94205", LuaSkillBase)
local base = LuaSkillBase
bs_94205.config = {buffId = 110061}
bs_94205.ctor = function(self)
  -- function num : 0_0
end

bs_94205.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_94205_13", 1, self.OnAfterPlaySkill)
end

bs_94205.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and (skill.dataId == 5111 or skill.dataId == 5112 or skill.dataId == 5113) then
    local targetlist = LuaSkillCtrl:CallTargetSelect(self, 51, 10)
    if targetlist.Count < 0 then
      return 
    end
    local targetRole = (targetlist[0]).targetRole
    if targetRole.roleType ~= 1 then
      return 
    end
    LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 0, false)
    LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, (self.arglist)[2], ture)
  end
end

bs_94205.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94205

