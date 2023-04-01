-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_201801 = require("GamePlay.SkillScripts.MonsterSkill.201801_ZYZ_RefactorSummon")
local bs_204604 = class("bs_204604", bs_201801)
local base = bs_201801
bs_204604.config = {
middleMonsterId = {20, 23, 20}
, maxHpPer = 150, powPer = 700, buffId = 1033, effectId = 10264, effectId1 = 10263, startAnimID = 1002, maxEnemyNum = 8, maxSummonNum = 10, buffId_196 = 196, buffId_1033 = 1033, buffId_3016 = 3016, skill_time = 18, audioId1 = 300}
bs_204604.config = setmetatable(bs_204604.config, {__index = base.config})
bs_204604.ctor = function(self)
  -- function num : 0_0
end

bs_204604.OnAfterBattleStart = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.damTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.CallBack, self, -1, (self.arglist)[1])
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1033, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_3016, 1, nil, true)
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["40035_SummonTime"] = 0
  self.index = 1
end

bs_204604.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_2 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_204604.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204604

