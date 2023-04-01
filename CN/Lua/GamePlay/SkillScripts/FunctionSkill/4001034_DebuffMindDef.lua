-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001034 = class("bs_4001034", LuaSkillBase)
local base = LuaSkillBase
bs_4001034.config = {buffId = 2015}
bs_4001034.ctor = function(self)
  -- function num : 0_0
end

bs_4001034.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_4001034_1", 1, self.OnAfterAddBuff, nil, nil, nil, nil, nil, eBuffType.Debeneficial)
  self:AddBeforeBuffDispelTrigger("bs_4001034_2", 2, self.BeforeBuffDispel, nil, nil, nil, eBuffType.Debeneficial)
  self:AddAfterBuffRemoveTrigger("bs_4001034_buff_die", 4, self.AfterBuffRemove, nil, nil, nil, eBuffType.Debeneficial)
end

bs_4001034.AfterBuffRemove = function(self, buffId, target, removeType)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum ~= eBattleRoleBelong.player then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId, 0, true)
    local buffTier = self:GetDebuffNum(target)
    if buffTier > 0 then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, nil, true)
    end
  end
end

bs_4001034.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  if target.belongNum ~= eBattleRoleBelong.player then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId, 0, true)
    local buffTier = self:GetDebuffNum(target)
    if buffTier > 0 then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, nil, true)
    end
  end
end

bs_4001034.BeforeBuffDispel = function(self, targetRole, context)
  -- function num : 0_4 , upvalues : _ENV
  if targetRole.belongNum ~= eBattleRoleBelong.player then
    LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 0, true)
    local buffTier = self:GetDebuffNum(targetRole)
    if buffTier > 0 then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, nil, true)
    end
  end
end

bs_4001034.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_5 , upvalues : _ENV
  if target.belongNum ~= eBattleRoleBelong.player then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId, 0, true)
    local buffTier = self:GetDebuffNum(target)
    if buffTier > 0 then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, nil, true)
    end
  end
end

bs_4001034.GetDebuffNum = function(self, target)
  -- function num : 0_6 , upvalues : _ENV
  local debuffNum = 0
  local buffs = LuaSkillCtrl:GetRoleBuffs(target)
  local flag = 0
  if buffs == nil then
    return 0
  end
  if buffs.Count <= 0 then
    return 0
  end
  if buffs.Count > 0 then
    for i = 0, buffs.Count - 1 do
      if (buffs[i]).buffType == 2 and (buffs[i]).buffId ~= (self.config).buffId then
        debuffNum = debuffNum + 1
      end
    end
  end
  do
    if debuffNum > 30 then
      debuffNum = 30
    end
    if debuffNum > 0 then
      return debuffNum
    else
      return 0
    end
  end
end

bs_4001034.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001034

