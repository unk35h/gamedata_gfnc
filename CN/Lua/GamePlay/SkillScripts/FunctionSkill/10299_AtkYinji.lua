-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10299 = class("bs_10299", LuaSkillBase)
local base = LuaSkillBase
bs_10299.config = {buffId_shixue = 257}
bs_10299.ctor = function(self)
  -- function num : 0_0
end

bs_10299.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self:AddSetHurtTrigger("bs_10299_1", 10, self.OnSetHurt, self.caster)
  self.attackNum = 0
end

bs_10299.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.skill).isCommonAttack and not context.isMiss and context.sender == self.caster and context.isTriggerSet ~= true and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey then
    if (context.target).belongNum == 0 and (context.target).career == 1 then
      return 
    end
    self.attackNum = self.attackNum + 1
    self:CheckAndAddBuffToTarget(context.sender)
  end
end

bs_10299.CheckAndAddBuffToTarget = function(self, sender)
  -- function num : 0_3 , upvalues : _ENV
  if sender ~= nil and sender.hp > 0 and (self.arglist)[1] <= self.attackNum then
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId_shixue, (self.arglist)[2])
    self.attackNum = 0
  end
end

bs_10299.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10299

