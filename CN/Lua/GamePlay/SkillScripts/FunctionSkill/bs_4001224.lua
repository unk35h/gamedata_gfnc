-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001224 = class("bs_4001224", LuaSkillBase)
local base = LuaSkillBase
bs_4001224.config = {buffId1 = 2073, buffId2 = 2084}
bs_4001224.ctor = function(self)
  -- function num : 0_0
end

bs_4001224.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010419", 1, self.OnAfterHurt, self.caster, nil, nil, eBattleRoleBelong.enemy, nil, nil, nil, nil, false)
end

bs_4001224.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if self.caster ~= sender or isTriggerSet or sender == target or target.belongNum ~= eBattleRoleBelong.enemy then
    return 
  end
  local giant = (self.caster):GetBuffTier((self.config).buffId1)
  if giant == nil or giant < 1 then
    return 
  end
  if giant ~= nil and giant >= 1 then
    LuaSkillCtrl:CallBuffLifeEvent(self, target, (self.config).buffId2, 1, (self.arglist)[2], BindCallback(self, self.OnBuffLifeEvent, target))
  end
end

bs_4001224.OnBuffLifeEvent = function(self, role, lifeType, arg)
  -- function num : 0_3 , upvalues : _ENV
  if lifeType == eBuffLifeEvent.NewAdd then
    LuaSkillCtrl:CallStartLocalScale(role, (Vector3.New)(0.6, 0.6, 0.6), 0.6)
  end
  if lifeType == eBuffLifeEvent.Remove then
    LuaSkillCtrl:CallStartLocalScale(role, (Vector3.New)(1, 1, 1), 0.6)
  end
end

bs_4001224.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001224

