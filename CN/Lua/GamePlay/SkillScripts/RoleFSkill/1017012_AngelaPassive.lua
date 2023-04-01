-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1017012 = class("bs_1017012", base)
bs_1017012.config = {buffId_cdSpeed = 10170101, effectId = 101702}
bs_1017012.ctor = function(self)
  -- function num : 0_0
end

bs_1017012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_1017012_2", 1, self.OnAfterPlaySkill)
end

bs_1017012.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum ~= (self.caster).belongNum and role ~= self.caster and skill.isCommonAttack ~= true then
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_cdSpeed, 1)
    LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  end
end

bs_1017012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1017012

