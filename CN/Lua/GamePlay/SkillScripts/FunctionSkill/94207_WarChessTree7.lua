-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94207 = class("bs_94207", LuaSkillBase)
local base = LuaSkillBase
bs_94207.config = {buffId = 110063}
bs_94207.ctor = function(self)
  -- function num : 0_0
end

bs_94207.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_94207_13", 1, self.OnAfterPlaySkill)
end

bs_94207.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and (skill.dataId == 5011 or skill.dataId == 5012 or skill.dataId == 5013 or skill.dataId == 5014) then
    local targetRole = (skill.selectRoles)[0]
    LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 0, false)
    LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, (self.arglist)[2], ture)
  end
end

bs_94207.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94207

