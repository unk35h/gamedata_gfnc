-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6011 = class("bs_6011", LuaSkillBase)
local base = LuaSkillBase
bs_6011.config = {}
bs_6011.ctor = function(self)
  -- function num : 0_0
end

bs_6011.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_6011_3", 1, self.OnSetHurt, self.caster)
end

bs_6011.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster then
    local buffs = LuaSkillCtrl:GetRoleBuffs(context.target)
    local times = 0
    if buffs ~= nil and buffs.Count > 0 then
      for i = 0, buffs.Count - 1 do
        if (buffs[i]).buffType == 2 and times < (self.arglist)[2] then
          times = times + 1
        end
      end
    end
    do
      if times ~= 0 then
        context.hurt = LuaSkillCtrl:CallFormulaNumberWithSkill(601101, self.caster, self.caster, self, context.hurt, times)
      end
    end
  end
end

bs_6011.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6011

