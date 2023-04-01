-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102501 = require("GamePlay.SkillScripts.RoleSkill.102501_TwigsPassive")
local bs_102506 = class("bs_102506", bs_102501)
local base = bs_102501
bs_102506.config = {weaponLv = 3, buffId_CH2 = 102505, effectId_skill = 102516}
bs_102506.config = setmetatable(bs_102506.config, {__index = base.config})
bs_102506.ctor = function(self)
  -- function num : 0_0
end

bs_102506.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  (LuaSkillBase.InitSkill)(self, isMidwaySkill)
  self:AddBuffDieTrigger("bs_102501_5", 99, self.OnBuffDie, nil, 2, (self.config).buffId_CH)
  self:AddAfterHurtTrigger("bs_102501_3", 90, self.OnAfterHurt, self.caster)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["102501_weaponLv"] = (self.config).weaponLv
  self:AddOnRoleDieTrigger("bs_102506_2", 1, self.OnRoleDie)
end

bs_102506.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and target.belongNum ~= (self.caster).belongNum and isTriggerSet ~= true and skill.skillType == eBattleSkillLogicType.Original then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_CH, 1)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_CH2, 1)
  end
end

bs_102506.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  if role:GetBuffTier((self.config).buffId_CH2) > 0 and role.hp == 0 and role ~= nil then
    local num = role:GetBuffTier((self.config).buffId_CH2)
    local num1, num2 = (math.modf)(num / 2)
    local num_t = num1
    if num2 ~= 0 then
      num_t = num1 + 1
    end
    local target = LuaSkillCtrl:CallTargetSelect(self, 60, 10)
    if target ~= nil and target.Count > 0 and (target[0]).targetRole ~= nil then
      local targetRole = (target[0]).targetRole
      LuaSkillCtrl:CallEffectWithArgOverride(targetRole, (self.config).effectId_skill, self, role, false, false, self.OnEffectTrigger, num_t, targetRole)
    end
  end
end

bs_102506.OnEffectTrigger = function(self, num, targetRole, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_skill and eventId == eBattleEffectEvent.Trigger and targetRole ~= nil then
    LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId_CH, num)
  end
end

bs_102506.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_102506

