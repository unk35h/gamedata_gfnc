-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25006 = class("bs_25006", LuaSkillBase)
local base = LuaSkillBase
bs_25006.config = {buffId = 110075}
bs_25006.ctor = function(self)
  -- function num : 0_0
end

bs_25006.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_25006_2", 99, self.OnSetHurt, nil, nil, (self.caster).belongNum)
  self:AddAfterHurtTrigger("bs_25006_3", 1, self.OnAfterHurt, nil, nil, (self.caster).belongNum)
end

bs_25006.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.hurt > 0 and context.isTriggerSet ~= true and context.isCrit and (context.target).belongNum ~= (self.caster).belongNum and (context.sender).belongNum == (self.caster).belongNum then
    local sender = context.sender
    local target = context.target
    local debuffNum = 0
    local buffs = LuaSkillCtrl:GetRoleBuffs(target)
    if buffs ~= nil and buffs.Count > 0 then
      for i = 0, buffs.Count - 1 do
        if (buffs[i]).buffType == 2 then
          debuffNum = debuffNum + 1
        end
      end
    end
    do
      if debuffNum > 30 then
        debuffNum = 30
      end
      if debuffNum > 0 then
        LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId, debuffNum, nil, true)
      end
    end
  end
end

bs_25006.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and isCrit and self:IsReadyToTake() then
    self:OnSkillTake()
    local buffTier = sender:GetBuffTier((self.config).buffId)
    if buffTier > 0 then
      LuaSkillCtrl:DispelBuff(sender, (self.config).buffId, 0, true, true)
    end
  end
end

bs_25006.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25006

