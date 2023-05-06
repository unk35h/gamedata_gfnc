-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001028 = class("bs_4001028", LuaSkillBase)
local base = LuaSkillBase
bs_4001028.config = {buffId = 2022}
bs_4001028.ctor = function(self)
  -- function num : 0_0
end

bs_4001028.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnRealSummonerCaster)
end

bs_4001028.OnRealSummonerCaster = function(self, summonerEntity)
  -- function num : 0_2 , upvalues : _ENV
  if (summonerEntity.recordTable).VampireFlag ~= true then
    LuaSkillCtrl:CallBuff(self, summonerEntity, (self.config).buffId, 1, nil, true)
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (summonerEntity.recordTable).VampireFlag = true
  end
end

bs_4001028.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001028

