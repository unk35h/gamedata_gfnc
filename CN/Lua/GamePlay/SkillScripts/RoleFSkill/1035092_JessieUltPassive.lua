-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1035092 = class("bs_1035092", LuaSkillBase)
local base = LuaSkillBase
bs_1035092.config = {}
bs_1035092.ctor = function(self)
  -- function num : 0_0
end

bs_1035092.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBeforeAddBuffTrigger("bs_1035092_6", 1, self.OnBeforeAddBuff, nil, self.caster, nil, nil, nil, eBuffType.Debeneficial)
end

bs_1035092.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_2
  if target == self.caster and (context.buff).buffType == 2 then
    context.active = false
  end
end

bs_1035092.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1035092

