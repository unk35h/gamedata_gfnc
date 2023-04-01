-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106601 = class("bs_106601", LuaSkillBase)
local base = LuaSkillBase
bs_106601.config = {configId = 2, buffId_Back = 106602, buffId_ding = 106603}
bs_106601.ctor = function(self)
  -- function num : 0_0
end

bs_106601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnErikaAttackEx, self.OnErikaAttack, self)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).arglist1 = (self.arglist)[1]
end

bs_106601.OnErikaAttack = function(self, target)
  -- function num : 0_2 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[2]})
  skillResult:EndResult()
  local x = target.x
  local y = target.y
  LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_Back, 1, 3)
  LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_ding, 1, 20)
  if target.x == x and target.y == y then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[3]})
    skillResult:EndResult()
  end
end

bs_106601.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106601

