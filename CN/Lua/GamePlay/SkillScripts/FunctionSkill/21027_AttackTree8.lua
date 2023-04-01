-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21027 = class("bs_21027", LuaSkillBase)
local base = LuaSkillBase
bs_21027.config = {buffId = 110020, effectId = 10950}
bs_21027.ctor = function(self)
  -- function num : 0_0
end

bs_21027.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_10323_10", 1, self.OnRoleDie, nil, nil, nil, (self.caster).belongNum, nil, nil, nil)
  self:AddBeforeBuffDispelTrigger("bs_21027_1", 1, self.BeforeBuffDispel, nil, eBattleRoleBelong.player, (self.config).buffId)
  self:AddBuffDieTrigger("bs_21027_2", 1, self.OnBuffDie, nil, eBattleRoleBelong.player, (self.config).buffId)
end

bs_21027.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == (self.caster).belongNum and role.roleType == 1 then
    local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    if targetlist.Count < 1 then
      return 
    end
    for i = 0, targetlist.Count - 1 do
      local targetRole = targetlist[i]
      if targetRole:GetBuffTier((self.config).buffId) >= 1 then
        LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 1)
      end
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, 60)
      LuaSkillCtrl:CallStartLocalScale(targetRole, (Vector3.New)(1.2, 1.2, 1.2), 0.2)
    end
  end
end

bs_21027.BeforeBuffDispel = function(self, targetRole, context)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId, self)
  LuaSkillCtrl:CallStartLocalScale(targetRole, (Vector3.New)(1, 1, 1), 0.2)
end

bs_21027.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
  if buff.dataId == (self.config).buffId then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
    LuaSkillCtrl:CallStartLocalScale(target, (Vector3.New)(1, 1, 1), 0.2)
  end
end

bs_21027.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21027

