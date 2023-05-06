-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20229 = class("bs_20229", LuaSkillBase)
local base = LuaSkillBase
bs_20229.config = {buffId = 2073, 
ScaleTable = {1.3, 1.4, 1.6, 1.8, 1.8}
}
bs_20229.ctor = function(self)
  -- function num : 0_0
end

bs_20229.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_20229_1", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, (self.config).buffId, nil, nil)
end

bs_20229.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if buff.dataID == (self.config).dataID and target == self.caster then
    local buffTier = (self.caster):GetBuffTier((self.config).buffId)
    if buffTier == nil or buffTier < 1 then
      buffTier = 1
    end
    local scale = ((self.config).ScaleTable)[buffTier]
    LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(scale, scale, scale), 0.4)
  end
end

bs_20229.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20229

