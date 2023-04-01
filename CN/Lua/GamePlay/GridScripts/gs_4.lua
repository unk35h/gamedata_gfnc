-- params : ...
-- function num : 0 , upvalues : _ENV
local gs_4 = class("gs_4", LuaGridBase)
gs_4.config = {effectId = 10261, buffId = 1032, buffTier = 1, damageIncreaseBuffId = 3065001}
gs_4.ctor = function(self)
  -- function num : 0_0
end

gs_4.OnGridBattleStart = function(self, role)
  -- function num : 0_1
  if role == nil then
    self:GridLoseEffect()
  end
end

gs_4.ExtraDamageIncrease = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum ~= eBattleRoleBelong.player then
    return 
  end
  local skillCaster = ((LuaSkillCtrl.battleCtrl).PlayerController).SkillCasterEntity
  if skillCaster == nil then
    return 
  end
  local skillCasterAttr = skillCaster.trueDamage
  if skillCasterAttr <= 0 then
    return 
  end
  LuaSkillCtrl:CallBuff(self, role, (self.config).damageIncreaseBuffId, 1, nil, false, skillCaster)
end

gs_4.OnGridEnterRole = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  self:ExtraDamageIncrease(role)
  if role.roleDataId == 1008 then
    LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
    self:GridLoseEffect()
    return 
  end
  if role.attackRange > 1 then
    LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
    local targetlist = LuaSkillCtrl:CallTargetSelectWithCskill(self.cskill, 21, 10, role)
    if targetlist.Count < 1 then
      return 
    end
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (role.recordTable).lastAttackRole = (targetlist[0]).targetRole
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, (self.config).buffTier)
    self:GridLoseEffect()
  else
    do
      self:GridLoseEffect()
    end
  end
end

gs_4.OnGridExitRole = function(self, role)
  -- function num : 0_4
end

gs_4.OnGridRoleDead = function(self, role)
  -- function num : 0_5
end

return gs_4

