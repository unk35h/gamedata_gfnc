-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001218 = class("bs_4001218", LuaSkillBase)
local base = LuaSkillBase
bs_4001218.config = {buffId = 2021}
bs_4001218.ctor = function(self)
  -- function num : 0_0
end

bs_4001218.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.ReCallBuff)
  self:AddOnRoleDieTrigger("bs_4001218_1", 2, self.ReCallBuff)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4001218_2", 1, self.ReCallBuff)
end

bs_4001218.ReCallBuff = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local PlayerList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  local EnemyList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  for i = 0, PlayerList.Count - 1 do
    LuaSkillCtrl:DispelBuff(PlayerList[i], (self.config).buffId, 0)
  end
  for i = 0, EnemyList.Count - 1 do
    LuaSkillCtrl:DispelBuff(EnemyList[i], (self.config).buffId, 0)
  end
  local buffTier = (math.abs)(PlayerList.Count - EnemyList.Count)
  if PlayerList.Count - EnemyList.Count < 0 then
    for i = 0, EnemyList.Count - 1 do
      LuaSkillCtrl:CallBuff(self, EnemyList[i], (self.config).buffId, buffTier)
    end
  end
  do
    if PlayerList.Count - EnemyList.Count > 0 then
      for i = 0, PlayerList.Count - 1 do
        LuaSkillCtrl:CallBuff(self, PlayerList[i], (self.config).buffId, buffTier)
      end
    end
  end
end

bs_4001218.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001218

