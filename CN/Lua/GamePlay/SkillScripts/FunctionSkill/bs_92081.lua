-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92081 = class("bs_92081", LuaSkillBase)
local base = LuaSkillBase
bs_92081.config = {buffId = 1227, buffDuration = 90, buffId1 = 2093}
bs_92081.ctor = function(self)
  -- function num : 0_0
end

bs_92081.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92081_1", 1, self.OnAfterHurt, nil, nil, eBattleRoleBelong.player, eBattleRoleBelong.enemy, nil, nil, nil, nil, false)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_92081_2", 1, self.OnBattleStart)
  self.breakTier = (self.arglist)[2]
  self.isCalledBuff = false
end

bs_92081.OnBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.isCalledBuff ~= false then
    return 
  end
  local targetRoleList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if targetRoleList == nil or targetRoleList.Count < 1 then
    return 
  end
  for i = 0, targetRoleList.Count - 1 do
    LuaSkillCtrl:CallBuff(self, targetRoleList[i], (self.config).buffId1, 1, nil, true)
  end
  self.isCalledBuff = true
end

bs_92081.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R9 in 'UnsetPending'

  if sender.belongNum == eBattleRoleBelong.player and hurtType == eHurtType.MagicDmg and not isMiss and not isTriggerSet then
    if (target.recordTable).bs_92081 == nil then
      (target.recordTable).bs_92081 = 0
    end
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (target.recordTable).bs_92081 = (target.recordTable).bs_92081 + 1
    if self.breakTier <= (target.recordTable).bs_92081 and self:IsReadyToTake() then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, (self.config).buffDuration, false)
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (target.recordTable).bs_92081 = 0
      self:OnSkillTake()
    end
  end
end

bs_92081.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92081

