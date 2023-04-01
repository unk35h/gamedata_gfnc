-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10312 = class("bs_10312", LuaSkillBase)
local base = LuaSkillBase
bs_10312.config = {buffId = 1228, buffTier = 1, buffDuration = 180}
bs_10312.ctor = function(self)
  -- function num : 0_0
end

bs_10312.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_10312_11", 1, self.OnRoleDie)
  self.num = 0
end

bs_10312.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_2 , upvalues : _ENV
  if killer == self.caster and self:IsReadyToTake() then
    self:OnSkillTake()
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
          -- DECOMPILER ERROR at PC53: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC53: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    if (self.arglist)[1] > self.num then
      self.num = 0
      self:PlayChipEffect()
    end
  end
end

bs_10312.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10312

