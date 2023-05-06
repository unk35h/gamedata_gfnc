-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106701 = class("bs_106701", LuaSkillBase)
local base = LuaSkillBase
bs_106701.config = {buffId_tr = 106702, buffId_lx = 106701, buffId_jl = 106703, def_formula = 9996, selectId_pass = 5, HurtConfigId = 30, 
hurt_config = {hit_formula = 0, basehurt_formula = 106705, def_formula = 106703, crit_formula = 0, crithur_ratio = 0, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0, hurt_type = 0}
, HurtConfigId = 30}
bs_106701.ctor = function(self)
  -- function num : 0_0
end

bs_106701.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_106701_3", 2, self.OnAfterAddBuff, self.caster, nil, nil, nil, (self.config).buffId_tr)
  self:AddBuffDieTrigger("bs_106701_4", 1, self.OnBuffDie, nil, nil, (self.config).buffId_lx)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106701_Roll"] = (self.arglist)[2]
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106701_arg2"] = (self.arglist)[3]
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106701_time"] = (self.arglist)[7]
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106701_break"] = (self.arglist)[1]
end

bs_106701.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_tr and target ~= nil and target.hp > 0 and target.belongNum == eBattleRoleBelong.enemy then
    local num = target:GetBuffTier((self.config).buffId_tr)
    LuaSkillCtrl:CallBuffRepeated(self, target, (self.config).buffId_lx, num, (self.arglist)[7], false, self.OnBuffExecute)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_jl, 1, (self.arglist)[7] + 1)
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_tr, 0, true)
  end
end

bs_106701.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= nil then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_jl, 0, true)
  end
end

bs_106701.OnBuffExecute = function(self, buff, targetRole)
  -- function num : 0_4 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  local hurt = buff.tier * (self.arglist)[4]
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigId, {(self.arglist)[1], hurt})
  skillResult:EndResult()
end

bs_106701.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106701

