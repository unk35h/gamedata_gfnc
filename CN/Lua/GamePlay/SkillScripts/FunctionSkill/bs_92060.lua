-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92060 = class("bs_92060", LuaSkillBase)
local base = LuaSkillBase
bs_92060.config = {buffId = 2053, buffId2 = 2054}
bs_92060.ctor = function(self)
  -- function num : 0_0
end

bs_92060.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterHurt, "bs_92060_3", 1, self.OnAfterHurt)
end

bs_92060.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target.hp <= 0 and hurt > 0 and sender == self.caster and target.belongNum == 2 then
    local powNum = target.pow * (self.arglist)[1] // 1000
    local skillNum = target.skill_intensity * (self.arglist)[1] // 1000
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, powNum, nil, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId2, skillNum, nil, true)
  end
end

bs_92060.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92060

