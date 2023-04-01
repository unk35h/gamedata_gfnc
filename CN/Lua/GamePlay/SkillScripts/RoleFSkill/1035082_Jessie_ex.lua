-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1035082 = class("bs_1035082", LuaSkillBase)
local base = LuaSkillBase
bs_1035082.config = {buffId_253 = 253}
bs_1035082.ctor = function(self)
  -- function num : 0_0
end

bs_1035082.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBeforeAddBuffTrigger("bs_1035082_beforeBuff", 1, self.OnBeforeAddBuff, nil, self.caster, nil, nil, nil, eBuffType.Debeneficial)
end

bs_1035082.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.buff).buffType == 2 and target == self.caster and target:GetBuffTier((self.config).buffId_253) == 0 then
    context.active = false
    local parentBuffId = LuaSkillCtrl:GetSkillBindBuffId(self)
    if parentBuffId > 0 then
      LuaSkillCtrl:DispelBuff(self.caster, parentBuffId, 1)
    end
  end
end

bs_1035082.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1035082

