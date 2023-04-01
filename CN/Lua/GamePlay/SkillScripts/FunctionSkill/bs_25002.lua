-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25002 = class("bs_25002", LuaSkillBase)
local base = LuaSkillBase
bs_25002.config = {buffId = 110073, selectTargetId = 501101}
bs_25002.ctor = function(self)
  -- function num : 0_0
end

bs_25002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_25002_1", 1, self.OnAfterBattleStart)
end

bs_25002.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectTargetId, 10)
  if targetlist == nil or targetlist.Count <= 0 then
    return 
  end
  local tempCareerDict = {}
  local differentCareer = 0
  for i = 0, targetlist.Count - 1 do
    local v = targetlist[i]
    local curCareer = (v.targetRole).career
    if not tempCareerDict[curCareer] then
      tempCareerDict[curCareer] = true
      differentCareer = differentCareer + 1
    end
  end
  if differentCareer <= 0 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local role = (targetlist[i]).targetRole
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, differentCareer)
    role:UpdateHp()
  end
end

bs_25002.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25002

