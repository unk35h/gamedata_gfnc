-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_50024 = class("bs_50024", LuaSkillBase)
local base = LuaSkillBase
bs_50024.config = {buffId = 1257, buffDuration = 30, 
heal_config = {baseheal_formula = 1047, heal_number = 0, correct_formula = 9990}
, 
hurt_config = {hit_formula = 0, basehurt_formula = 1047, crit_formula = 0}
, damageFormula = 10189, damageFormula1 = 10191, gridId = 1125}
bs_50024.ctor = function(self)
  -- function num : 0_0
end

bs_50024.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_50024_1", 1, self.OnAfterMove)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRoleSplash, self.OnRoleSplash)
  do
    if isMidwaySkill then
      local arriveCallBack = BindCallback(self, self.OnArriveAction)
      if self.timer == nil then
        self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).buffDuration - 1, arriveCallBack, nil, -1, (self.config).buffDuration - 15)
      end
    end
    self:AddLuaTrigger(eSkillLuaTrigger.OnOdetteHalfHp, self.OnOdetteHalfHp)
    self.halfHp = false
  end
end

bs_50024.OnOdetteHalfHp = function(self, target, sender, skill)
  -- function num : 0_2 , upvalues : _ENV
  if self.halfHp == ture then
    return 
  end
  self.halfHp = ture
end

bs_50024.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  if (self.caster).camp == 2 and (self.caster).belongNum == 2 then
    return 
  end
  local damage = nil
  if self.halfHp == ture then
    local buffTier = (self.caster):GetBuffTier((self.config).buffId)
    local sectorTechRate = LuaSkillCtrl:GetPlayerRealAttribute(2)
    damage = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).damageFormula1, self.caster, self.caster, self, sectorTechRate, buffTier)
  else
    do
      local buffTier = (self.caster):GetBuffTier((self.config).buffId)
      do
        local sectorTechRate = LuaSkillCtrl:GetPlayerRealAttribute(2)
        damage = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).damageFormula, self.caster, self.caster, self, sectorTechRate, buffTier)
        LuaSkillCtrl:RemoveLife(damage, self, self.caster, true, nil, true, true)
        LuaSkillCtrl:CallBuff(self, self.caster, 1257, 1, nil, true)
      end
    end
  end
end

bs_50024.OnSkillRemove = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnSkillRemove)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_50024.OnAfterMove = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local GridId = LuaSkillCtrl:GetRoleEfcGrid(self.caster)
  if GridId ~= (self.config).gridId then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_50024.OnRoleSplash = function(self, role, grid)
  -- function num : 0_6 , upvalues : _ENV
  if role == self.caster and role.curCoord == grid.coord then
    local GridId = LuaSkillCtrl:GetRoleEfcGrid(self.caster)
    if GridId ~= (self.config).gridId then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
    end
  end
end

bs_50024.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_50024

