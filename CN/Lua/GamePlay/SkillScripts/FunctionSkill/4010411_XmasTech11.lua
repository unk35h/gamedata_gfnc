-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010411 = class("bs_4010411", LuaSkillBase)
local base = LuaSkillBase
bs_4010411.config = {buffId = 110072}
bs_4010411.ctor = function(self)
  -- function num : 0_0
end

bs_4010411.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.CallSummonerBuff)
end

bs_4010411.CallSummonerBuff = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if ((role.summoner).summonerMaker).belongNum == eBattleRoleBelong.player then
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1, (self.arglist)[1], true)
  end
end

bs_4010411.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010411

