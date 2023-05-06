-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92082 = class("bs_92082", LuaSkillBase)
local base = LuaSkillBase
bs_92082.config = {buffId = 195, buffDuration = 75, buffId1 = 2094}
bs_92082.ctor = function(self)
  -- function num : 0_0
end

bs_92082.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92082_1", 1, self.OnAfterHurt, nil, nil, eBattleRoleBelong.player, eBattleRoleBelong.enemy, nil, nil, nil, nil, false)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_92082_2", 1, self.OnBattleStart)
  self.isCalledBuff = false
end

bs_92082.OnBattleStart = function(self)
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

bs_92082.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R9 in 'UnsetPending'

  if hurtType == eHurtType.PhysicsDmg and not isMiss and sender.belongNum == eBattleRoleBelong.player and not isTriggerSet then
    if (target.recordTable).bs_92082 == nil then
      (target.recordTable).bs_92082 = 0
    end
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (target.recordTable).bs_92082 = (target.recordTable).bs_92082 + 1
    if (self.arglist)[2] <= (target.recordTable).bs_92082 and self:IsReadyToTake() then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, (self.config).buffDuration, false)
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (target.recordTable).bs_92082 = 0
      self:OnSkillTake()
    end
  end
end

bs_92082.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92082

