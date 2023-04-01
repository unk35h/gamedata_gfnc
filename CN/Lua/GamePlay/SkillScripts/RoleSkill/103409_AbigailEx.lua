-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103409 = class("bs_103409", LuaSkillBase)
local base = LuaSkillBase
bs_103409.config = {}
bs_103409.ctor = function(self)
  -- function num : 0_0
end

bs_103409.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.num = 0
  self.Damage = 0
  self.crit_base = 0
  self:AddBuffDieTrigger("bs_103409_2", 1, self.OnBuffDie, self.caster, nil, 103403)
  self:OnCasterAttributeChange()
end

bs_103409.OnCasterAttributeChange = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).crit > 1000 and self.num == 0 then
    local critNum = ((self.caster).recordTable).Crit
    local hurtNum = ((self.caster).recordTable).CritHurt
    local hurtMax = ((self.caster).recordTable).CritMax
    local num = ((self.caster).crit - 1000) * hurtNum // critNum
    if hurtMax < num then
      num = hurtMax
    end
    do
      if num ~= self.Damage then
        local change = num - self.Damage
        ;
        (self.caster):AddRoleProperty(eHeroAttr.critDamage, change, eHeroAttrType.Extra)
        self.Damage = num
      end
      self.num = 1
      self.crit_base = (self.caster).crit
    end
  end
end

bs_103409.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_3 , upvalues : _ENV
  if buff.dataId == 103403 and self.Damage ~= 0 then
    (self.caster):AddRoleProperty(eHeroAttr.critDamage, -self.Damage, eHeroAttrType.Extra)
    self.Damage = 0
  end
end

bs_103409.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_103409

