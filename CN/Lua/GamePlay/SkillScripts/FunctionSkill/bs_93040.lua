-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93040 = class("bs_93040", LuaSkillBase)
local base = LuaSkillBase
bs_93040.config = {buffId = 2073}
bs_93040.ctor = function(self)
  -- function num : 0_0
end

bs_93040.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_93040.OnBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local value = LuaSkillCtrl:GetCacheGold() // (self.arglist)[1]
  local target1 = self:findMaxPow()
  local target2 = self:findMaxMagic()
  LuaSkillCtrl:CallBuff(self, target1.targetRole, (self.config).buffId, 1, nil, false)
  LuaSkillCtrl:CallBuff(self, target2.targetRole, (self.config).buffId, 1, nil, false)
end

bs_93040.findMaxPow = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (LuaSkillCtrl:CallTargetSelect(self, 59, 10))
  local targetList = nil
  local target = nil
  local i = 0
  while 1 do
    if target == nil or (target.targetRole).roleType ~= eBattleRoleType.character then
      target = targetList[i]
      i = i + 1
      -- DECOMPILER ERROR at PC18: LeaveBlock: unexpected jumping out IF_THEN_STMT

      -- DECOMPILER ERROR at PC18: LeaveBlock: unexpected jumping out IF_STMT

    end
  end
  return target
end

bs_93040.findMaxMagic = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (LuaSkillCtrl:CallTargetSelect(self, 64, 10))
  local targetList = nil
  local target = nil
  local i = 0
  while 1 do
    if target == nil or (target.targetRole).roleType ~= eBattleRoleType.character then
      target = targetList[i]
      i = i + 1
      -- DECOMPILER ERROR at PC18: LeaveBlock: unexpected jumping out IF_THEN_STMT

      -- DECOMPILER ERROR at PC18: LeaveBlock: unexpected jumping out IF_STMT

    end
  end
  return target
end

bs_93040.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93040

