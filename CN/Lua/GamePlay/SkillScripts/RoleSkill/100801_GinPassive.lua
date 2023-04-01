-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100801 = class("bs_100801", LuaSkillBase)
local base = LuaSkillBase
bs_100801.config = {buffId_159 = 100802}
bs_100801.ctor = function(self)
  -- function num : 0_0
end

bs_100801.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).BJ = true
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["arglist[1]"] = (self.arglist)[1]
  self:AddAfterHealTrigger("bs_100801_1", 1, self.OnAfterHeal, self.caster, nil, nil, nil, nil, nil, 100800)
  self:AddAfterAddBuffTrigger("bs_100801_2", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, nil, nil, eBuffFeatureType.Taunt)
  self:AddBuffDieTrigger("bs_100801_3", 1, self.OnBuffDie, self.caster, nil, nil, nil, eBuffFeatureType.Taunt)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_100801_4", 1, self.OnAfterBattleStart)
  self.RoleAttackRange = (self.caster).attackRange
end

bs_100801.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local num = 10 - (self.caster).attackRange
  ;
  (self.caster):AddRoleProperty(eHeroAttr.attackRange, num, eHeroAttrType.Origin)
end

bs_100801.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal)
  -- function num : 0_3 , upvalues : _ENV
  if skill.dataId == 100800 and sender == self.caster and not isStealHeal then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_159, 1, (self.arglist)[2])
  end
end

bs_100801.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_4 , upvalues : _ENV
  local num = self.RoleAttackRange - (self.caster).attackRange
  ;
  (self.caster):AddRoleProperty(eHeroAttr.attackRange, num, eHeroAttrType.Origin)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.caster).recordTable).BJ = false
end

bs_100801.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_5 , upvalues : _ENV
  local num = 10 - (self.caster).attackRange
  ;
  (self.caster):AddRoleProperty(eHeroAttr.attackRange, num, eHeroAttrType.Origin)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.caster).recordTable).BJ = true
end

bs_100801.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100801

