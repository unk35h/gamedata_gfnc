-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6025 = class("bs_6025", LuaSkillBase)
local base = LuaSkillBase
bs_6025.config = {buffId_1 = 602501}
bs_6025.ctor = function(self)
  -- function num : 0_0
end

bs_6025.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_106201_7", 1, self.OnAfterAddBuff, self.caster, nil, nil, nil, nil, 2)
end

bs_6025.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if buff.buffType == 2 and target.belonfNum ~= (self.caster).belongNum then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_1, 1, (self.arglist)[2], true)
  end
end

bs_6025.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6025

