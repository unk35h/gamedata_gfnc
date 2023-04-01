-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21018 = class("bs_21018", LuaSkillBase)
local base = LuaSkillBase
bs_21018.config = {}
bs_21018.ctor = function(self)
  -- function num : 0_0
end

bs_21018.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21018_1", 1, self.OnAfterBattleStart)
  self.Timer = nil
end

bs_21018.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
  self.Timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    local highAttRole = LuaSkillCtrl:CallTargetSelect(self, 46, 20)
    if highAttRole ~= nil and highAttRole.Count > 0 and highAttRole[0] ~= nil then
      local value = ((highAttRole[0]).targetRole).skill_intensity * (self.arglist)[2] // 1000
      local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
      if targetlist.Count > 0 then
        for i = 0, targetlist.Count - 1 do
          local targetRole = targetlist[i]
          LuaSkillCtrl:CallHeal(value, self, targetRole, true)
        end
      end
    end
  end
, nil, -1)
end

bs_21018.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

bs_21018.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

return bs_21018

