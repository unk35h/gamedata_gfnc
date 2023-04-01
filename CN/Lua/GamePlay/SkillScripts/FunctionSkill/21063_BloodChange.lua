-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21063 = class("bs_21063", LuaSkillBase)
local base = LuaSkillBase
bs_21063.config = {}
bs_21063.ctor = function(self)
  -- function num : 0_0
end

bs_21063.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21063_1", 1, self.OnAfterBattleStart)
  self.Timer = nil
end

bs_21063.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
  self.Timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    local targetlist = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
    if targetlist.Count > 0 then
      local maxTargetRole = (targetlist[0]).targetRole
      local minTargetRole = (targetlist[0]).targetRole
      for i = 0, targetlist.Count - 1 do
        local targetRole = (targetlist[i]).targetRole
        if maxTargetRole.hp // maxTargetRole.maxHp <= targetRole.hp // targetRole.maxHp then
          maxTargetRole = targetRole
        end
        if targetRole.hp // targetRole.maxHp <= minTargetRole.hp // minTargetRole.maxHp then
          minTargetRole = targetRole
        end
      end
      if minTargetRole == maxTargetRole then
        return 
      end
      local value1 = maxTargetRole.maxHp * (maxTargetRole.hp // maxTargetRole.maxHp - minTargetRole.hp // minTargetRole.maxHp)
      local value2 = minTargetRole.maxHp * (maxTargetRole.hp // maxTargetRole.maxHp - minTargetRole.hp // minTargetRole.maxHp)
      LuaSkillCtrl:RemoveLife(value1, self, maxTargetRole, false, nil, true, true, eHurtType.RealDmg)
      LuaSkillCtrl:CallHeal(value2, self, minTargetRole, true)
    end
  end
, nil, -1, (self.arglist)[1])
end

bs_21063.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_21063.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

return bs_21063

