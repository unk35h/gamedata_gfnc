-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30049 = class("bs_30049", LuaSkillBase)
local base = LuaSkillBase
bs_30049.config = {buffId = 110008}
bs_30049.ctor = function(self)
  -- function num : 0_0
end

bs_30049.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_30049_1", 1, self.OnAfterBattleStart)
end

bs_30049.OnAfterBattleStart = function(self, isMidway)
  -- function num : 0_2 , upvalues : _ENV
  if not isMidway then
    return 
  end
  if self.caster == nil then
    return 
  end
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 50)
  if targetList == nil or targetList.Count < 1 then
    return 
  end
  for i = 0, targetList.Count - 1 do
    LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId, 1, nil)
  end
end

bs_30049.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30049

