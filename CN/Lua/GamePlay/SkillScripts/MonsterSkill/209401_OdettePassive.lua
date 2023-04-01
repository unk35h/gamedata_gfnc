-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209401 = class("bs_209401", LuaSkillBase)
local base = LuaSkillBase
bs_209401.config = {buffId_Boss = 3017}
bs_209401.ctor = function(self)
  -- function num : 0_0
end

bs_209401.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_209401_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_209401_2", 1, self.OnAfterHurt, nil, self.caster)
  self.hpRate = nil
  self.maxHP = (self.caster).maxHp
end

bs_209401.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and hurt > 0 then
    self.hpRate = (self.caster)._curHp * 1000 // self.maxHP
    if self.hpRate <= 500 then
      LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnOdetteHalfHp, target, self.caster, self.cskill)
    end
  end
end

bs_209401.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local breakComponent = (self.caster):GetBreakComponent()
  if breakComponent == nil then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Boss, 1, nil, true)
  end
end

bs_209401.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209401

