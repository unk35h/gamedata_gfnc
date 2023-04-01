-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80008 = class("bs_80008", LuaSkillBase)
local base = LuaSkillBase
bs_80008.config = {}
bs_80008.ctor = function(self)
  -- function num : 0_0
end

bs_80008.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_80008_3", 1, self.OnAfterAddBuff, self.caster)
end

bs_80008.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if buff:ContainFeature(eBuffFeatureType.Stun) and target.belongNum ~= (self.caster).belongNum then
    local down = (self.arglist)[1]
    LuaSkillCtrl:CallResetCDNumForRole(self.caster, down)
  end
end

bs_80008.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80008

