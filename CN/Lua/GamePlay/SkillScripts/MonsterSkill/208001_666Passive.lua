-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208001 = class("bs_208001", LuaSkillBase)
local base = LuaSkillBase
bs_208001.config = {buffId_passive = 208001, shieldFormula = 3001, buffId_Boss = 3017}
bs_208001.ctor = function(self)
  -- function num : 0_0
end

bs_208001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnSixAttack, self.OnSixAttack)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_208001_2", 1, self.OnAfterBattleStart)
  self:AddLuaTrigger(eSkillLuaTrigger.OnMonsterStageCreat, self.OnMonsterStageCreat)
  if (self.caster).roleDataId == 20059 then
    self:CallCasterWait(75)
  end
  self.time = 0
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).pass = false
end

bs_208001.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local breakComponent = (self.caster):GetBreakComponent()
  if breakComponent == nil then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Boss, 1, nil, true)
  end
end

bs_208001.OnMonsterStageCreat = function(self, roleEnity)
  -- function num : 0_3 , upvalues : _ENV
  if roleEnity == self.caster then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Boss, 1, nil, true)
  end
end

bs_208001.OnSixAttack = function(self, target, sender, skill)
  -- function num : 0_4 , upvalues : _ENV
  if self.time == 0 and ((self.caster).recordTable).pass == true then
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_passive, (self.arglist)[3])
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.caster).recordTable).pass = false
  end
  self.time = self.time + 1
  if (self.arglist)[1] <= self.time then
    self.time = 0
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.caster).recordTable).pass = true
    local shieldValue = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).shieldFormula, self.caster, self.caster, self, (self.arglist)[2], (self.arglist)[2])
    if shieldValue > 0 then
      LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, shieldValue)
    end
  end
end

bs_208001.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208001

