-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206501 = class("bs_206501", LuaSkillBase)
local base = LuaSkillBase
bs_206501.config = {buffId_crime = 206501, buffId_crime2 = 206502, buffId_bati = 206800, buffId_sueyoiSpecialAttack = 1045002}
bs_206501.ctor = function(self)
  -- function num : 0_0
end

bs_206501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_206501_1", 1, self.OnAfterBattleStart)
  self:AddSetHurtTrigger("bs_206501_2", 1, self.OnSetHurt, nil, nil, nil, (self.caster).belongNum)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).crime = true
  ;
  (self.caster):AddRoleProperty(eHeroAttr.cd_reduce, 1000, eHeroAttrType.Extra)
end

bs_206501.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local breakComponent = (self.caster):GetBreakComponent()
  if breakComponent == nil then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_bati, 1, nil, true)
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_crime, 1, nil, true)
end

bs_206501.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.target ~= self.caster and ((context.target).recordTable).punish == true and not LuaSkillCtrl:RoleContainsBuffFeature(self.caster, 16) then
    local ReducedHurt = context.hurt * 500 // 1000
    if (context.sender):GetBuffTier((self.config).buffId_sueyoiSpecialAttack) > 0 then
      ReducedHurt = self:SueyoiSpecialAttackHurt(context)
    end
    if ReducedHurt > 0 then
      context.hurt = context.hurt - ReducedHurt
      LuaSkillCtrl:RemoveLife(ReducedHurt, self, self.caster, true, nil, true, true, eHurtType.RealDmg)
    end
  end
end

bs_206501.SueyoiSpecialAttackHurt = function(self, context)
  -- function num : 0_4 , upvalues : _ENV
  local skillRatio = (context.sender).skill_intensity * ((context.sender).recordTable).DeriveHurt * (1000 + (context.sender).damage_increase - (context.target).injury_reduce) // 1000 // 1000
  local hurt = LuaSkillCtrl:CallFormulaNumber(9994, context.sender, context.sender, skillRatio)
  return hurt
end

return bs_206501

