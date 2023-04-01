-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101606 = class("bs_101606", LuaSkillBase)
local base = LuaSkillBase
bs_101606.config = {buffId_color = 101601, effectId_big = 101603, buffId_speed = 101603, buffId_slow = 101604}
bs_101606.ctor = function(self)
  -- function num : 0_0
end

bs_101606.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_101606_3", 1, self.OnAfterHurt)
  self:AddBuffDieTrigger("bs_101606_5", 90, self.OnBuffDie, nil, nil, (self.config).buffId_color)
  self.effect = {}
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_101606_4", 1, self.OnAfterPlaySkill)
end

bs_101606.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and not isMiss and skill.isCommonAttack then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_color, 1)
  end
  if sender == self.caster and not skill.isCommonAttack and (skill.dataId == 101602 or skill.dataId == 101605) and isTriggerSet ~= true and ((self.caster).recordTable).skill_target == target then
    local effect = LuaSkillCtrl:CallEffect(target, (self.config).effectId_big, self)
    do
      (table.insert)(self.effect, effect)
      local collisionEnter = BindCallback(self, self.OnCollisionEnter)
      LuaSkillCtrl:CallAddCircleColliderForEffect(effect, 100, eColliderInfluenceType.Enemy, nil, collisionEnter, nil)
      LuaSkillCtrl:StartTimer(nil, 75, function()
    -- function num : 0_2_0 , upvalues : effect, _ENV
    if effect == nil then
      return 
    end
    LuaSkillCtrl:ClearColliderOrEmission(effect.collider)
    effect:Die()
    effect = nil
  end
)
      -- DECOMPILER ERROR at PC69: Confused about usage of register: R11 in 'UnsetPending'

      ;
      ((self.caster).recordTable).skill_target = nil
    end
  end
  do
    if sender.belongNum ~= (self.caster).belongNum and isMiss and sender:GetBuffTier((self.config).buffId_color) > 0 then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_speed, 1)
      LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId_slow, 1, (self.arglist)[4])
    end
  end
end

bs_101606.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  if role == self.caster and skill.isNormalSkill then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_speed, 1)
  end
end

bs_101606.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
  if target.belongNum ~= (self.caster).belongNum and self.effect ~= nil then
    for _,v in ipairs(self.effect) do
      if v ~= nil then
        v:Die()
      end
    end
    self.effect = nil
    self.effect = {}
  end
end

bs_101606.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_5 , upvalues : _ENV
  if entity ~= nil and entity.hp > 0 and entity.belongNum ~= (self.caster).belongNum and not entity:IsUnSelect(self.caster) and entity.belongNum ~= eBattleRoleBelong.neutral then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_color, 1)
  end
end

bs_101606.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_101606.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  (base.LuaDispose)(self)
  self.effect = nil
end

return bs_101606

