-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105101 = class("bs_105101", LuaSkillBase)
local base = LuaSkillBase
bs_105101.config = {buffId_lowHeal = 3018, buffId_claw = 1051012, selectId = 9, selectRange = 10, 
realHurt = {basehurt_formula = 3000}
}
bs_105101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnNascitaAttack, self.OnNascitaAttack)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_105101_1", 1, self.OnAfterBattleStart)
end

bs_105101.OnAfterBattleStart = function(self)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.caster).recordTable).MaxAttackCount = (self.arglist)[1]
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).SplashAttackCount = (self.arglist)[2]
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).SplashAttackLow = (self.arglist)[6]
end

bs_105101.OnNascitaAttack = function(self, target, sender, skill)
  -- function num : 0_2
  if sender.hp <= 0 then
    return 
  end
  self:MaxHpDownBuff(target)
end

bs_105101.MaxHpDownBuff = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if target.hp <= 0 or (target.recordTable).WillowPic == true then
    return 
  end
  LuaSkillCtrl:CallRealDamage(self, target, nil, (self.config).realHurt, {(self.arglist)[4]}, true)
  LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_lowHeal, 1)
  LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_claw, 1)
end

bs_105101.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105101

