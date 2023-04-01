-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94117 = class("bs_94117", LuaSkillBase)
local base = LuaSkillBase
bs_94117.config = {}
bs_94117.ctor = function(self)
  -- function num : 0_0
end

bs_94117.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_94117_11", 1, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_94117_2", 1, self.OnAfterBattleStart)
end

bs_94117.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 9, 0)
  if targetlist == nil then
    return 
  end
  if ((targetlist[0]).targetRole).roleDataId == 20071 then
    LuaSkillCtrl:StartAvgWithPauseGame("22summer_s14_2", nil, nil)
  else
    if ((targetlist[0]).targetRole).roleDataId == 20069 then
      LuaSkillCtrl:StartAvgWithPauseGame("22summer_s15_4", nil, nil)
    end
  end
end

bs_94117.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_3 , upvalues : _ENV
  if role.roleDataId == 20068 then
    LuaSkillCtrl:StartAvgWithPauseGame("22summer_s14_4", nil, nil)
  else
    if role.roleDataId == 20069 then
      LuaSkillCtrl:StartAvgWithPauseGame("22summer_s15_5", nil, nil)
    end
  end
end

bs_94117.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94117

