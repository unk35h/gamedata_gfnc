-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104501 = class("bs_104501", LuaSkillBase)
local base = LuaSkillBase
bs_104501.config = {}
bs_104501.ctor = function(self)
  -- function num : 0_0
end

bs_104501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_104501_1", 10, self.OnAfterBattleStart)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).EnergyTire = (self.arglist)[1]
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).DeriveHurt = (self.arglist)[2]
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).CriticalRate = (self.arglist)[3]
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).CriticaldamageRate = (self.arglist)[4]
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).AttackEnergy = 0
end

bs_104501.OnAfterBattleStart = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.caster).recordTable).currentTier = 0
end

bs_104501.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104501

