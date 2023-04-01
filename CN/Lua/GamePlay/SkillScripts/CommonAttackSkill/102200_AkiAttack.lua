-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_102200 = class("bs_102200", bs_1)
local base = bs_1
bs_102200.config = {effectId_start1 = 102204, effectId_start2 = 102205, action1 = 1001, action2 = 1004, effectId_hit1 = 102206, effectId_hit2 = 102207, effectId_Chit1 = 102208, effectId_Chit2 = 102209, audioId1 = 230, audioId2 = 231, audioId3 = 232, buffId_weapon2 = 102204}
bs_102200.config = setmetatable(bs_102200.config, {__index = base.config})
bs_102200.ctor = function(self)
  -- function num : 0_0
end

bs_102200.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_102200_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, 102200)
end

bs_102200.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_2 , upvalues : _ENV, base
  self.actionId = atkActionId
  if ((self.caster).recordTable).weapon2 == true then
    local num1 = ((self.caster).recordTable).weapon2_target
    local num2 = ((self.caster).recordTable).weapon2_caster
    local num = (1000 - target.hp * 1000 // target.maxHp) // num1 * num2
    if ((self.caster).recordTable).weapon2_max < num then
      num = ((self.caster).recordTable).weapon2_max
    end
    local time = ((self.caster).recordTable).weapon2_time
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_weapon2, 0, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_weapon2, num, time, true)
  end
  do
    ;
    (base.OnAttackTrigger)(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  end
end

bs_102200.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and not isMiss and skill.dataId == 102200 then
    local effect_now = nil
    if not isCrit then
      if self.actionId == (self.config).action1 then
        effect_now = (self.config).effectId_hit1
      else
        effect_now = (self.config).effectId_hit2
      end
    end
    if isCrit then
      if self.actionId == (self.config).action1 then
        effect_now = (self.config).effectId_Chit1
      else
        effect_now = (self.config).effectId_Chit2
      end
    end
    LuaSkillCtrl:CallEffect(target, effect_now, self)
    self.actionId = nil
  end
end

bs_102200.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_102200

