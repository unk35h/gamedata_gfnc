-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101801 = require("GamePlay.SkillScripts.RoleSkill.101801_FlorencePassive")
local bs_101804 = class("bs_101804", bs_101801)
local base = bs_101801
bs_101804.config = {weaponLv = 1}
bs_101804.config = setmetatable(bs_101804.config, {__index = base.config})
bs_101804.ctor = function(self)
  -- function num : 0_0
end

bs_101804.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  (LuaSkillBase.InitSkill)(self, isMidwaySkill)
  if LuaSkillCtrl.IsInTDBattle and LuaSkillCtrl.cluaSkillCtrl ~= nil then
    return 
  end
  self:AddAfterHurtTrigger("bs_101804_3", 1, self.OnAfterHurt, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self:AddBuffDieTrigger("bs_101804_2", 1, self.OnBuffDie, nil, nil, (self.config).buffId_love)
  self.time = 0
end

bs_101804.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack then
    self.time = self.time + 1
    if (self.arglist)[1] <= self.time and LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange) then
      self.time = 0
      local time = (self.arglist)[2] + (self.arglist)[4]
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_love, 1, time)
      if target:GetBuffTier((self.config).buffId_love) == 0 then
        LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_s, 1, (self.arglist)[7])
      end
    end
  end
  do
    if sender:GetBuffTier((self.config).buffId_love) > 0 and skill.isCommonAttack and not isMiss and target ~= nil and target.hp > 0 then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_Taunt, 1, (self.arglist)[5], nil, sender)
    end
  end
end

bs_101804.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101804

