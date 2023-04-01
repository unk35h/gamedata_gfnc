-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101801 = class("bs_101801", LuaSkillBase)
local base = LuaSkillBase
bs_101801.config = {buffId_love = 101802, buffId_s = 101805, buffId_passive = 101806, buffId_Taunt = 3002, buffId_wd = 101807, effectId_pass = 101805, 
heal_config = {baseheal_formula = 3021}
, weaponLv = 0}
bs_101801.ctor = function(self)
  -- function num : 0_0
end

bs_101801.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  if LuaSkillCtrl.IsInTDBattle and LuaSkillCtrl.cluaSkillCtrl ~= nil then
    return 
  end
  self:AddAfterHurtTrigger("bs_101801_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self:AddBuffDieTrigger("bs_101801_2", 1, self.OnBuffDie, nil, nil, (self.config).buffId_love)
  self.time = 0
end

bs_101801.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack then
    self.time = self.time + 1
  end
  if (self.arglist)[1] <= self.time and LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange) then
    self.time = 0
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_pass, self)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_love, 1, (self.arglist)[2])
  end
end

bs_101801.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_3 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_love and target:GetBuffTier((self.config).buffId_wd) > 0 then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_wd, 0)
  end
end

bs_101801.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_101801

