-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15108 = class("bs_15108", LuaSkillBase)
local base = LuaSkillBase
bs_15108.config = {buffId1 = 3004, buffId2 = 110088}
bs_15108.ctor = function(self)
  -- function num : 0_0
end

bs_15108.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.CallBuff)
  self:AddOnRoleDieTrigger("bs_4001218_1", 2, self.CallBuff)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4001218_2", 1, self.CallBuff)
end

bs_15108.CallBuff = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local num = 0
  local PlayerList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  for i = 0, PlayerList.Count - 1 do
    if (PlayerList[i]).roleType == eBattleRoleType.character then
      num = num + 1
    end
  end
  if num == 1 then
    self:RemoveSkillTrigger(eSkillTriggerType.RoleDie)
    self:UnRegisterLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster)
    for i = 0, PlayerList.Count - 1 do
      if (PlayerList[i]).roleType == eBattleRoleType.character then
        LuaSkillCtrl:CallBuff(self, PlayerList[i], (self.config).buffId1, 1, (self.arglist)[2], false)
        LuaSkillCtrl:CallBuff(self, PlayerList[i], (self.config).buffId2, 1, (self.arglist)[2], false)
      end
    end
  end
end

bs_15108.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15108

