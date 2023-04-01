-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15111 = class("bs_15111", LuaSkillBase)
local base = LuaSkillBase
bs_15111.config = {buffId = 110090}
bs_15111.ctor = function(self)
  -- function num : 0_0
end

bs_15111.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15111_1", 1, self.OnAfterBattleStart)
end

bs_15111.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local value = LuaSkillCtrl:GetCacheGold() // (self.arglist)[1]
  local topvalue = (self.arglist)[3] // 10
  value = (math.min)(topvalue, value)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      if ((targetList[i]).targetRole).roleType == eBattleRoleType.character then
        LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId, value, nil, true)
      end
    end
  end
end

bs_15111.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15111

