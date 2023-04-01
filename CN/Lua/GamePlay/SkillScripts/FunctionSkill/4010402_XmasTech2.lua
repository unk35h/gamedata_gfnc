-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010402 = class("bs_4010402", LuaSkillBase)
local base = LuaSkillBase
bs_4010402.config = {
heal_config = {baseheal_formula = 9990}
}
bs_4010402.ctor = function(self)
  -- function num : 0_0
end

bs_4010402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.CallSummonerHeal)
end

bs_4010402.CallSummonerHeal = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if ((role.summoner).summonerMaker).belongNum == eBattleRoleBelong.player then
    local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    if targetlist.Count < 1 then
      return 
    end
    for i = 0, targetlist.Count - 1 do
      local targetRole = targetlist[i]
      local value = targetRole.maxHp * (self.arglist)[1] // 1000
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
      LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {value}, true, true)
      skillResult:EndResult()
    end
  end
end

bs_4010402.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010402

