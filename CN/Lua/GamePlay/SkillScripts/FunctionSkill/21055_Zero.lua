-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21055 = class("bs_21055", LuaSkillBase)
local base = LuaSkillBase
bs_21055.config = {}
bs_21055.ctor = function(self)
  -- function num : 0_0
end

bs_21055.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21055_1", 1, self.OnAfterBattleStart)
  self.Timer = nil
end

bs_21055.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
  self.Timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : self, _ENV
    local skills = (self.caster):GetBattleSkillList()
    if skills ~= nil then
      local count = skills.Count
      if count > 0 then
        for i = 0, count - 1 do
          local curCd = (skills[i]).totalCDTime * -1 * (self.arglist)[2] // 1000
          if not (skills[i]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[i], curCd)
          end
        end
      end
    end
  end
, nil, -1, 0)
end

bs_21055.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

bs_21055.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

return bs_21055

