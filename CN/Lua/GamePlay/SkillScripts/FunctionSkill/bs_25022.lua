-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25022 = class("bs_25022", LuaSkillBase)
local base = LuaSkillBase
bs_25022.config = {effectId = 10164}
bs_25022.ctor = function(self)
  -- function num : 0_0
end

bs_25022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_25022_1", 1, self.OnAfterBattleStart)
  self.time = nil
end

bs_25022.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.time ~= nil then
    (self.time):stop()
    self.time = nil
  else
    self.time = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.OnCall, self, -1)
  end
end

bs_25022.OnCall = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local skills = (self.caster):GetBattleSkillList()
  if skills ~= nil then
    local count = skills.Count
    if count > 0 then
      for i = 0, count - 1 do
        local curCd = (skills[i]).totalCDTime
        if not (skills[i]).isCommonAttack then
          LuaSkillCtrl:CallResetCDForSingleSkill(skills[i], curCd)
          LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
        end
      end
    end
  end
end

bs_25022.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  if self.timer ~= nil then
    (self.timer):stop()
    self.timer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_25022

