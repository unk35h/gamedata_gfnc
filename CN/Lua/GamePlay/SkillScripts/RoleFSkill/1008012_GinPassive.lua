-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1008012 = class("bs_1008012", base)
bs_1008012.config = {buffId_159 = 10080201}
bs_1008012.ctor = function(self)
  -- function num : 0_0
end

bs_1008012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).BJ = true
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["arglist[1]"] = (self.arglist)[1]
  self:AddAfterHealTrigger("bs_1008012_1", 1, self.OnAfterHeal, self.caster, nil, nil, nil, nil, nil, 1008002)
  self:AddAfterAddBuffTrigger("bs_1008012_2", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, nil, nil, eBuffFeatureType.Taunt)
  self:AddBuffDieTrigger("bs_1008012_3", 1, self.OnBuffDie, self.caster, nil, nil, nil, eBuffFeatureType.Taunt)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1008012_4", 1, self.OnAfterBattleStart)
end

bs_1008012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (self.caster):AddRoleProperty(eHeroAttr.attackRange, 5, eHeroAttrType.Origin)
end

bs_1008012.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal)
  -- function num : 0_3 , upvalues : _ENV
  if skill.dataId == 1008002 and sender == self.caster and not isStealHeal then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_159, 1, (self.arglist)[2])
  end
end

bs_1008012.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_4 , upvalues : _ENV
  (self.caster):AddRoleProperty(eHeroAttr.attackRange, -5, eHeroAttrType.Origin)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.caster).recordTable).BJ = false
end

bs_1008012.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_5 , upvalues : _ENV
  (self.caster):AddRoleProperty(eHeroAttr.attackRange, 5, eHeroAttrType.Origin)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.caster).recordTable).BJ = true
end

bs_1008012.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1008012

