-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210603 = class("bs_210603", LuaSkillBase)
local base = LuaSkillBase
bs_210603.config = {buffId_critcore = 210602, buffId_atkspeed = 210604}
bs_210603.ctor = function(self)
  -- function num : 0_0
end

bs_210603.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_210603_1", 1, self.OnAfterPlaySkill, nil, nil)
end

bs_210603.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  local target = (role.recordTable).lastAttackRole
  if target == nil then
    return 
  end
  if skill.isCommonAttack and (skill.maker).belongNum ~= (self.caster).belongNum and (self.caster):GetBuffTier((self.config).buffId_critcore) > 0 and target == self.caster then
    LuaSkillCtrl:CallBuff(self, skill.maker, (self.config).buffId_atkspeed, 1, 60, true)
  end
end

bs_210603.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210603

