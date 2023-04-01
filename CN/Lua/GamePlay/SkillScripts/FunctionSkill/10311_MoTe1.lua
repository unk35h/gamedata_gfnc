-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10311 = class("bs_10311", LuaSkillBase)
local base = LuaSkillBase
bs_10311.config = {buffId = 1228, buffTier = 1, buffDuration = 180}
bs_10311.ctor = function(self)
  -- function num : 0_0
end

bs_10311.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10310_1", 10, self.OnAfterBattleStart)
  self.num = 0
end

bs_10311.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 64, 10)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = (targetlist[i]).targetRole
    if targetRole ~= nil then
      do
        local buffTier = targetRole:GetBuffTier((self.config).buffId)
        if buffTier == 0 then
          LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, (self.config).buffTier, (self.config).buffDuration)
          self.num = self.num + 1
        end
        -- DECOMPILER ERROR at PC44: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC44: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  if (self.arglist)[1] > self.num then
    self.num = 0
    self:PlayChipEffect()
  end
end

bs_10311.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10311

