-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93005 = class("bs_93005", LuaSkillBase)
local base = LuaSkillBase
bs_93005.config = {effectId = 10969}
bs_93005.ctor = function(self)
  -- function num : 0_0
end

bs_93005.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_93005_1", 1, self.OnAfterBattleStart)
end

bs_93005.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1, (self.arglist)[1])
end

bs_93005.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  if targetlist ~= nil and targetlist.Count > 0 then
    local targetSelect = nil
    for i = 0, targetlist.Count - 1 do
      if ((targetlist[i]).targetRole).intensity < 3 and targetSelect == nil then
        targetSelect = (targetlist[i]).targetRole
      else
        if ((targetlist[i]).targetRole).intensity < 3 and targetSelect.hp < ((targetlist[i]).targetRole).hp then
          targetSelect = (targetlist[i]).targetRole
        end
      end
    end
    if targetSelect ~= nil then
      local damage = targetSelect.maxHp * (self.arglist)[2] // 1000
      LuaSkillCtrl:RemoveLife(damage, self, targetSelect, true, nil, true, true)
      LuaSkillCtrl:CallEffect(targetSelect, (self.config).effectId, self, self.SkillEventFunc)
    end
  end
end

bs_93005.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_93005

